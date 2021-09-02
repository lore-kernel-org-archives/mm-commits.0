Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0215C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C52496108E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344043AbhIBVVb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346238AbhIBVVa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43BDE61059;
        Thu,  2 Sep 2021 21:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617631;
        bh=yUkUovPLCm9nCLQ3JeQ9SP/P/Yu30c7xQCdKc7HYDIw=;
        h=Date:From:To:Subject:From;
        b=g8qjHPdYoW7FKXnh3u4I6u6GlIfNetPh5yyJS9n9u6qpZpUEEqvviiom5Mv9o0ASV
         Zx+MFBSfx2Hc0Qb26qIyRndoPzBDtSOKDHJCFSkkWZyRmL1YvmImLkgCamNQFc5dBe
         ZDpgtWjp/eJa130K3aVtebeqcZcyQ35WMezXS2O0=
Date:   Thu, 02 Sep 2021 14:20:30 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, weixugc@google.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  [folded-merged]
 mm-vmscan-consider-anonymous-pages-without-swap-v11.patch removed from -mm
 tree
Message-ID: <20210902212030.N8LmDNIIT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-consider-anonymous-pages-without-swap-v11
has been removed from the -mm tree.  Its filename was
     mm-vmscan-consider-anonymous-pages-without-swap-v11.patch

This patch was dropped because it was folded into mm-vmscan-consider-anonymous-pages-without-swap.patch

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: mm-vmscan-consider-anonymous-pages-without-swap-v11

Rename can_demote_anon_pages() to can_demote() to reflect the fact that
the function is for anon and file pages.

Link: https://lkml.kernel.org/r/20210715055145.195411-8-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20210721063926.3024591-7-ying.huang@intel.com
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Wei Xu <weixugc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-consider-anonymous-pages-without-swap-v11
+++ a/mm/vmscan.c
@@ -555,7 +555,7 @@ static inline bool can_reclaim_anon_page
 	 *
 	 * Can it be reclaimed from this node via demotion?
 	 */
-	return can_demote_anon_pages(nid, sc);
+	return can_demote(nid, sc);
 }
 
 /*
_

Patches currently in -mm which might be from kbusch@kernel.org are

mm-vmscan-consider-anonymous-pages-without-swap.patch

