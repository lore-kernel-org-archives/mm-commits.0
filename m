Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740BBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC9C6113B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhKKCrl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234334AbhKKCrj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B79A760F46;
        Thu, 11 Nov 2021 02:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598691;
        bh=bOWiVHC4BGJ6uoY39pzwT3t2CuFKuI3X4VGwJrJhU6Y=;
        h=Date:From:To:Subject:From;
        b=jM0ZA1/17K03YdPOZeMY9mf8oYRVvOO9e4emjCGJoYwsa1VnF5o5vt/8c42tI5Rdc
         bBmXWWK4fYHtk1B+Pl9NMUDa0bU7fTeVgS7TJvCTGTgXXOlrjV96ZARVeKlogabRGh
         szONnRGnxkji9T+RdLUgOdMqO4tl8DoiB1Fwr7Fs=
Date:   Wed, 10 Nov 2021 18:44:50 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, nghialm78@gmail.com, osalvador@suse.de,
        rientjes@google.com, songmuchun@bytedance.com, ziy@nvidia.com
Subject:  [merged]
 mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch removed
 from -mm tree
Message-ID: <20211111024450.hTRophyFT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: add cma_pages_valid to determine if pages are in CMA
has been removed from the -mm tree.  Its filename was
     mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mike.kravetz@oracle.com are


