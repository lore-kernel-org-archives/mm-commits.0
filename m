Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBA9C2D0A1
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8585822258
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709270;
	bh=KPxuTJR3f3PNH777oauMZdPbqcuDgp+UCEC0wwMUglk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1Dipvu5LAiuiC91Evg0JLA9GuhgjKWM2ylUEr5yPgAvH5yeUTtgFYBRUnrATFX1wR
	 SdnJWmRJ088WLRM9f9ZtFWKfI9K0kIA2fSlaE3mZdMdjs3leLMOQsLiUkRl99icTCd
	 y3qEi/UhhzsH+OOeZNy/tnF/C5hPxER2YGerwTx0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgJNVBH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNVBG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2FE32068E;
        Wed, 14 Oct 2020 21:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709234;
        bh=KPxuTJR3f3PNH777oauMZdPbqcuDgp+UCEC0wwMUglk=;
        h=Date:From:To:Subject:From;
        b=Zrx2Ex6ChyikamqqSSO5PYHZoM518SYX+1AJjI3fatwpo5qPWwHPVSVbwrRTmioYu
         tedfYG21M7bkoFvJ2zlGzerbFq3BM0FEMczCcN4ZYbTZ15oTa6iu7WEMZKRVKyMOco
         S/m2bAGRSsTjvMDoRvqsqsQlBKMlfOJHTdFJAHdQ=
Date:   Wed, 14 Oct 2020 14:00:33 -0700
From:   akpm@linux-foundation.org
To:     bsingharora@gmail.com, hannes@cmpxchg.org, ira.weiny@intel.com,
        jglisse@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcg-fix-device-private-memcg-accounting.patch removed from -mm tree
Message-ID: <20201014210033.d_MWO2oEm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: fix device private memcg accounting
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-device-private-memcg-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/memcg: fix device private memcg accounting

The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
NULL before checking is_device_private_entry() so device private pages are
never handled.  Fix this by checking for non_swap_entry() after handling
device private swap PTEs.

I assume the memory cgroup accounting would be off somehow when moving
a process to another memory cgroup.  Currently, the device private page
is charged like a normal anonymous page when allocated and is uncharged
when the page is freed so I think that path is OK.

Link: https://lkml.kernel.org/r/20201009215952.2726-1-rcampbell@nvidia.com
xFixes: c733a82874a7 ("mm/memcontrol: support MEMORY_DEVICE_PRIVATE")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-fix-device-private-memcg-accounting
+++ a/mm/memcontrol.c
@@ -5516,7 +5516,7 @@ static struct page *mc_handle_swap_pte(s
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
 
-	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
+	if (!(mc.flags & MOVE_ANON))
 		return NULL;
 
 	/*
@@ -5535,6 +5535,9 @@ static struct page *mc_handle_swap_pte(s
 		return page;
 	}
 
+	if (non_swap_entry(ent))
+		return NULL;
+
 	/*
 	 * Because lookup_swap_cache() updates some statistics counter,
 	 * we call find_get_page() with swapper_space directly.
_

Patches currently in -mm which might be from rcampbell@nvidia.com are


