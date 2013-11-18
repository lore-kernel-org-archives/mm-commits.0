From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch added
 to -mm tree
Date: Mon, 18 Nov 2013 13:26:38 -0800
Message-ID: <528a860e.JqjUtpuXsJuesk3c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab3KRV0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 16:26:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, dave.hansen@linux.intel.com

Subject: + mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch added to -mm tree
To: dave.hansen@linux.intel.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 13:26:38 -0800


The patch titled
     Subject: mm: hugetlbfs: Add some VM_BUG_ON()s to catch non-hugetlbfs pages
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: hugetlbfs: Add some VM_BUG_ON()s to catch non-hugetlbfs pages

Dave Jiang reported that he was seeing oopses when running NUMA systems
and default_hugepagesz=1G.  I traced the issue down to migrate_page_copy()
trying to use the same code for hugetlb pages and transparent hugepages. 
It should not have been trying to pass thp pages in there.

So, add some VM_BUG_ON()s for the next hapless VM developer that tries the
same thing.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 mm/hugetlb.c            |    1 +
 2 files changed, 2 insertions(+)

diff -puN include/linux/hugetlb.h~mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages
+++ a/include/linux/hugetlb.h
@@ -355,6 +355,7 @@ static inline pte_t arch_make_huge_pte(p
 
 static inline struct hstate *page_hstate(struct page *page)
 {
+	VM_BUG_ON(!PageHuge(page));
 	return size_to_hstate(PAGE_SIZE << compound_order(page));
 }
 
diff -puN mm/hugetlb.c~mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages
+++ a/mm/hugetlb.c
@@ -498,6 +498,7 @@ void copy_huge_page(struct page *dst, st
 	int i;
 	struct hstate *h = page_hstate(src);
 
+	VM_BUG_ON(!h);
 	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
 		copy_gigantic_page(dst, src);
 		return;
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

origin.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch

