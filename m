From: akpm@linux-foundation.org
Subject: + thp-transparent-hugepage-core-fixlet.patch added to -mm tree
Date: Mon, 10 Jan 2011 16:58:27 -0800
Message-ID: <201101110058.p0B0wRNr021744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753407Ab1AKA6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Jan 2011 19:58:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, riel@redhat.com


The patch titled
     thp: transparent hugepage core fixlet
has been added to the -mm tree.  Its filename is
     thp-transparent-hugepage-core-fixlet.patch

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
Subject: thp: transparent hugepage core fixlet
From: Hugh Dickins <hughd@google.com>

If you configure THP in addition to HUGETLB_PAGE on x86_32 without PAE,
the p?d-folding works out that munlock_vma_pages_range() can crash to
follow_page()'s pud_huge() BUG_ON(flags & FOLL_GET): it needs the same
VM_HUGETLB check already there on the pmd_huge() line.  Conveniently,
openSUSE provides a "blogd" which tests this out at startup!

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~thp-transparent-hugepage-core-fixlet mm/memory.c
--- a/mm/memory.c~thp-transparent-hugepage-core-fixlet
+++ a/mm/memory.c
@@ -1288,7 +1288,7 @@ struct page *follow_page(struct vm_area_
 	pud = pud_offset(pgd, address);
 	if (pud_none(*pud))
 		goto no_page_table;
-	if (pud_huge(*pud)) {
+	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
 		BUG_ON(flags & FOLL_GET);
 		page = follow_huge_pud(mm, address, pud, flags & FOLL_WRITE);
 		goto out;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-vmap-area-cache-fix.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-potential-deadlock-for-readahead-pages-and-direct-compaction.patch
do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-transparent-hugepage-core-fixlet.patch
thp-ksm-on-thp.patch
thp-add-compound_trans_head-helper.patch
memcg-fix-memory-migration-of-shmem-swapcache.patch
prio_tree-debugging-patch.patch

