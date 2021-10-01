Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E84C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A36361AD0
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhJAX2I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 19:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhJAX2H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 19:28:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7E6061AAB;
        Fri,  1 Oct 2021 23:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633130782;
        bh=hzbQz83V7HN1ZZzU5MyeRzc4MLutyXAuc4RIMcSWrHg=;
        h=Date:From:To:Subject:From;
        b=v8YRm6Qi3qukSVrh71QHg2QaLZsZV25MKNWdhTMN7KBwhUGwNAr7jRthM0Jv8aELM
         JTPrWWTSph2UqtLBFXZ3LX81TSgbdeLJXIzvv9oYFKRZ1ZANZMVAg2L0jWOMsbvjXz
         keDw5hRW2yKs5/cSHIsPYgNQEPEOgOBU5P2schbw=
Date:   Fri, 01 Oct 2021 16:26:21 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, osalvador@suse.de, rientjes@google.com,
        songmuchun@bytedance.com, ziy@nvidia.com
Subject:  +
 mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch added to
 -mm tree
Message-ID: <20211001232621.1tGFLOsYY%akpm@linux-foundation.org>
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

Link: https://lkml.kernel.org/r/20211001175210.45968-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    1 +
 mm/cma.c            |   21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

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
@@ -524,6 +524,22 @@ out:
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
+	if (pfn < cma->base_pfn || pfn >= cma->base_pfn + cma->count)
+		return false;
+
+	return true;
+}
+
 /**
  * cma_release() - release allocated pages
  * @cma:   Contiguous memory region for which the allocation is performed.
@@ -539,16 +555,13 @@ bool cma_release(struct cma *cma, const
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

