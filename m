From: akpm@linux-foundation.org
Subject: + kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch
 added to -mm tree
Date: Wed, 03 Feb 2016 12:40:56 -0800
Message-ID: <56b265d8.ejBbtF4Sx8Q6bVy0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbcBCUk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 15:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/locking/lockdep.c: convert hash tables to hlists
has been added to the -mm tree.  Its filename is
     kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch

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
Subject: kernel/locking/lockdep.c: convert hash tables to hlists

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h  |    4 +--
 kernel/locking/lockdep.c |   42 ++++++++++++++++++-------------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff -puN kernel/locking/lockdep.c~kernel-locking-lockdepc-convert-hash-tables-to-hlists kernel/locking/lockdep.c
--- a/kernel/locking/lockdep.c~kernel-locking-lockdepc-convert-hash-tables-to-hlists
+++ a/kernel/locking/lockdep.c
@@ -292,7 +292,7 @@ LIST_HEAD(all_lock_classes);
 #define __classhashfn(key)	hash_long((unsigned long)key, CLASSHASH_BITS)
 #define classhashentry(key)	(classhash_table + __classhashfn((key)))
 
-static struct list_head classhash_table[CLASSHASH_SIZE];
+static struct hlist_head classhash_table[CLASSHASH_SIZE];
 
 /*
  * We put the lock dependency chains into a hash-table as well, to cache
@@ -303,7 +303,7 @@ static struct list_head classhash_table[
 #define __chainhashfn(chain)	hash_long(chain, CHAINHASH_BITS)
 #define chainhashentry(chain)	(chainhash_table + __chainhashfn((chain)))
 
-static struct list_head chainhash_table[CHAINHASH_SIZE];
+static struct hlist_head chainhash_table[CHAINHASH_SIZE];
 
 /*
  * The hash key of the lock dependency chains is a hash itself too:
@@ -666,7 +666,7 @@ static inline struct lock_class *
 look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 {
 	struct lockdep_subclass_key *key;
-	struct list_head *hash_head;
+	struct hlist_head *hash_head;
 	struct lock_class *class;
 
 #ifdef CONFIG_DEBUG_LOCKDEP
@@ -719,7 +719,7 @@ look_up_lock_class(struct lockdep_map *l
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return NULL;
 
-	list_for_each_entry_rcu(class, hash_head, hash_entry) {
+	hlist_for_each_entry_rcu(class, hash_head, hash_entry) {
 		if (class->key == key) {
 			/*
 			 * Huh! same key, different name? Did someone trample
@@ -742,7 +742,7 @@ static inline struct lock_class *
 register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 {
 	struct lockdep_subclass_key *key;
-	struct list_head *hash_head;
+	struct hlist_head *hash_head;
 	struct lock_class *class;
 
 	DEBUG_LOCKS_WARN_ON(!irqs_disabled());
@@ -774,7 +774,7 @@ register_lock_class(struct lockdep_map *
 	 * We have to do the hash-walk again, to avoid races
 	 * with another CPU:
 	 */
-	list_for_each_entry_rcu(class, hash_head, hash_entry) {
+	hlist_for_each_entry_rcu(class, hash_head, hash_entry) {
 		if (class->key == key)
 			goto out_unlock_set;
 	}
@@ -805,7 +805,7 @@ register_lock_class(struct lockdep_map *
 	 * We use RCU's safe list-add method to make
 	 * parallel walking of the hash-list safe:
 	 */
-	list_add_tail_rcu(&class->hash_entry, hash_head);
+	hlist_add_head_rcu(&class->hash_entry, hash_head);
 	/*
 	 * Add it to the global list of classes:
 	 */
@@ -2017,7 +2017,7 @@ static inline int lookup_chain_cache(str
 				     u64 chain_key)
 {
 	struct lock_class *class = hlock_class(hlock);
-	struct list_head *hash_head = chainhashentry(chain_key);
+	struct hlist_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
 	struct held_lock *hlock_curr;
 	int i, j;
@@ -2033,7 +2033,7 @@ static inline int lookup_chain_cache(str
 	 * We can walk it lock-free, because entries only get added
 	 * to the hash:
 	 */
-	list_for_each_entry_rcu(chain, hash_head, entry) {
+	hlist_for_each_entry_rcu(chain, hash_head, entry) {
 		if (chain->chain_key == chain_key) {
 cache_hit:
 			debug_atomic_inc(chain_lookup_hits);
@@ -2057,7 +2057,7 @@ cache_hit:
 	/*
 	 * We have to walk the chain again locked - to avoid duplicates:
 	 */
-	list_for_each_entry(chain, hash_head, entry) {
+	hlist_for_each_entry(chain, hash_head, entry) {
 		if (chain->chain_key == chain_key) {
 			graph_unlock();
 			goto cache_hit;
@@ -2091,7 +2091,7 @@ cache_hit:
 		}
 		chain_hlocks[chain->base + j] = class - lock_classes;
 	}
-	list_add_tail_rcu(&chain->entry, hash_head);
+	hlist_add_head_rcu(&chain->entry, hash_head);
 	debug_atomic_inc(chain_lookup_misses);
 	inc_chains();
 
@@ -3875,7 +3875,7 @@ void lockdep_reset(void)
 	nr_process_chains = 0;
 	debug_locks = 1;
 	for (i = 0; i < CHAINHASH_SIZE; i++)
-		INIT_LIST_HEAD(chainhash_table + i);
+		INIT_HLIST_HEAD(chainhash_table + i);
 	raw_local_irq_restore(flags);
 }
 
@@ -3894,7 +3894,7 @@ static void zap_class(struct lock_class
 	/*
 	 * Unhash the class and remove it from the all_lock_classes list:
 	 */
-	list_del_rcu(&class->hash_entry);
+	hlist_del_rcu(&class->hash_entry);
 	list_del_rcu(&class->lock_entry);
 
 	RCU_INIT_POINTER(class->key, NULL);
@@ -3917,7 +3917,7 @@ static inline int within(const void *add
 void lockdep_free_key_range(void *start, unsigned long size)
 {
 	struct lock_class *class;
-	struct list_head *head;
+	struct hlist_head *head;
 	unsigned long flags;
 	int i;
 	int locked;
@@ -3930,9 +3930,9 @@ void lockdep_free_key_range(void *start,
 	 */
 	for (i = 0; i < CLASSHASH_SIZE; i++) {
 		head = classhash_table + i;
-		if (list_empty(head))
+		if (!head)
 			continue;
-		list_for_each_entry_rcu(class, head, hash_entry) {
+		hlist_for_each_entry_rcu(class, head, hash_entry) {
 			if (within(class->key, start, size))
 				zap_class(class);
 			else if (within(class->name, start, size))
@@ -3962,7 +3962,7 @@ void lockdep_free_key_range(void *start,
 void lockdep_reset_lock(struct lockdep_map *lock)
 {
 	struct lock_class *class;
-	struct list_head *head;
+	struct hlist_head *head;
 	unsigned long flags;
 	int i, j;
 	int locked;
@@ -3987,9 +3987,9 @@ void lockdep_reset_lock(struct lockdep_m
 	locked = graph_lock();
 	for (i = 0; i < CLASSHASH_SIZE; i++) {
 		head = classhash_table + i;
-		if (list_empty(head))
+		if (!head)
 			continue;
-		list_for_each_entry_rcu(class, head, hash_entry) {
+		hlist_for_each_entry_rcu(class, head, hash_entry) {
 			int match = 0;
 
 			for (j = 0; j < NR_LOCKDEP_CACHING_CLASSES; j++)
@@ -4027,10 +4027,10 @@ void lockdep_init(void)
 		return;
 
 	for (i = 0; i < CLASSHASH_SIZE; i++)
-		INIT_LIST_HEAD(classhash_table + i);
+		INIT_HLIST_HEAD(classhash_table + i);
 
 	for (i = 0; i < CHAINHASH_SIZE; i++)
-		INIT_LIST_HEAD(chainhash_table + i);
+		INIT_HLIST_HEAD(chainhash_table + i);
 
 	lockdep_initialized = 1;
 }
diff -puN include/linux/lockdep.h~kernel-locking-lockdepc-convert-hash-tables-to-hlists include/linux/lockdep.h
--- a/include/linux/lockdep.h~kernel-locking-lockdepc-convert-hash-tables-to-hlists
+++ a/include/linux/lockdep.h
@@ -66,7 +66,7 @@ struct lock_class {
 	/*
 	 * class-hash:
 	 */
-	struct list_head		hash_entry;
+	struct hlist_node		hash_entry;
 
 	/*
 	 * global list of all lock-classes:
@@ -199,7 +199,7 @@ struct lock_chain {
 	u8				irq_context;
 	u8				depth;
 	u16				base;
-	struct list_head		entry;
+	struct hlist_node		entry;
 	u64				chain_key;
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch
mm.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
mmfsdax-change-pmd_fault-to-huge_fault-fix.patch
mm-add-support-for-pud-sized-transparent-hugepages-fix.patch
mm-add-support-for-pud-sized-transparent-hugepages-fix-2.patch
x86-add-support-for-pud-sized-transparent-hugepages-fix.patch
x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes.patch
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
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

