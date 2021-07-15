Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D61BC12002
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 00:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47502613CC
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 00:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbhGOAT6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 20:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236933AbhGOAT6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 20:19:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05003613CF;
        Thu, 15 Jul 2021 00:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626308225;
        bh=CZg4pLAB7pdwtGuNEBByWxWdUTjoa6jaWObwno39ZQA=;
        h=Date:From:To:Subject:From;
        b=oNg3g7789dYGbg/XRQdrMJn46cjDYs0+mihIWrSxbf54uPSK0DoqpFOxyOhg/EP4M
         eLG9En8ZVUvi50mgS3uP+I0NeQy1OX+Q+LvcvKoyS6cfX4p8CXKJS4LvybMEGi7X7I
         kkqMawDiJQ+5zIEmKaLKHOdY+cBEihTSI6GT0pNo=
Date:   Wed, 14 Jul 2021 17:17:04 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  +
 mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch added to -mm
 tree
Message-ID: <20210715001704.VHszzpxlD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add support for mempolicy MPOL_PREFERRED_MANY
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ben Widawsky <ben.widawsky@intel.com>
Subject: mm/hugetlb: add support for mempolicy MPOL_PREFERRED_MANY

Implement the missing huge page allocation functionality while obeying the
preferred node semantics.  This is similar to the implementation for
general page allocation, as it uses a fallback mechanism to try multiple
preferred nodes first, and then all other nodes.

[Thanks to 0day bot for caching the missing #ifdef CONFIG_NUMA issue]

Link: https://lore.kernel.org/r/20200630212517.308045-12-ben.widawsky@intel.com
Link: https://lkml.kernel.org/r/1626077374-81682-5-git-send-email-feng.tang@intel.com
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Co-developed-by: Feng Tang <feng.tang@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c   |   25 +++++++++++++++++++++++++
 mm/mempolicy.c |    3 ++-
 2 files changed, 27 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many
+++ a/mm/hugetlb.c
@@ -1166,7 +1166,18 @@ static struct page *dequeue_huge_page_vm
 
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
+#ifdef CONFIG_NUMA
+	if (mpol->mode == MPOL_PREFERRED_MANY) {
+		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+		if (page)
+			goto check_reserve;
+		/* Fallback to all nodes */
+		nodemask = NULL;
+	}
+#endif
 	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+
+check_reserve:
 	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
 		SetHPageRestoreReserve(page);
 		h->resv_huge_pages--;
@@ -2147,6 +2158,20 @@ struct page *alloc_buddy_huge_page_with_
 	nodemask_t *nodemask;
 
 	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
+#ifdef CONFIG_NUMA
+	if (mpol->mode == MPOL_PREFERRED_MANY) {
+		gfp_t gfp = (gfp_mask | __GFP_NOWARN) & ~__GFP_DIRECT_RECLAIM;
+
+		page = alloc_surplus_huge_page(h, gfp, nid, nodemask);
+		if (page) {
+			mpol_cond_put(mpol);
+			return page;
+		}
+
+		/* Fallback to all nodes */
+		nodemask = NULL;
+	}
+#endif
 	page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask, false);
 	mpol_cond_put(mpol);
 
--- a/mm/mempolicy.c~mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many
+++ a/mm/mempolicy.c
@@ -2054,7 +2054,8 @@ int huge_node(struct vm_area_struct *vma
 					huge_page_shift(hstate_vma(vma)));
 	} else {
 		nid = policy_node(gfp_flags, *mpol, numa_node_id());
-		if ((*mpol)->mode == MPOL_BIND)
+		if ((*mpol)->mode == MPOL_BIND ||
+		    (*mpol)->mode == MPOL_PREFERRED_MANY)
 			*nodemask = &(*mpol)->nodes;
 	}
 	return nid;
_

Patches currently in -mm which might be from ben.widawsky@intel.com are

mm-mempolicy-enable-page-allocation-for-mpol_preferred_many-for-general-cases.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch
mm-mempolicy-advertise-new-mpol_preferred_many.patch

