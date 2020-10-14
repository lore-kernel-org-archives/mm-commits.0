Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9CCC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DF13206CB
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709367;
	bh=FRYbHzUViYnxNPw2lXb7vQBjvOk8LP4ctgGz/Ld9z90=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KCZAii2Au1u9TIpV3+skfcaZpBjyftw9GOkF7GK6/GrsjghNzf8zileHqRuGPoCrR
	 AvkgmXFwUkDLgMDaR+wLpggAcmqcPED2Od/xFRFZ/t1b9LD6Ztc3NSaUNNmOslN+fh
	 cAVKqLmBtlxb/sdCcNTe09/3vUyJzhdbeiZlFLg0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbgJNVCq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVCq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91DA2206B2;
        Wed, 14 Oct 2020 21:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709365;
        bh=FRYbHzUViYnxNPw2lXb7vQBjvOk8LP4ctgGz/Ld9z90=;
        h=Date:From:To:Subject:From;
        b=H5UYyAYAWVF8R0BAAxnCs1HV6ICKCHgRgqK8sc/OU7jDQuLqd7Y8nge/WetMvXS+C
         4MS/y428Lpr8WOIoHRMpnbcth3gOo4wezYWYkH0CLuXv/Bg6SpJQacvbxLaiy2Qz2H
         n1j/OeLyG347wFoh5f3Sh6FiAIzFMNgXq7D7CC1M=
Date:   Wed, 14 Oct 2020 14:02:45 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mateusznosek0@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-page_allocc-micro-optimization-remove-unnecessary-branch.patch removed
 from -mm tree
Message-ID: <20201014210245.YW6itGb1j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: micro-optimization remove unnecessary branch
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-micro-optimization-remove-unnecessary-branch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/page_alloc.c: micro-optimization remove unnecessary branch

Previously flags check was separated into two separated checks with two
separated branches. In case of presence of any of two mentioned flags,
the same effect on flow occurs. Therefore checks can be merged and one
branch can be avoided.

Link: https://lkml.kernel.org/r/20200911092310.31136-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-micro-optimization-remove-unnecessary-branch
+++ a/mm/page_alloc.c
@@ -3986,8 +3986,10 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	 * success so it is time to admit defeat. We will skip the OOM killer
 	 * because it is very likely that the caller has a more reasonable
 	 * fallback than shooting a random task.
+	 *
+	 * The OOM killer may not free memory on a specific node.
 	 */
-	if (gfp_mask & __GFP_RETRY_MAYFAIL)
+	if (gfp_mask & (__GFP_RETRY_MAYFAIL | __GFP_THISNODE))
 		goto out;
 	/* The OOM killer does not needlessly kill tasks for lowmem */
 	if (ac->highest_zoneidx < ZONE_NORMAL)
@@ -4004,10 +4006,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	 * failures more gracefully we should just bail out here.
 	 */
 
-	/* The OOM killer may not free memory on a specific node */
-	if (gfp_mask & __GFP_THISNODE)
-		goto out;
-
 	/* Exhausted what can be done so it's blame time */
 	if (out_of_memory(&oc) || WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
 		*did_some_progress = 1;
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-page_poisonc-replace-bool-variable-with-static-key.patch

