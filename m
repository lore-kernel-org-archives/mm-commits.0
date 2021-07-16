Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE918C636C9
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 00:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5A656100B
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 00:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhGPAbp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 20:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231449AbhGPAbp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 20:31:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACF70613DC;
        Fri, 16 Jul 2021 00:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626395330;
        bh=maVl5juXO4dra1w5GfX41vQFE0WF2vb6heD7W2XJkT0=;
        h=Date:From:To:Subject:From;
        b=xcr5GjcDSe5DAlQugDowkTqnl8hy1GNYkgCCLowrPhLNBNpza8qTIMfAVTI/l1C59
         jMPaXrT257+5oaeB3fM7HpOSUZLxpIwcp9u7hQq9JViPmbriqL2l3GcPnjkivBB1g3
         nBHt12PBNkjVKZOyUA297/tP+3VG1plRgRPAGEgs=
Date:   Thu, 15 Jul 2021 17:28:50 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, ben.widawsky@intel.com,
        feng.tang@intel.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch added to
 -mm tree
Message-ID: <20210716002850.pxKKrzv_0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix

fix it for "hugetlb: drop ref count earlier after page allocation"

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Feng Tang <feng.tang@intel.com>
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
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch

