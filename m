Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADDAC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F9461175
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243877AbhJGTPd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243853AbhJGTPd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 15:15:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2E09610CE;
        Thu,  7 Oct 2021 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633634019;
        bh=T8ybRt4RgTlJ9UnBe5UayhGOXcYqHcs/nGPdcUZPeu4=;
        h=Date:From:To:Subject:From;
        b=XAoYIm2tiHL3Uv1GRsH8ceW1LR6vhfPc9svhTPaoHewZaG8TNxgddH006m15li2Cz
         PlY6DfbkQVzKHw5Jd6+qbo7AWAynMt98rX3xHbCpZ7LDwnlwdYvs85TnAduYYEAgSo
         AdXLFvQ3NAOfBgaMFWiO5/sBuLVqvRdoRFoS1260=
Date:   Thu, 07 Oct 2021 12:13:38 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, nghialm78@gmail.com, osalvador@suse.de,
        rientjes@google.com, songmuchun@bytedance.com, ziy@nvidia.com
Subject:  +
 mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch added to
 -mm tree
Message-ID: <20211007191338.AM8AS8Xb7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: add cma_pages_valid to determine if pages are in CMA
has been added to the -mm tree.  Its filename is
     mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch

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
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Nghia Le <nghialm78@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
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

hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch
hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch

