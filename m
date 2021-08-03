Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5B4C432BE
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85484610A0
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhHCVtn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 17:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhHCVtk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 17:49:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75B536103C;
        Tue,  3 Aug 2021 21:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628027368;
        bh=qPoycBo9OtBi6Zd+X3HBXLaC407l4cjM9kvXWk0yCRw=;
        h=Date:From:To:Subject:From;
        b=b7P14pbsNeyg1q/iJMji51UXutz6YYYB7QfQ0jZUsSoYYvEI8Jmoyk5l5GPIIiqPz
         H+GFyB0kogG8isPothTEAFPTJIeX1VSp+Yq/5wMyqafsmu5WMWVdCgn1pYxVPtVk4K
         ZJTS9LXrbcIXCyNVrliIb1oKEk5ylMsI3ewVJsoM=
Date:   Tue, 03 Aug 2021 14:49:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        rientjes@google.com, rdunlap@infradead.org,
        mike.kravetz@oracle.com, mhocko@suse.com, mhocko@kernel.org,
        mgorman@techsingularity.net, feng.tang@intel.com,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        ak@linux.intel.com, aarcange@redhat.com, ben.widawsky@intel.com
Subject:  [to-be-updated]
 =?us-ascii?Q?mm-mempolicy-enable-page-allocation-for-mpol=5Fpreferred=5F?=
 =?us-ascii?Q?many-for-general-cases.patch?= removed from -mm tree
Message-ID: <20210803214928.XYYg0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: enable page allocation for MPOL_PREFERRED_MANY for general cases
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-enable-page-allocation-for-mpol_preferred_many-for-general-cases.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ben Widawsky <ben.widawsky@intel.com>
Subject: mm/mempolicy: enable page allocation for MPOL_PREFERRED_MANY for general cases

In order to support MPOL_PREFERRED_MANY which is used by set_mempolicy(2),
mbind(2), enable both alloc_pages() and alloc_pages_vma() by using
alloc_page_preferred_many().

Link: https://lkml.kernel.org/r/1626077374-81682-4-git-send-email-feng.tang@intel.com
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/mempolicy.c~mm-mempolicy-enable-page-allocation-for-mpol_preferred_many-for-general-cases
+++ a/mm/mempolicy.c
@@ -2207,6 +2207,12 @@ struct page *alloc_pages_vma(gfp_t gfp,
 		goto out;
 	}
 
+	if (pol->mode == MPOL_PREFERRED_MANY) {
+		page = alloc_page_preferred_many(gfp, order, pol);
+		mpol_cond_put(pol);
+		goto out;
+	}
+
 	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage)) {
 		int hpage_node = node;
 
@@ -2286,6 +2292,8 @@ struct page *alloc_pages(gfp_t gfp, unsi
 	 */
 	if (pol->mode == MPOL_INTERLEAVE)
 		page = alloc_page_interleave(gfp, order, interleave_nodes(pol));
+	else if (pol->mode == MPOL_PREFERRED_MANY)
+		page = alloc_page_preferred_many(gfp, order, pol);
 	else
 		page = __alloc_pages(gfp, order,
 				policy_node(gfp, pol, numa_node_id()),
_

Patches currently in -mm which might be from ben.widawsky@intel.com are

mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch
mm-mempolicy-advertise-new-mpol_preferred_many.patch

