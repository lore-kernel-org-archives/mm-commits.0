From: akpm@linux-foundation.org
Subject: + mm-fix-sleeping-function-warning-from-__put_anon_vma.patch
 added to -mm tree
Date: Mon, 02 Jun 2014 12:46:06 -0700
Message-ID: <538cd47e.3G/HaFvmi6PRAQJR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaFBTqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 15:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, davej@redhat.com, hughd@google.com

Subject: + mm-fix-sleeping-function-warning-from-__put_anon_vma.patch added to -mm tree
To: hughd@google.com,davej@redhat.com,peterz@infradead.org
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 12:46:06 -0700


The patch titled
     Subject: mm: fix sleeping function warning from __put_anon_vma
has been added to the -mm tree.  Its filename is
     mm-fix-sleeping-function-warning-from-__put_anon_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-sleeping-function-warning-from-__put_anon_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-sleeping-function-warning-from-__put_anon_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix sleeping function warning from __put_anon_vma

Trinity reports BUG:
sleeping function called from invalid context at kernel/locking/rwsem.c:47
in_atomic(): 0, irqs_disabled(): 0, pid: 5787, name: trinity-c27
__might_sleep < down_write < __put_anon_vma < page_get_anon_vma <
migrate_pages < compact_zone < compact_zone_order < try_to_compact_pages ..

Right, since conversion to mutex then rwsem, we should not put_anon_vma()
from inside an rcu_read_lock()ed section: fix the two places that did so. 
And add might_sleep() to anon_vma_free(), as suggested by Peter Zijlstra.

Fixes: 88c22088bf23 ("mm: optimize page_lock_anon_vma() fast-path")
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-fix-sleeping-function-warning-from-__put_anon_vma mm/rmap.c
--- a/mm/rmap.c~mm-fix-sleeping-function-warning-from-__put_anon_vma
+++ a/mm/rmap.c
@@ -103,6 +103,7 @@ static inline void anon_vma_free(struct
 	 * LOCK should suffice since the actual taking of the lock must
 	 * happen _before_ what follows.
 	 */
+	might_sleep();
 	if (rwsem_is_locked(&anon_vma->root->rwsem)) {
 		anon_vma_lock_write(anon_vma);
 		anon_vma_unlock_write(anon_vma);
@@ -426,8 +427,9 @@ struct anon_vma *page_get_anon_vma(struc
 	 * above cannot corrupt).
 	 */
 	if (!page_mapped(page)) {
+		rcu_read_unlock();
 		put_anon_vma(anon_vma);
-		anon_vma = NULL;
+		return NULL;
 	}
 out:
 	rcu_read_unlock();
@@ -477,9 +479,9 @@ struct anon_vma *page_lock_anon_vma_read
 	}
 
 	if (!page_mapped(page)) {
+		rcu_read_unlock();
 		put_anon_vma(anon_vma);
-		anon_vma = NULL;
-		goto out;
+		return NULL;
 	}
 
 	/* we pinned the anon_vma, its safe to sleep */
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-sleeping-function-warning-from-__put_anon_vma.patch
mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch
mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
fs-bufferc-remove-block_write_full_page_endio.patch
fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage.patch
fs-mpagec-factor-page_endio-out-of-mpage_end_io.patch
fs-block_devc-add-bdev_read_page-and-bdev_write_page.patch
swap-use-bdev_read_page-bdev_write_page.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
brd-add-support-for-rw_page.patch
brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
mm-process_vm_access-move-config-option-into-init-kconfig.patch
mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-mm-introduce-lowlimit-reclaim-fix2patch.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

