From: akpm@linux-foundation.org
Subject: + mm-fix-move_pages-follow_page-huge_addr-bug.patch added to -mm
 tree
Date: Thu, 29 May 2014 12:16:27 -0700
Message-ID: <5387878b.kf7ac6rqwajvcZ2Q%akpm__25871.9535930597$1401390997$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaE2TQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 15:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mpe@ellerman.id.au, hughd@google.com

Subject: + mm-fix-move_pages-follow_page-huge_addr-bug.patch added to -mm tree
To: hughd@google.com,mpe@ellerman.id.au,n-horiguchi@ah.jp.nec.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 12:16:27 -0700


The patch titled
     Subject: mm: fix move_pages follow_page huge_addr BUG
has been added to the -mm tree.  Its filename is
     mm-fix-move_pages-follow_page-huge_addr-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-move_pages-follow_page-huge_addr-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-move_pages-follow_page-huge_addr-bug.patch

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
Subject: mm: fix move_pages follow_page huge_addr BUG

v3.12's e632a938d914 ("mm: migrate: add hugepage migration code to
move_pages()") is okay on most arches, but on follow_huge_addr-style
arches ia64 and powerpc, it hits my old BUG_ON(flags & FOLL_GET) from
v2.6.15 deceb6cd17e6 ("mm: follow_page with inner ptlock").

The point of the BUG_ON was that nothing needed FOLL_GET there at the
time, and it was not clear that we have sufficient locking to use
get_page() safely here on the outside - maybe the page found has already
been freed and even reused when follow_huge_addr() returns.

I suspect that e632a938d914's use of get_page() after return from
follow_huge_pmd() has the same problem: what prevents a racing instance of
move_pages() from already migrating away and freeing that page by then?  A
reference to the page should be taken while holding suitable lock
(huge_pte_lockptr?), to serialize against concurrent migration.

But I'm not prepared to rework the hugetlb locking here myself; so for now
just supply a patch to copy e632a938d914's get_page() after
follow_huge_pmd() to after follow_huge_addr(): removing the BUG_ON(flags &
FOLL_GET), but probably leaving a race.

Whether this is a patch that should go in without fixing the locking,
I don't know.  An unlikely race is better than a triggerable BUG?
Or perhaps I'm just wrong about there being any such race.

Fixes: e632a938d914 ("mm: migrate: add hugepage migration code to move_pages()")
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-fix-move_pages-follow_page-huge_addr-bug mm/memory.c
--- a/mm/memory.c~mm-fix-move_pages-follow_page-huge_addr-bug
+++ a/mm/memory.c
@@ -1486,7 +1486,17 @@ struct page *follow_page_mask(struct vm_
 
 	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
 	if (!IS_ERR(page)) {
-		BUG_ON(flags & FOLL_GET);
+		if (page && (flags & FOLL_GET)) {
+			/*
+			 * Refcount on tail pages are not well-defined and
+			 * shouldn't be taken. The caller should handle a NULL
+			 * return when trying to follow tail pages.
+			 */
+			if (PageHead(page))
+				get_page(page);
+			else
+				page = NULL;
+		}
 		goto out;
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-move_pages-follow_page-huge_addr-bug.patch
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

