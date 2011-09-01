From: akpm@linux-foundation.org
Subject: + aio-allocate-kiocbs-in-batches-fix.patch added to -mm tree
Date: Wed, 31 Aug 2011 17:13:40 -0700
Message-ID: <201109010013.p810DeZo003861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898Ab1IAAOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Aug 2011 20:14:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jmoyer@redhat.com


The patch titled
     aio-allocate-kiocbs-in-batches-fix
has been added to the -mm tree.  Its filename is
     aio-allocate-kiocbs-in-batches-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio-allocate-kiocbs-in-batches-fix
From: Andrew Morton <akpm@linux-foundation.org>

- coding-style fixes

- improve variable name(s)

- fix typo(s)

- use new kmap_atomic() interface

- change comment to use the number of columns God gave us

- use "bool" for a boolean

Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN fs/aio.c~aio-allocate-kiocbs-in-batches-fix fs/aio.c
--- a/fs/aio.c~aio-allocate-kiocbs-in-batches-fix
+++ a/fs/aio.c
@@ -468,12 +468,14 @@ struct kiocb_stash {
 	unsigned used;
 	struct kiocb *kiocbs[KIOCB_STASH_SIZE];
 };
-static void kiocb_stash_init(struct kiocb_stash *stash, int nr)
+
+static void kiocb_stash_init(struct kiocb_stash *stash, int total)
 {
 	stash->head = stash->tail = 0;
-	stash->total = nr;
+	stash->total = total;
 	stash->used = 0;
 }
+
 static void kiocb_stash_free(struct kiocb_stash *stash, int used)
 {
 	int i;
@@ -481,24 +483,25 @@ static void kiocb_stash_free(struct kioc
 	for (i = used; i < stash->total; i++)
 		kmem_cache_free(kiocb_cachep, stash->kiocbs[i]);
 }
+
 static inline unsigned kiocb_stash_avail(struct kiocb_stash *stash)
 {
 	return stash->tail - stash->head;
 }
 
 /*
- * Allocate nr kiocbs.  This aovids taking and dropping the lock a
+ * Allocate nr kiocbs.  This avoids taking and dropping the lock a
  * lot during setup.
  */
 static int kiocb_stash_refill(struct kioctx *ctx, struct kiocb_stash *stash)
 {
 	int i, nr = KIOCB_STASH_SIZE;
 	int avail;
-	int called_fput = 0;
+	bool called_fput;
 	struct aio_ring *ring;
 
 	/*
-	 * Allocate the requests up-front.  Later, we'll trim the list
+	 * Allocate the requests up front.  Later, we'll trim the list
 	 * if there isn't enough room in the completion ring.
 	 */
 	stash->head = 0;
@@ -509,15 +512,14 @@ static int kiocb_stash_refill(struct kio
 	for (i = 0; i < nr; i++) {
 		stash->kiocbs[i] = __aio_get_req(ctx);
 		if (!stash->kiocbs[i] && !called_fput) {
-			/* Handle a potential starvation case --
-			 * should be exceedingly rare as requests will
-			 * be stuck on fput_head only if the
-			 * aio_fput_routine is delayed and the
-			 * requests were the last user of the struct
-			 * file.
+			/*
+			 * Handle a potential starvation case.  Should be
+			 * exceedingly rare as requests will be stuck on
+			 * fput_head only if the aio_fput_routine is delayed and
+			 * the requests were the last user of the struct file.
 			 */
 			aio_fput_routine(NULL);
-			called_fput = 1;
+			called_fput = true;
 			i--;
 			continue;
 		}
@@ -525,7 +527,7 @@ static int kiocb_stash_refill(struct kio
 	stash->tail = i;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
+	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
 
 	avail = aio_ring_avail(&ctx->ring_info, ring) + ctx->reqs_active;
 	if (avail < stash->tail) {
@@ -538,7 +540,7 @@ static int kiocb_stash_refill(struct kio
 		list_add(&stash->kiocbs[i]->ki_list, &ctx->active_reqs);
 		ctx->reqs_active++;
 	}
-	kunmap_atomic(ring, KM_USER0);
+	kunmap_atomic(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
 
 	if (stash->tail == 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

headers_check-is-broken.patch
samples-hidraw-is-busted.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
block-document-blk-plug-fix.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
aio-allocate-kiocbs-in-batches-fix.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

