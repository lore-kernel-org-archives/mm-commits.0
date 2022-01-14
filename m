Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A6BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiANWHb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:07:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59598 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiANWHa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2CDAB82630
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33BFC36AE9;
        Fri, 14 Jan 2022 22:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198048;
        bh=zilKDy3f92CxmPJP95EOc6C/qYXPkrquStMBdwKL4hQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FRQojqsSc/rmcZZ05PJsacNozbATUtW7kPdcKZooRoNFDcWQ7hheFALhJobwUsHhE
         bRjiFvlpwNo1stXNKCDY5c6lXbTypQSij0LeluEqm6jIYqTQQ2tcqV8h1h8WznBA3j
         1ZIPKeUYv/cRuWgKbs+rQWxiNSt0Mbw4db2joyzQ=
Date:   Fri, 14 Jan 2022 14:07:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        feng.tang@intel.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, ying.huang@intel.com
Subject:  [patch 082/146] mm: drop node from alloc_pages_vma
Message-ID: <20220114220727._VOw2pCCP%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
