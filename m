Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FBAC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAAFF610C8
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347037AbhIBVYI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347021AbhIBVYG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:24:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA14461056;
        Thu,  2 Sep 2021 21:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617788;
        bh=905jq5Mjrbtnj3dm2UAHhmMGevgCQDtR8zlxcKNlXk8=;
        h=Date:From:To:Subject:From;
        b=Fb2Cdy9++iYqtVTJG22OqnGHNZLIFcCMNVaO08kr9Co2eLZH6ybLrjOMrttwOw33v
         8iel6FIXxYpAXiDV3GUusK3sthlct0mTrAr3UuES/AxQhc9pcQNIZftcScj5IGsd9O
         mUHq4kQJhNZUJfb7ee1HbIHmBcr1cdOb+xguNBro=
Date:   Thu, 02 Sep 2021 14:23:07 -0700
From:   akpm@linux-foundation.org
To:     ben.widawsky@intel.com, feng.tang@intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch removed
 from -mm tree
Message-ID: <20210902212307.96EaLDQzK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch

This patch was dropped because it was folded into mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch

------------------------------------------------------
From: Ben Widawsky <ben.widawsky@intel.com>
Subject: mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix

add helpers to avoid ifdefs

Link: https://lore.kernel.org/r/20200630212517.308045-12-ben.widawsky@intel.com
Link: https://lkml.kernel.org/r/1627970362-61305-4-git-send-email-feng.tang@intel.com
Link: https://lkml.kernel.org/r/20210809024430.GA46432@shbuild999.sh.intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Co-developed-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   12 ++++++++++++
 mm/hugetlb.c              |   34 +++++++++++++---------------------
 2 files changed, 25 insertions(+), 21 deletions(-)

--- a/include/linux/mempolicy.h~mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix
+++ a/include/linux/mempolicy.h
@@ -187,6 +187,12 @@ extern void mpol_put_task_policy(struct
 
 extern bool numa_demotion_enabled;
 
+static inline bool mpol_is_preferred_many(struct mempolicy *pol)
+{
+	return  (pol->mode == MPOL_PREFERRED_MANY);
+}
+
+
 #else
 
 struct mempolicy {};
@@ -297,5 +303,11 @@ static inline nodemask_t *policy_nodemas
 }
 
 #define numa_demotion_enabled	false
+
+static inline bool mpol_is_preferred_many(struct mempolicy *pol)
+{
+	return  false;
+}
+
 #endif /* CONFIG_NUMA */
 #endif
--- a/mm/hugetlb.c~mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix
+++ a/mm/hugetlb.c
@@ -1145,7 +1145,7 @@ static struct page *dequeue_huge_page_vm
 				unsigned long address, int avoid_reserve,
 				long chg)
 {
-	struct page *page;
+	struct page *page = NULL;
 	struct mempolicy *mpol;
 	gfp_t gfp_mask;
 	nodemask_t *nodemask;
@@ -1166,20 +1166,17 @@ static struct page *dequeue_huge_page_vm
 
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-#ifdef CONFIG_NUMA
-	if (mpol->mode == MPOL_PREFERRED_MANY) {
+
+	if (mpol_is_preferred_many(mpol)) {
 		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
-		if (page)
-			goto check_reserve;
-		/* Fallback to all nodes */
+
+		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
-#endif
-	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
 
-#ifdef CONFIG_NUMA
-check_reserve:
-#endif
+	if (!page)
+		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+
 	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
 		SetHPageRestoreReserve(page);
 		h->resv_huge_pages--;
@@ -2162,24 +2159,19 @@ struct page *alloc_buddy_huge_page_with_
 	nodemask_t *nodemask;
 
 	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
-#ifdef CONFIG_NUMA
-	if (mpol->mode == MPOL_PREFERRED_MANY) {
+	if (mpol_is_preferred_many(mpol)) {
 		gfp_t gfp = gfp_mask | __GFP_NOWARN;
 
 		gfp &=  ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 		page = alloc_surplus_huge_page(h, gfp, nid, nodemask, false);
-		if (page) {
-			mpol_cond_put(mpol);
-			return page;
-		}
 
-		/* Fallback to all nodes */
+		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
-#endif
-	page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask, false);
-	mpol_cond_put(mpol);
 
+	if (!page)
+		page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask, false);
+	mpol_cond_put(mpol);
 	return page;
 }
 
_

Patches currently in -mm which might be from ben.widawsky@intel.com are

mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch
mm-mempolicy-advertise-new-mpol_preferred_many.patch

