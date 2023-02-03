Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367DDC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjBCGmm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjBCGlH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13AC8FB77
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78848B828B2
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19639C4339B;
        Fri,  3 Feb 2023 06:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406272;
        bh=ZLUNsdaG47LFnXgiEEvU+jvnWQwCpS2AERrHqDs6vdA=;
        h=Date:To:From:Subject:From;
        b=CK5I5u3a1ZNkhb+rhMJZXt0R3G/4wFQ4V1Op9ipZs/IAPY7UjhjvpnphO/5YF2tBc
         koAI8EmD6ARtRvWr1on63wQ/d95Jr3chuJDz7UcuwToQfxwhMiic5g9vicIy6B5oHD
         9iU2h561ZJ7Aes445+7ZUMPi0aG2Hoy5v2fM6ffY=
Date:   Thu, 02 Feb 2023 22:37:51 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        mike.kravetz@oracle.com, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch removed from -mm tree
Message-Id: <20230203063752.19639C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: skip chain size calculation for pow_of_2 classes
has been removed from the -mm tree.  Its filename was
     zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: skip chain size calculation for pow_of_2 classes
Date: Wed, 18 Jan 2023 09:52:08 +0900

If a class size is power of 2 then it wastes no memory and the best
configuration is 1 physical page per-zspage.

Link: https://lkml.kernel.org/r/20230118005210.2814763-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes
+++ a/mm/zsmalloc.c
@@ -2370,6 +2370,9 @@ static int calculate_zspage_chain_size(i
 	int i, min_waste = INT_MAX;
 	int chain_size = 1;
 
+	if (is_power_of_2(class_size))
+		return chain_size;
+
 	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
 		int waste;
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


