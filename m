From: akpm@linux-foundation.org
Subject: + hugetlb-add-hstate_is_gigantic.patch added to -mm tree
Date: Thu, 17 Apr 2014 16:01:24 -0700
Message-ID: <53505d44.yYPesiVSGmvTBG/R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDQXBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 19:01:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, rientjes@google.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mtosatti@redhat.com, kirill.shutemov@linux.intel.com, isimatu.yasuaki@jp.fujitsu.com, davidlohr@hp.com, aarcange@redhat.com, lcapitulino@redhat.com

Subject: + hugetlb-add-hstate_is_gigantic.patch added to -mm tree
To: lcapitulino@redhat.com,aarcange@redhat.com,davidlohr@hp.com,isimatu.yasuaki@jp.fujitsu.com,kirill.shutemov@linux.intel.com,mtosatti@redhat.com,n-horiguchi@ah.jp.nec.com,riel@redhat.com,rientjes@google.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 16:01:24 -0700


The patch titled
     Subject: hugetlb: add hstate_is_gigantic()
has been added to the -mm tree.  Its filename is
     hugetlb-add-hstate_is_gigantic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-hstate_is_gigantic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-hstate_is_gigantic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: hugetlb: add hstate_is_gigantic()

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |   28 ++++++++++++++--------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-add-hstate_is_gigantic include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-add-hstate_is_gigantic
+++ a/include/linux/hugetlb.h
@@ -336,6 +336,11 @@ static inline unsigned huge_page_shift(s
 	return h->order + PAGE_SHIFT;
 }
 
+static inline bool hstate_is_gigantic(struct hstate *h)
+{
+	return huge_page_order(h) >= MAX_ORDER;
+}
+
 static inline unsigned int pages_per_huge_page(struct hstate *h)
 {
 	return 1 << h->order;
diff -puN mm/hugetlb.c~hugetlb-add-hstate_is_gigantic mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-hstate_is_gigantic
+++ a/mm/hugetlb.c
@@ -612,7 +612,7 @@ static void update_and_free_page(struct
 {
 	int i;
 
-	VM_BUG_ON(h->order >= MAX_ORDER);
+	VM_BUG_ON(hstate_is_gigantic(h));
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[page_to_nid(page)]--;
@@ -665,7 +665,7 @@ static void free_huge_page(struct page *
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
-	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
+	if (h->surplus_huge_pages_node[nid] && !hstate_is_gigantic(h)) {
 		/* remove the page from active list */
 		list_del(&page->lru);
 		update_and_free_page(h, page);
@@ -769,7 +769,7 @@ static struct page *alloc_fresh_huge_pag
 {
 	struct page *page;
 
-	if (h->order >= MAX_ORDER)
+	if (hstate_is_gigantic(h))
 		return NULL;
 
 	page = alloc_pages_exact_node(nid,
@@ -963,7 +963,7 @@ static struct page *alloc_buddy_huge_pag
 	struct page *page;
 	unsigned int r_nid;
 
-	if (h->order >= MAX_ORDER)
+	if (hstate_is_gigantic(h))
 		return NULL;
 
 	/*
@@ -1156,7 +1156,7 @@ static void return_unused_surplus_pages(
 	h->resv_huge_pages -= unused_resv_pages;
 
 	/* Cannot return gigantic pages currently */
-	if (h->order >= MAX_ORDER)
+	if (hstate_is_gigantic(h))
 		return;
 
 	nr_pages = min(unused_resv_pages, h->surplus_huge_pages);
@@ -1356,7 +1356,7 @@ static void __init gather_bootmem_preall
 		 * fix confusing memory reports from free(1) and another
 		 * side-effects, like CommitLimit going negative.
 		 */
-		if (h->order > (MAX_ORDER - 1))
+		if (hstate_is_gigantic(h))
 			adjust_managed_page_count(page, 1 << h->order);
 	}
 }
@@ -1366,7 +1366,7 @@ static void __init hugetlb_hstate_alloc_
 	unsigned long i;
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
-		if (h->order >= MAX_ORDER) {
+		if (hstate_is_gigantic(h)) {
 			if (!alloc_bootmem_huge_page(h))
 				break;
 		} else if (!alloc_fresh_huge_page(h,
@@ -1382,7 +1382,7 @@ static void __init hugetlb_init_hstates(
 
 	for_each_hstate(h) {
 		/* oversize hugepages were init'ed in early boot */
-		if (h->order < MAX_ORDER)
+		if (!hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
 	}
 }
@@ -1416,7 +1416,7 @@ static void try_to_free_low(struct hstat
 {
 	int i;
 
-	if (h->order >= MAX_ORDER)
+	if (hstate_is_gigantic(h))
 		return;
 
 	for_each_node_mask(i, *nodes_allowed) {
@@ -1479,7 +1479,7 @@ static unsigned long set_max_huge_pages(
 {
 	unsigned long min_count, ret;
 
-	if (h->order >= MAX_ORDER)
+	if (hstate_is_gigantic(h))
 		return h->max_huge_pages;
 
 	/*
@@ -1606,7 +1606,7 @@ static ssize_t nr_hugepages_store_common
 		goto out;
 
 	h = kobj_to_hstate(kobj, &nid);
-	if (h->order >= MAX_ORDER) {
+	if (hstate_is_gigantic(h)) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1689,7 +1689,7 @@ static ssize_t nr_overcommit_hugepages_s
 	unsigned long input;
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 
-	if (h->order >= MAX_ORDER)
+	if (hstate_is_gigantic(h))
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &input);
@@ -2114,7 +2114,7 @@ static int hugetlb_sysctl_handler_common
 
 	tmp = h->max_huge_pages;
 
-	if (write && h->order >= MAX_ORDER)
+	if (write && hstate_is_gigantic(h))
 		return -EINVAL;
 
 	table->data = &tmp;
@@ -2167,7 +2167,7 @@ int hugetlb_overcommit_handler(struct ct
 
 	tmp = h->nr_overcommit_huge_pages;
 
-	if (write && h->order >= MAX_ORDER)
+	if (write && hstate_is_gigantic(h))
 		return -EINVAL;
 
 	table->data = &tmp;
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch

