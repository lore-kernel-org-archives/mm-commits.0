Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF185C6377B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D77DD61221
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhGUUKP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 16:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhGUUKN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 16:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7574A61222;
        Wed, 21 Jul 2021 20:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626900648;
        bh=PSANow8kn7uksadM2Yxi89HwM8AhZSOD7SLsgka0VXk=;
        h=Date:From:To:Subject:From;
        b=xxKxY+p81I+95UFSnOKJwYi+WFY+LAb3HxefCVV3hS/Ad3wcOlnDyLyss/XvmEpoM
         gFxhQEhRvrvntOsDo3Yvfxb4CXQ9WOtI0orPwYdvoo+s6e7PXlsZmU7zbyMOl+OSSQ
         L0MRtvhVqmQneVJ0PG1LbGRVpy0ZaoYqqTzSK8nQ=
Date:   Wed, 21 Jul 2021 13:50:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        yang.shi@linux.alibaba.com, weixugc@google.com,
        shy828301@gmail.com, rientjes@google.com, osalvador@suse.de,
        mhocko@suse.com, gthelen@google.com, david@redhat.com,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        kbusch@kernel.org
Subject:  + mm-vmscan-consider-anonymous-pages-without-swap-v11.patch
 added to -mm tree
Message-ID: <20210721205046.Hi7ds%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-consider-anonymous-pages-without-swap-v11
has been added to the -mm tree.  Its filename is
     mm-vmscan-consider-anonymous-pages-without-swap-v11.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-consider-anonymous-pages-without-swap-v11.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-consider-anonymous-pages-without-swap-v11.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -552,7 +552,7 @@ static inline bool can_reclaim_anon_page
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
mm-vmscan-consider-anonymous-pages-without-swap-v11.patch

