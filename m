Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2381CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377851AbiATV03 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37214 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347710AbiATV03 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D316B60C32
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35E5C340E3;
        Thu, 20 Jan 2022 21:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713988;
        bh=5ez/IXs8To//qd9/7JUKY+ca9UtwsyJMpiGji0cDsVw=;
        h=Date:From:To:Subject:From;
        b=BdHlhxVzXlDxnPtMMcL66J8JaBEuom8G87vSk2iIfr72eri6G/DjkGPU8nubP5Rq1
         iPO/1wGXTbCbhLvd0tI47x8MG+aUMIrec3BUAAmydj16e9m9hffs+tS/FstLKGjP3s
         zOrnPILHfTfdnUEEM+TyMrBWetfYznZLGrUdn2Ew=
Date:   Thu, 20 Jan 2022 13:26:27 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com,
        aneesh.kumar@linux.ibm.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, vbabka@suse.cz, ying.huang@intel.com
Subject:  [merged] mm-drop-node-from-alloc_pages_vma.patch removed
 from -mm tree
Message-ID: <20220120212627.Q9wii4DQX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop node from alloc_pages_vma
has been removed from the -mm tree.  Its filename was
     mm-drop-node-from-alloc_pages_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: drop node from alloc_pages_vma

alloc_pages_vma is meant to allocate a page with a vma specific memory
policy.  The initial node parameter is always a local node so it is
pointless to waste a function argument for this.  Drop the parameter.

Link: https://lkml.kernel.org/r/YaSnlv4QpryEpesG@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    8 ++++----
 mm/mempolicy.c      |    3 ++-
 mm/shmem.c          |    3 +--
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/gfp.h~mm-drop-node-from-alloc_pages_vma
+++ a/include/linux/gfp.h
@@ -598,9 +598,9 @@ struct page *alloc_pages(gfp_t gfp, unsi
 struct folio *folio_alloc(gfp_t gfp, unsigned order);
 extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 			struct vm_area_struct *vma, unsigned long addr,
-			int node, bool hugepage);
+			bool hugepage);
 #define alloc_hugepage_vma(gfp_mask, vma, addr, order) \
-	alloc_pages_vma(gfp_mask, order, vma, addr, numa_node_id(), true)
+	alloc_pages_vma(gfp_mask, order, vma, addr, true)
 #else
 static inline struct page *alloc_pages(gfp_t gfp_mask, unsigned int order)
 {
@@ -610,14 +610,14 @@ static inline struct folio *folio_alloc(
 {
 	return __folio_alloc_node(gfp, order, numa_node_id());
 }
-#define alloc_pages_vma(gfp_mask, order, vma, addr, node, false)\
+#define alloc_pages_vma(gfp_mask, order, vma, addr, false)\
 	alloc_pages(gfp_mask, order)
 #define alloc_hugepage_vma(gfp_mask, vma, addr, order) \
 	alloc_pages(gfp_mask, order)
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
-	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id(), false)
+	alloc_pages_vma(gfp_mask, 0, vma, addr, false)
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
--- a/mm/mempolicy.c~mm-drop-node-from-alloc_pages_vma
+++ a/mm/mempolicy.c
@@ -2084,9 +2084,10 @@ static struct page *alloc_pages_preferre
  * Return: The page on success or NULL if allocation fails.
  */
 struct page *alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr, int node, bool hugepage)
+		unsigned long addr, bool hugepage)
 {
 	struct mempolicy *pol;
+	int node = numa_node_id();
 	struct page *page;
 	int preferred_nid;
 	nodemask_t *nmask;
--- a/mm/shmem.c~mm-drop-node-from-alloc_pages_vma
+++ a/mm/shmem.c
@@ -1564,8 +1564,7 @@ static struct page *shmem_alloc_hugepage
 		return NULL;
 
 	shmem_pseudo_vma_init(&pvma, info, hindex);
-	page = alloc_pages_vma(gfp, HPAGE_PMD_ORDER, &pvma, 0, numa_node_id(),
-			       true);
+	page = alloc_pages_vma(gfp, HPAGE_PMD_ORDER, &pvma, 0, true);
 	shmem_pseudo_vma_destroy(&pvma);
 	if (page)
 		prep_transhuge_page(page);
_

Patches currently in -mm which might be from mhocko@suse.com are


