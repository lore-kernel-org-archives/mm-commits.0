Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCFCC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjFIXMh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjFIXMg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:12:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1F72D7C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85CE165985
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB61C433D2;
        Fri,  9 Jun 2023 23:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352355;
        bh=+Fy0B100QNQYuj9lT4lDHAQkpox2F9ytgwAJ1u1L4GY=;
        h=Date:To:From:Subject:From;
        b=qEcd0fPrzthiY04gmB+RHg1hF9hjCwfSPnxgAbyRpQMoUI9r1zWz3o7qpn9Qu6TZf
         tWWLtDaG9A/t6T7jnTvDm89UMKem5/CrZIsJQk4ytfyl+jCdhoXYbwN+Wlb/hV2oWU
         tNf+8YrO56o+utbhpul+ol4LqGiTWCR1E39PjktA=
Date:   Fri, 09 Jun 2023 16:12:34 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] cachestat-implement-cachestat-syscall-fix.patch removed from -mm tree
Message-Id: <20230609231234.DFB61C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cachestat: implement cachestat syscall (fix)
has been removed from the -mm tree.  Its filename was
     cachestat-implement-cachestat-syscall-fix.patch

This patch was dropped because it was folded into cachestat-implement-cachestat-syscall.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: cachestat: implement cachestat syscall (fix)
Date: Wed, 3 May 2023 19:20:44 -0700

This fixlet replaces rounddown logic with the existing helper.

Link: https://lkml.kernel.org/r/20230504022044.3675469-1-nphamcs@gmail.com
Fixes: 5c289a59b1d0 ("cachestat: implement cachestat syscall")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/filemap.c~cachestat-implement-cachestat-syscall-fix
+++ a/mm/filemap.c
@@ -4163,8 +4163,7 @@ static void filemap_cachestat(struct add
 			int order = xa_get_order(xas.xa, xas.xa_index);
 
 			nr_pages = 1 << order;
-			/* rounds down to the nearest multiple of 2^order */
-			folio_first_index = xas.xa_index >> order << order;
+			folio_first_index = round_down(xas.xa_index, 1 << order);
 			folio_last_index = folio_first_index + nr_pages - 1;
 
 			/* Folios might straddle the range boundaries, only count covered pages */
_

Patches currently in -mm which might be from nphamcs@gmail.com are

workingset-refactor-lru-refault-to-expose-refault-recency-check.patch
cachestat-implement-cachestat-syscall.patch
cachestat-wire-up-cachestat-for-other-architectures.patch
cachestat-wire-up-cachestat-for-other-architectures-fix.patch
selftests-add-selftests-for-cachestat.patch

