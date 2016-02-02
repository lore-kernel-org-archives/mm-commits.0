From: akpm@linux-foundation.org
Subject: +
 kernel-locking-lockdepc-make-lockdep-initialize-itself-on-demand.patch
 added to -mm tree
Date: Tue, 02 Feb 2016 13:18:37 -0800
Message-ID: <56b11d2d.vVw1kB2la7Y+70xF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964891AbcBBVSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 16:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, krinkin.m.u@gmail.com, mingo@elte.hu, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/locking/lockdep.c: make lockdep initialize itself on demand
has been added to the -mm tree.  Its filename is
     kernel-locking-lockdepc-make-lockdep-initialize-itself-on-demand.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-locking-lockdepc-make-lockdep-initialize-itself-on-demand.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-locking-lockdepc-make-lockdep-initialize-itself-on-demand.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/locking/lockdep.c: make lockdep initialize itself on demand

Mike said:

: CONFIG_UBSAN_ALIGNMENT breaks x86-64 kernel with lockdep enabled, i.  e
: kernel with CONFIG_UBSAN_ALIGNMENT fails to load without even any error
: message.
: 
: The problem is that ubsan callbacks use spinlocks and might be called
: before lockdep is initialized.  Particularly this line in the
: reserve_ebda_region function causes problem:
: 
: lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
: 
: If i put lockdep_init() before reserve_ebda_region call in
: x86_64_start_reservations kernel loads well.

Fix this ordering issue permanently: change lockdep so that it ensures
that the hash tables are initialized when they are about to be used.

The overhead will be pretty small: a test-n-branch in places where lockdep
is about to do a lot of work anyway.

Possibly lockdep_initialized should be made __read_mostly.

A better fix would be to simply initialize these (32768 entry) arrays of
empty list_heads at compile time, but I don't think there's a way of
teaching gcc to do this.

We could write a little script which, at compile time, emits a file
containing

	[0] = LIST_HEAD_INIT(__chainhash_table[0]),
	[1] = LIST_HEAD_INIT(__chainhash_table[1]),
	...
	[32767] = LIST_HEAD_INIT(__chainhash_table[32767]),

and then #include this file into lockdep.c.  Sounds like a lot of fuss.

Reported-by: Mike Krinkin <krinkin.m.u@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/locking/lockdep.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff -puN kernel/locking/lockdep.c~kernel-locking-lockdepc-make-lockdep-initialize-itself-on-demand kernel/locking/lockdep.c
--- a/kernel/locking/lockdep.c~kernel-locking-lockdepc-make-lockdep-initialize-itself-on-demand
+++ a/kernel/locking/lockdep.c
@@ -290,9 +290,20 @@ LIST_HEAD(all_lock_classes);
 #define CLASSHASH_BITS		(MAX_LOCKDEP_KEYS_BITS - 1)
 #define CLASSHASH_SIZE		(1UL << CLASSHASH_BITS)
 #define __classhashfn(key)	hash_long((unsigned long)key, CLASSHASH_BITS)
-#define classhashentry(key)	(classhash_table + __classhashfn((key)))
 
-static struct list_head classhash_table[CLASSHASH_SIZE];
+static struct list_head __classhash_table[CLASSHASH_SIZE];
+
+static inline struct list_head *get_classhash_table(void)
+{
+	if (unlikely(!lockdep_initialized))
+		lockdep_init();
+	return __classhash_table;
+}
+
+static inline struct list_head *classhashentry(struct lockdep_subclass_key *key)
+{
+	return get_classhash_table() + __classhashfn(key);
+}
 
 /*
  * We put the lock dependency chains into a hash-table as well, to cache
@@ -301,9 +312,15 @@ static struct list_head classhash_table[
 #define CHAINHASH_BITS		(MAX_LOCKDEP_CHAINS_BITS-1)
 #define CHAINHASH_SIZE		(1UL << CHAINHASH_BITS)
 #define __chainhashfn(chain)	hash_long(chain, CHAINHASH_BITS)
-#define chainhashentry(chain)	(chainhash_table + __chainhashfn((chain)))
 
-static struct list_head chainhash_table[CHAINHASH_SIZE];
+static struct list_head __chainhash_table[CHAINHASH_SIZE];
+
+static struct list_head *chainhashentry(unsigned long chain)
+{
+	if (unlikely(!lockdep_initialized))
+		lockdep_init();
+	return __chainhash_table + __chainhashfn(chain);
+}
 
 /*
  * The hash key of the lock dependency chains is a hash itself too:
@@ -3875,7 +3892,7 @@ void lockdep_reset(void)
 	nr_process_chains = 0;
 	debug_locks = 1;
 	for (i = 0; i < CHAINHASH_SIZE; i++)
-		INIT_LIST_HEAD(chainhash_table + i);
+		INIT_LIST_HEAD(__chainhash_table + i);
 	raw_local_irq_restore(flags);
 }
 
@@ -3929,7 +3946,7 @@ void lockdep_free_key_range(void *start,
 	 * Unhash all classes that were created by this module:
 	 */
 	for (i = 0; i < CLASSHASH_SIZE; i++) {
-		head = classhash_table + i;
+		head = get_classhash_table() + i;
 		if (list_empty(head))
 			continue;
 		list_for_each_entry_rcu(class, head, hash_entry) {
@@ -3986,7 +4003,7 @@ void lockdep_reset_lock(struct lockdep_m
 	 */
 	locked = graph_lock();
 	for (i = 0; i < CLASSHASH_SIZE; i++) {
-		head = classhash_table + i;
+		head = get_classhash_table() + i;
 		if (list_empty(head))
 			continue;
 		list_for_each_entry_rcu(class, head, hash_entry) {
@@ -4027,10 +4044,10 @@ void lockdep_init(void)
 		return;
 
 	for (i = 0; i < CLASSHASH_SIZE; i++)
-		INIT_LIST_HEAD(classhash_table + i);
+		INIT_LIST_HEAD(__classhash_table + i);
 
 	for (i = 0; i < CHAINHASH_SIZE; i++)
-		INIT_LIST_HEAD(chainhash_table + i);
+		INIT_LIST_HEAD(__chainhash_table + i);
 
 	lockdep_initialized = 1;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm-warn-about-vmdata-over-rlimit_data-fix.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
kernel-locking-lockdepc-make-lockdep-initialize-itself-on-demand.patch
mm.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
kernel-locking-lockdepc-make-lockdep-initialize-itself-on-demand-fix.patch

