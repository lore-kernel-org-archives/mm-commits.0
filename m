Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C3EC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75D216113E
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243848AbhJGTPh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243875AbhJGTPh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 15:15:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAE61610CE;
        Thu,  7 Oct 2021 19:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633634023;
        bh=7q1b8FCSHFC2Ln3LJ7AsEkSlgjQ9qlyvEcQmVgi1d3k=;
        h=Date:From:To:Subject:From;
        b=Z925YHjRvkMDyLhd+JVlHz0w7hVqiH/Z4b8QFnv/m0NTYNpTCjgiEMShZF8bIazHB
         F+9YbbMSapIjKZQ0u9PJJ1+7XlzXdq6addVBm032mSrlS4+JTjI86bOWNvl5MEnkHY
         A4GtEqDAyc32f998KjxdhMSo1MdRtPK8I94xiQv8=
Date:   Thu, 07 Oct 2021 12:13:42 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, nghialm78@gmail.com, osalvador@suse.de,
        rientjes@google.com, songmuchun@bytedance.com, ziy@nvidia.com
Subject:  + hugetlb-add-demote-bool-to-gigantic-page-routines.patch
 added to -mm tree
Message-ID: <20211007191342.6t7sT5-tO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add demote bool to gigantic page routines
has been added to the -mm tree.  Its filename is
     hugetlb-add-demote-bool-to-gigantic-page-routines.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-demote-bool-to-gigantic-page-routines.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-demote-bool-to-gigantic-page-routines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: add demote bool to gigantic page routines

The routines remove_hugetlb_page and destroy_compound_gigantic_page will
remove a gigantic page and make the set of base pages ready to be returned
to a lower level allocator.  In the process of doing this, they make all
base pages reference counted.

The routine prep_compound_gigantic_page creates a gigantic page from a set
of base pages.  It assumes that all these base pages are reference
counted.

During demotion, a gigantic page will be split into huge pages of a
smaller size.  This logically involves use of the routines,
remove_hugetlb_page, and destroy_compound_gigantic_page followed by
prep_compound*_page for each smaller huge page.

When pages are reference counted (ref count >= 0), additional speculative
ref counts could be taken.  This could result in errors while demoting a
huge page.  Quite a bit of code would need to be created to handle all
possible issues.

Instead of dealing with the possibility of speculative ref counts, avoid
the possibility by keeping ref counts at zero during the demote process. 
Add a boolean 'demote' to the routines remove_hugetlb_page,
destroy_compound_gigantic_page and prep_compound_gigantic_page.  If the
boolean is set, the remove and destroy routines will not reference count
pages and the prep routine will not expect reference counted pages.

'*_for_demote' wrappers of the routines will be added in a subsequent
patch where this functionality is used.

Link: https://lkml.kernel.org/r/20211007181918.136982-5-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Nghia Le <nghialm78@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   54 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~hugetlb-add-demote-bool-to-gigantic-page-routines
+++ a/mm/hugetlb.c
@@ -1271,8 +1271,8 @@ static int hstate_next_node_to_free(stru
 		nr_nodes--)
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-static void destroy_compound_gigantic_page(struct page *page,
-					unsigned int order)
+static void __destroy_compound_gigantic_page(struct page *page,
+					unsigned int order, bool demote)
 {
 	int i;
 	int nr_pages = 1 << order;
@@ -1284,7 +1284,8 @@ static void destroy_compound_gigantic_pa
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		p->mapping = NULL;
 		clear_compound_head(p);
-		set_page_refcounted(p);
+		if (!demote)
+			set_page_refcounted(p);
 	}
 
 	set_compound_order(page, 0);
@@ -1292,6 +1293,12 @@ static void destroy_compound_gigantic_pa
 	__ClearPageHead(page);
 }
 
+static void destroy_compound_gigantic_page(struct page *page,
+					unsigned int order)
+{
+	__destroy_compound_gigantic_page(page, order, false);
+}
+
 static void free_gigantic_page(struct page *page, unsigned int order)
 {
 	/*
@@ -1364,12 +1371,15 @@ static inline void destroy_compound_giga
 
 /*
  * Remove hugetlb page from lists, and update dtor so that page appears
- * as just a compound page.  A reference is held on the page.
+ * as just a compound page.
+ *
+ * A reference is held on the page, except in the case of demote.
  *
  * Must be called with hugetlb lock held.
  */
-static void remove_hugetlb_page(struct hstate *h, struct page *page,
-							bool adjust_surplus)
+static void __remove_hugetlb_page(struct hstate *h, struct page *page,
+							bool adjust_surplus,
+							bool demote)
 {
 	int nid = page_to_nid(page);
 
@@ -1407,8 +1417,12 @@ static void remove_hugetlb_page(struct h
 	 *
 	 * This handles the case where more than one ref is held when and
 	 * after update_and_free_page is called.
+	 *
+	 * In the case of demote we do not ref count the page as it will soon
+	 * be turned into a page of smaller size.
 	 */
-	set_page_refcounted(page);
+	if (!demote)
+		set_page_refcounted(page);
 	if (hstate_is_gigantic(h))
 		set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
 	else
@@ -1418,6 +1432,12 @@ static void remove_hugetlb_page(struct h
 	h->nr_huge_pages_node[nid]--;
 }
 
+static void remove_hugetlb_page(struct hstate *h, struct page *page,
+							bool adjust_surplus)
+{
+	__remove_hugetlb_page(h, page, adjust_surplus, false);
+}
+
 static void add_hugetlb_page(struct hstate *h, struct page *page,
 			     bool adjust_surplus)
 {
@@ -1681,7 +1701,8 @@ static void prep_new_huge_page(struct hs
 	spin_unlock_irq(&hugetlb_lock);
 }
 
-static bool prep_compound_gigantic_page(struct page *page, unsigned int order)
+static bool __prep_compound_gigantic_page(struct page *page, unsigned int order,
+								bool demote)
 {
 	int i, j;
 	int nr_pages = 1 << order;
@@ -1719,10 +1740,16 @@ static bool prep_compound_gigantic_page(
 		 * the set of pages can not be converted to a gigantic page.
 		 * The caller who allocated the pages should then discard the
 		 * pages using the appropriate free interface.
+		 *
+		 * In the case of demote, the ref count will be zero.
 		 */
-		if (!page_ref_freeze(p, 1)) {
-			pr_warn("HugeTLB page can not be used due to unexpected inflated ref count\n");
-			goto out_error;
+		if (!demote) {
+			if (!page_ref_freeze(p, 1)) {
+				pr_warn("HugeTLB page can not be used due to unexpected inflated ref count\n");
+				goto out_error;
+			}
+		} else {
+			VM_BUG_ON_PAGE(page_count(p), p);
 		}
 		set_page_count(p, 0);
 		set_compound_head(p, page);
@@ -1747,6 +1774,11 @@ out_error:
 	return false;
 }
 
+static bool prep_compound_gigantic_page(struct page *page, unsigned int order)
+{
+	return __prep_compound_gigantic_page(page, order, false);
+}
+
 /*
  * PageHuge() only returns true for hugetlbfs pages, but not for normal or
  * transparent huge pages.  See the PageTransHuge() documentation for more
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch
hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch

