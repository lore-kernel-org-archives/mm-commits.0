Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE51C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CD5964F18
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhBYTch (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:32:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234871AbhBYTaP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B01364F31;
        Thu, 25 Feb 2021 19:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280641;
        bh=Z5/vLuQjWMjP4gpE9zliK3H9/dzEFx8DvQ8KzwEOCpw=;
        h=Date:From:To:Subject:From;
        b=tKOSZ+pweEHkQ5otzrPoJalj7uaY02g6c6QtRpgFiFon4Q08qDftEaEHbTJyN9vd/
         QxkIFOBimfuceOuGMJlN8fDmH+zdG0XHxO/JhGTb5Hk3HVVUqjNJiQyxvzH3qRz0re
         cERm3wrIUREXf3hxX6Ox92WS8Sn1zPlAdItn+8V4=
Date:   Thu, 25 Feb 2021 11:17:21 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size.patch removed
 from -mm tree
Message-ID: <20210225191721.t9GXx8cpl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use helper huge_page_size() to get hugepage size
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: use helper huge_page_size() to get hugepage size

We can use helper huge_page_size() to get the hugepage size directly to
simplify the code slightly.

[linmiaohe@huawei.com: use helper huge_page_size() to get hugepage size]
  Link: https://lkml.kernel.org/r/20210209021803.49211-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210208082450.15716-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size
+++ a/mm/hugetlb.c
@@ -3248,7 +3248,7 @@ void __init hugetlb_add_hstate(unsigned
 	BUG_ON(order == 0);
 	h = &hstates[hugetlb_max_hstate++];
 	h->order = order;
-	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
+	h->mask = ~(huge_page_size(h) - 1);
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
@@ -3523,7 +3523,7 @@ void hugetlb_report_meminfo(struct seq_f
 	for_each_hstate(h) {
 		unsigned long count = h->nr_huge_pages;
 
-		total += (PAGE_SIZE << huge_page_order(h)) * count;
+		total += huge_page_size(h) * count;
 
 		if (h == &default_hstate)
 			seq_printf(m,
@@ -3536,10 +3536,10 @@ void hugetlb_report_meminfo(struct seq_f
 				   h->free_huge_pages,
 				   h->resv_huge_pages,
 				   h->surplus_huge_pages,
-				   (PAGE_SIZE << huge_page_order(h)) / 1024);
+				   huge_page_size(h) / SZ_1K);
 	}
 
-	seq_printf(m, "Hugetlb:        %8lu kB\n", total / 1024);
+	seq_printf(m, "Hugetlb:        %8lu kB\n", total / SZ_1K);
 }
 
 int hugetlb_report_node_meminfo(char *buf, int len, int nid)
@@ -3573,7 +3573,7 @@ void hugetlb_show_meminfo(void)
 				h->nr_huge_pages_node[nid],
 				h->free_huge_pages_node[nid],
 				h->surplus_huge_pages_node[nid],
-				1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
+				huge_page_size(h) / SZ_1K);
 }
 
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm)
@@ -3696,9 +3696,7 @@ static int hugetlb_vm_op_split(struct vm
 
 static unsigned long hugetlb_vm_op_pagesize(struct vm_area_struct *vma)
 {
-	struct hstate *hstate = hstate_vma(vma);
-
-	return 1UL << huge_page_shift(hstate);
+	return huge_page_size(hstate_vma(vma));
 }
 
 /*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

