Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4D7C4338F
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1D086103C
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhHCVtq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 17:49:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229918AbhHCVtq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 17:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6048C60231;
        Tue,  3 Aug 2021 21:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628027374;
        bh=k0fH7Ru7BGR66NGC0T3nocXHR+jcVQNYn6qaGWeT+qA=;
        h=Date:From:To:Subject:From;
        b=qezwbh2Z+hX9fd51qLC+utSVZQEaafOp/zr1DZRRiSMhpyiP96zy+EGm0RDsgUHLf
         7NEZGBjxPcFiZT1cwMVgWWmFjBJPtH42NVLOlL9NQqGXDHIfWahnbJpD+4AeigocB7
         5nGR4RikvwOHQnb7RFNsmBRPg6OWzh/rWJbUJmHU=
Date:   Tue, 03 Aug 2021 14:49:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mhocko@suse.com, feng.tang@intel.com, ben.widawsky@intel.com,
        akpm@linux-foundation.org
Subject:  [to-be-updated]
 mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch removed
 from -mm tree
Message-ID: <20210803214934.mltXB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix

fix it for "hugetlb: drop ref count earlier after page allocation"

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix
+++ a/mm/hugetlb.c
@@ -2162,7 +2162,7 @@ struct page *alloc_buddy_huge_page_with_
 	if (mpol->mode == MPOL_PREFERRED_MANY) {
 		gfp_t gfp = (gfp_mask | __GFP_NOWARN) & ~__GFP_DIRECT_RECLAIM;
 
-		page = alloc_surplus_huge_page(h, gfp, nid, nodemask);
+		page = alloc_surplus_huge_page(h, gfp, nid, nodemask, false);
 		if (page) {
 			mpol_cond_put(mpol);
 			return page;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

