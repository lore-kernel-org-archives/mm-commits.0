Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F218C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4834E610CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350474AbhICVCN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350431AbhICVCM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81BE060FE6;
        Fri,  3 Sep 2021 21:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702872;
        bh=Sa/oZ3ABeIrqWwybwGAgi88SPBP/ju3+gfjoOM/yc48=;
        h=Date:From:To:Subject:From;
        b=nLYKChhsJjMVqHsdIN1tP9rTMygOTg3ocpB7VEeWUgW/Rrt6OQ3CrOuHByHmp219W
         d9vppJTQZUtGCqK6hxGxoIRpMuCJVM4cw2+VpsVeUFXOMr2ia4MXq01x/DGuHwQ1HN
         mZLqW//+mun7aAf5T9FRYK9sFHBOZcYrvJyDxJQU=
Date:   Fri, 03 Sep 2021 14:01:11 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  [merged]
 =?US-ASCII?Q?mm-memplicy-add-page-allocation-function-for-mpol=5Fpreferr?=
 =?US-ASCII?Q?ed=5Fmany-policy.patch?= removed from -mm tree
Message-ID: <20210903210111.Be3nZwpwq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memplicy: add page allocation function for MPOL_PREFERRED_MANY policy
has been removed from the -mm tree.  Its filename was
     mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/memplicy: add page allocation function for MPOL_PREFERRED_MANY policy

The semantics of MPOL_PREFERRED_MANY is similar to MPOL_PREFERRED, that it
will first try to allocate memory from the preferred node(s), and fallback
to all nodes in system when first try fails.

Add a dedicated function alloc_pages_preferred_many() for it just like for
'interleave' policy, which will be used by 2 general memoory allocation
APIs: alloc_pages() and alloc_pages_vma()

Link: https://lore.kernel.org/r/20200630212517.308045-9-ben.widawsky@intel.com
Link: https://lkml.kernel.org/r/1627970362-61305-3-git-send-email-feng.tang@intel.com
Suggested-by: Michal Hocko <mhocko@suse.com>
Originally-by: Ben Widawsky <ben.widawsky@intel.com>
Co-developed-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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

 mm/mempolicy.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/mm/mempolicy.c~mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy
+++ a/mm/mempolicy.c
@@ -2166,6 +2166,27 @@ static struct page *alloc_page_interleav
 	return page;
 }
 
+static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
+						int nid, struct mempolicy *pol)
+{
+	struct page *page;
+	gfp_t preferred_gfp;
+
+	/*
+	 * This is a two pass approach. The first pass will only try the
+	 * preferred nodes but skip the direct reclaim and allow the
+	 * allocation to fail, while the second pass will try all the
+	 * nodes in system.
+	 */
+	preferred_gfp = gfp | __GFP_NOWARN;
+	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
+	page = __alloc_pages(preferred_gfp, order, nid, &pol->nodes);
+	if (!page)
+		page = __alloc_pages(gfp, order, numa_node_id(), NULL);
+
+	return page;
+}
+
 /**
  * alloc_pages_vma - Allocate a page for a VMA.
  * @gfp: GFP flags.
@@ -2201,6 +2222,12 @@ struct page *alloc_pages_vma(gfp_t gfp,
 		goto out;
 	}
 
+	if (pol->mode == MPOL_PREFERRED_MANY) {
+		page = alloc_pages_preferred_many(gfp, order, node, pol);
+		mpol_cond_put(pol);
+		goto out;
+	}
+
 	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage)) {
 		int hpage_node = node;
 
@@ -2278,6 +2305,9 @@ struct page *alloc_pages(gfp_t gfp, unsi
 	 */
 	if (pol->mode == MPOL_INTERLEAVE)
 		page = alloc_page_interleave(gfp, order, interleave_nodes(pol));
+	else if (pol->mode == MPOL_PREFERRED_MANY)
+		page = alloc_pages_preferred_many(gfp, order,
+				numa_node_id(), pol);
 	else
 		page = __alloc_pages(gfp, order,
 				policy_node(gfp, pol, numa_node_id()),
_

Patches currently in -mm which might be from feng.tang@intel.com are


