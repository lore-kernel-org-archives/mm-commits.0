Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7823AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F5BB6127B
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhKEUoH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233670AbhKEUoF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 496F56127A;
        Fri,  5 Nov 2021 20:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144884;
        bh=c+ThdpFnztAIEpIqVaCNN3ZX83OuglcMdNEaYcHWmLQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JIlMKsDNIChuCe3fKB66HA8/6VtlnApTKfR4TBIqJd9ay+8JxlrivUdXgKcehrdU+
         ivQdoqBxurUhih2nqFHKrChnrzJ8NztwZtUcbv8AAxwVUwy/xQRKxJUUz7LmIZbQti
         pQ8JXofuo5CI3nbGpTL+dGRBfx53mvtRFYb6s2x4=
Date:   Fri, 05 Nov 2021 13:41:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        david@redhat.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, nghialm78@gmail.com, osalvador@suse.de,
        rientjes@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 129/262] mm/cma: add cma_pages_valid to determine
 if pages are in CMA
Message-ID: <20211105204123.zxB_XA3PS%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/cma: add cma_pages_valid to determine if pages are in CMA

Add new interface cma_pages_valid() which indicates if the specified pages
are part of a CMA region.  This interface will be used in a subsequent
patch by hugetlb code.

In order to keep the same amount of DEBUG information, a pr_debug() call
was added to cma_pages_valid().  In the case where the page passed to
cma_release is not in cma region, the debug message will be printed from
cma_pages_valid as opposed to cma_release.

Link: https://lkml.kernel.org/r/20211007181918.136982-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Nghia Le <nghialm78@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    1 +
 mm/cma.c            |   24 ++++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

--- a/include/linux/cma.h~mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma
+++ a/include/linux/cma.h
@@ -46,6 +46,7 @@ extern int cma_init_reserved_mem(phys_ad
 					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
+extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
--- a/mm/cma.c~mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma
+++ a/mm/cma.c
@@ -524,6 +524,25 @@ out:
 	return page;
 }
 
+bool cma_pages_valid(struct cma *cma, const struct page *pages,
+		     unsigned long count)
+{
+	unsigned long pfn;
+
+	if (!cma || !pages)
+		return false;
+
+	pfn = page_to_pfn(pages);
+
+	if (pfn < cma->base_pfn || pfn >= cma->base_pfn + cma->count) {
+		pr_debug("%s(page %p, count %lu)\n", __func__,
+						(void *)pages, count);
+		return false;
+	}
+
+	return true;
+}
+
 /**
  * cma_release() - release allocated pages
  * @cma:   Contiguous memory region for which the allocation is performed.
@@ -539,16 +558,13 @@ bool cma_release(struct cma *cma, const
 {
 	unsigned long pfn;
 
-	if (!cma || !pages)
+	if (!cma_pages_valid(cma, pages, count))
 		return false;
 
 	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
 	pfn = page_to_pfn(pages);
 
-	if (pfn < cma->base_pfn || pfn >= cma->base_pfn + cma->count)
-		return false;
-
 	VM_BUG_ON(pfn + count > cma->base_pfn + cma->count);
 
 	free_contig_range(pfn, count);
_
