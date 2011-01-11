From: akpm@linux-foundation.org
Subject: + scatterlist-new-helper-functions-fix.patch added to -mm tree
Date: Tue, 11 Jan 2011 14:28:35 -0800
Message-ID: <201101112228.p0BMSZWU010466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932283Ab1AKW2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 17:28:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, maximlevitsky@gmail.com, oakad@yahoo.com, tj@kernel.org


The patch titled
     scatterlist-new-helper-functions-fix
has been added to the -mm tree.  Its filename is
     scatterlist-new-helper-functions-fix.patch

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
Subject: scatterlist-new-helper-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix general disaster in code comments

Cc: Alex Dubov <oakad@yahoo.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff -puN lib/scatterlist.c~scatterlist-new-helper-functions-fix lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-new-helper-functions-fix
+++ a/lib/scatterlist.c
@@ -41,7 +41,7 @@ EXPORT_SYMBOL(sg_next);
 /**
  * sg_advance - advance scatterlist by 'consumed' bytes
  * @sg - the current sg entry
- * @consumed - how much bytes to advance
+ * @consumed - how many bytes to advance
  *
  */
 struct scatterlist *sg_advance(struct scatterlist *sg, int consumed)
@@ -76,8 +76,8 @@ EXPORT_SYMBOL(sg_advance);
  * sg_nents - calculate number of sg entries in sg list
  * @sg - the current sg entry
  *
- * Allows to calculate dynamicly the lenght of the sg table, based on
- * assumption that last entry is NULL
+ * Allows to calculate aldynamicly the length of the sg table, based on an
+ * assumption that the last entry is NULL
  */
 int sg_nents(struct scatterlist *sg)
 {
@@ -92,11 +92,11 @@ int sg_nents(struct scatterlist *sg)
 EXPORT_SYMBOL(sg_nents);
 
 /**
- * sg_total_len - calculate total lenght of scatterlist
+ * sg_total_len - calculate total length of scatterlist
  * @sg - the current sg entry
  *
- * Dynamicly calculate total number of bytes in a sg list
- * based on assumption that list ends with a NULL entry
+ * Dynamically calculate total number of bytes in a sg list
+ * based on an assumption that the list ends with a NULL entry
  */
 int sg_total_len(struct scatterlist *sg)
 {
@@ -182,8 +182,14 @@ void sg_init_one(struct scatterlist *sg,
 EXPORT_SYMBOL(sg_init_one);
 
 /**
- * sg_copy - copies sg entries from sg_from to sg_to, such
- * as sg_to covers first 'len' bytes from sg_from.
+ * sg_copy - copy sg entries
+ * @sg_from: source
+ * @sg_to: destination
+ *
+ * Copies from @sg_from to @sg_to.  @sg_to covers first 'len' bytes from
+ * @sg_from.
+ *
+ * Returns zero on success, else a -ve errno.
  */
 int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to, int len)
 {
@@ -616,13 +622,12 @@ size_t sg_copy_to_buffer(struct scatterl
 }
 EXPORT_SYMBOL(sg_copy_to_buffer);
 
-
 /**
- * sg_compare_to_buffer - compare contents of the data pointeted by sg table
+ * sg_compare_to_buffer - compare contents of the data covered by an sg table
  * to a kernel ram buffer
- * @sg - the current sg entry
- * @buffer - linear buffer to compare with
- * @len - lenght of that buffer
+ * @sg: the current sg entry
+ * @buffer: linear buffer to compare with
+ * @len: length of that buffer
  */
 bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
leds-add-output-inversion-option-to-backlight-trigger-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ext4-dont-use-pr_warning_ratelimited.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning-fix.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
gpio-ml_ioh_gpio-ml7213-gpio-driver-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
scatterlist-new-helper-functions-fix.patch
aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

