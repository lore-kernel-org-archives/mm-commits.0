Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF34BC4338F
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B83D260F9C
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhHCVtm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 17:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229918AbhHCVth (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 17:49:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E78B60725;
        Tue,  3 Aug 2021 21:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628027365;
        bh=m1hGfJ0G0okMyy5qL4sqLp9rLYkBBkvCl/jLv/LGspA=;
        h=Date:From:To:Subject:From;
        b=KDa5abvDAQMBzfVHnRHgrsPG00kBnXZ58fiKQq87tvT4UUg0OcAKcgVD5vb4gFiIb
         ad/jUX4KPrkGxtSynst/HKGhlMoyM9Ek80ZLXTDuIYAWKN/54zMA75h6rfYYNcjpL9
         b9UAHhSy4b1aq1ChHskX5OkeQR7Dq2euQEytOcvI=
Date:   Tue, 03 Aug 2021 14:49:25 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        rientjes@google.com, rdunlap@infradead.org,
        mike.kravetz@oracle.com, mhocko@suse.com, mhocko@kernel.org,
        mgorman@techsingularity.net, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, ben.widawsky@intel.com,
        ak@linux.intel.com, aarcange@redhat.com, feng.tang@intel.com
Subject:  [to-be-updated]
 mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch
 removed from -mm tree
Message-ID: <20210803214925.5Ia5r%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memplicy: add page allocation function for MPOL_PREFERRED_MANY policy
has been removed from the -mm tree.  Its filename was
     mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/memplicy: add page allocation function for MPOL_PREFERRED_MANY policy

The semantics of MPOL_PREFERRED_MANY is similar to MPOL_PREFERRED, that it
will first try to allocate memory from the preferred node(s), and fallback
to all nodes in system when first try fails.

Add a dedicated function for it just like 'interleave' policy.

Link: https://lore.kernel.org/r/20200630212517.308045-9-ben.widawsky@intel.com
Link: https://lkml.kernel.org/r/1626077374-81682-3-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Co-developed-by: Ben Widawsky <ben.widawsky@intel.com>
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

 mm/mempolicy.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/mm/mempolicy.c~mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy
+++ a/mm/mempolicy.c
@@ -2153,6 +2153,25 @@ static struct page *alloc_page_interleav
 	return page;
 }
 
+static struct page *alloc_page_preferred_many(gfp_t gfp, unsigned int order,
+						struct mempolicy *pol)
+{
+	struct page *page;
+
+	/*
+	 * This is a two pass approach. The first pass will only try the
+	 * preferred nodes but skip the direct reclaim and allow the
+	 * allocation to fail, while the second pass will try all the
+	 * nodes in system.
+	 */
+	page = __alloc_pages(((gfp | __GFP_NOWARN) & ~__GFP_DIRECT_RECLAIM),
+				order, first_node(pol->nodes), &pol->nodes);
+	if (!page)
+		page = __alloc_pages(gfp, order, numa_node_id(), NULL);
+
+	return page;
+}
+
 /**
  * alloc_pages_vma - Allocate a page for a VMA.
  * @gfp: GFP flags.
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-2.patch
mm-mempolicy-unify-the-create-func-for-bind-interleave-prefer-many-policies.patch

