Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787ACC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61956610E7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350144AbhICVCR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235133AbhICVCO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EEE360E8B;
        Fri,  3 Sep 2021 21:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702873;
        bh=G0a74iAOp7Me+xaKpDqyftubfAZhmNh7b1g6FS2Qmpc=;
        h=Date:From:To:Subject:From;
        b=FiCMbTIb9Gvat/2msCAm8uZkGW1QxBnfA+mohFT6SNt4aKcenxKLaCFBfujSzGtwg
         95GHBXfMDboGn+IwJB2bTKMJf2i2lnt/1eF6cmjDcKXd2h9mxKpdz2oJDGfv9EI9VK
         62qEbFrT0gfCroLfp5eSTrF5WKfDhlvv+OyhY0eI=
Date:   Fri, 03 Sep 2021 14:01:13 -0700
From:   akpm@linux-foundation.org
To:     ben.widawsky@intel.com, feng.tang@intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, nathan@kernel.org
Subject:  [merged]
 mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch removed from
 -mm tree
Message-ID: <20210903210113.w0RHrwjSB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add support for mempolicy MPOL_PREFERRED_MANY
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ben Widawsky <ben.widawsky@intel.com>
Subject: mm/hugetlb: add support for mempolicy MPOL_PREFERRED_MANY

Implement the missing huge page allocation functionality while obeying the
preferred node semantics.  This is similar to the implementation for
general page allocation, as it uses a fallback mechanism to try multiple
preferred nodes first, and then all other nodes.

To avoid adding too many "#ifdef CONFIG_NUMA" check, add a helper function
in mempolicy.h to check whether a mempolicy is MPOL_PREFERRED_MANY.

[akpm@linux-foundation.org: fix compiling issue when merging with other hugetlb patch]
[Thanks to 0day bot for catching the !CONFIG_NUMA compiling issue]
[mhocko@suse.com: suggest to remove the #ifdef CONFIG_NUMA check]
[ben.widawsky@intel.com: add helpers to avoid ifdefs]
  Link: https://lore.kernel.org/r/20200630212517.308045-12-ben.widawsky@intel.com
  Link: https://lkml.kernel.org/r/1627970362-61305-4-git-send-email-feng.tang@intel.com
  Link: https://lkml.kernel.org/r/20210809024430.GA46432@shbuild999.sh.intel.com
[nathan@kernel.org: initialize page to NULL in alloc_buddy_huge_page_with_mpol()]
  Link: https://lkml.kernel.org/r/20210810200632.3812797-1-nathan@kernel.org
Link: https://lore.kernel.org/r/20200630212517.308045-12-ben.widawsky@intel.com
Link: https://lkml.kernel.org/r/1627970362-61305-4-git-send-email-feng.tang@intel.com
Link: https://lkml.kernel.org/r/20210809024430.GA46432@shbuild999.sh.intel.com
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Co-developed-by: Feng Tang <feng.tang@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   12 ++++++++++++
 mm/hugetlb.c              |   30 +++++++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 5 deletions(-)

--- a/include/linux/mempolicy.h~mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many
+++ a/include/linux/mempolicy.h
@@ -186,6 +186,12 @@ extern void mpol_put_task_policy(struct
 
 extern bool numa_demotion_enabled;
 
+static inline bool mpol_is_preferred_many(struct mempolicy *pol)
+{
+	return  (pol->mode == MPOL_PREFERRED_MANY);
+}
+
+
 #else
 
 struct mempolicy {};
@@ -296,5 +302,11 @@ static inline nodemask_t *policy_nodemas
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
--- a/mm/hugetlb.c~mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many
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
@@ -1166,7 +1166,17 @@ static struct page *dequeue_huge_page_vm
 
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+
+	if (mpol_is_preferred_many(mpol)) {
+		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+
+		/* Fallback to all nodes if page==NULL */
+		nodemask = NULL;
+	}
+
+	if (!page)
+		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+
 	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
 		SetHPageRestoreReserve(page);
 		h->resv_huge_pages--;
@@ -2142,16 +2152,26 @@ static
 struct page *alloc_buddy_huge_page_with_mpol(struct hstate *h,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct page *page;
+	struct page *page = NULL;
 	struct mempolicy *mpol;
 	gfp_t gfp_mask = htlb_alloc_mask(h);
 	int nid;
 	nodemask_t *nodemask;
 
 	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
-	page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask, false);
-	mpol_cond_put(mpol);
+	if (mpol_is_preferred_many(mpol)) {
+		gfp_t gfp = gfp_mask | __GFP_NOWARN;
+
+		gfp &=  ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
+		page = alloc_surplus_huge_page(h, gfp, nid, nodemask, false);
 
+		/* Fallback to all nodes if page==NULL */
+		nodemask = NULL;
+	}
+
+	if (!page)
+		page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask, false);
+	mpol_cond_put(mpol);
 	return page;
 }
 
_

Patches currently in -mm which might be from ben.widawsky@intel.com are


