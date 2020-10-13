Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E531C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB5E22222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633347;
	bh=9fwL8tBMAOnyztFn4YufATojkOFZcj/z+3/dC/Q8rdo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VnWtLxH0vu2psSObRRWJYLXn8gHoZJYilL9KStktqmjLvrAa2QLtH76l/lqNTbuV0
	 nv99obvbCYqRxzxTbftwEnqyDJmRYOOd4nXgxWzRrwoyfWWjGVgVl69hHEo7oAFP/m
	 3mgPyZQyVffgEsv5/6QWxjmcbiumtF/5k9L33qI4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388519AbgJMXzq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXzq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C345D2223F;
        Tue, 13 Oct 2020 23:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633346;
        bh=9fwL8tBMAOnyztFn4YufATojkOFZcj/z+3/dC/Q8rdo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FFdxSOFBnpL6j8fa1jj53A8Si88Tm42QSlvJki6uc8uZakgGuuF887SF3rEmDkin2
         eM1KOA2dfQ0waXCFFyOwvQ1ezX+HMoO6JAb/3EChbKtRHlt6j9fpZupC0uH+TZ/R2v
         z/bEhq7v4JXwxd/JUQwygWSgoLKSIrum29UfeIYY=
Date:   Tue, 13 Oct 2020 16:55:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mateusznosek0@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 133/181] mm/page_alloc.c: micro-optimization
 remove unnecessary branch
Message-ID: <20201013235545.XVH-2PGlS%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
