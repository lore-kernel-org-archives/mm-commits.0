From: akpm@linux-foundation.org
Subject: + mm-thp-optimize-compound_trans_huge.patch added to -mm tree
Date: Wed, 20 Nov 2013 13:29:16 -0800
Message-ID: <528d29ac.RiEShKBbI2bECG3G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab3KTV3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 16:29:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com

Subject: + mm-thp-optimize-compound_trans_huge.patch added to -mm tree
To: aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 13:29:16 -0800


The patch titled
     Subject: mm: thp: optimize compound_trans_huge
has been added to the -mm tree.  Its filename is
     mm-thp-optimize-compound_trans_huge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-optimize-compound_trans_huge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-optimize-compound_trans_huge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: optimize compound_trans_huge

Currently we don't clobber page_tail->first_page during split_huge_page,
so compound_trans_head can be set to compound_head without adverse
effects, and this mostly optimizes away a smp_rmb.

It looks worthwhile to keep around the implementation that doesn't relay
on page_tail->first_page not to be clobbered, because it would be
necessary if we'll decide to enforce page->private to zero at all times
whenever PG_private is not set, also for anonymous pages.  For anonymous
pages enforcing such an invariant doesn't matter as anonymous pages don't
use page->private so we can get away with this microoptimization.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN include/linux/huge_mm.h~mm-thp-optimize-compound_trans_huge include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-optimize-compound_trans_huge
+++ a/include/linux/huge_mm.h
@@ -157,6 +157,26 @@ static inline int hpage_nr_pages(struct
 		return HPAGE_PMD_NR;
 	return 1;
 }
+/*
+ * compound_trans_head() should be used instead of compound_head(),
+ * whenever the "page" passed as parameter could be the tail of a
+ * transparent hugepage that could be undergoing a
+ * __split_huge_page_refcount(). The page structure layout often
+ * changes across releases and it makes extensive use of unions. So if
+ * the page structure layout will change in a way that
+ * page->first_page gets clobbered by __split_huge_page_refcount, the
+ * implementation making use of smp_rmb() will be required.
+ *
+ * Currently we define compound_trans_head as compound_head, because
+ * page->private is in the same union with page->first_page, and
+ * page->private isn't clobbered. However this also means we're
+ * currently leaving dirt into the page->private field of anonymous
+ * pages resulting from a THP split, instead of setting page->private
+ * to zero like for every other page that has PG_private not set. But
+ * anonymous pages don't use page->private so this is not a problem.
+ */
+#if 0
+/* This will be needed if page->private will be clobbered in split_huge_page */
 static inline struct page *compound_trans_head(struct page *page)
 {
 	if (PageTail(page)) {
@@ -174,6 +194,9 @@ static inline struct page *compound_tran
 	}
 	return page;
 }
+#else
+#define compound_trans_head(page) compound_head(page)
+#endif
 
 extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
mm-hugetlbfs-fix-hugetlbfs-optimization.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch

