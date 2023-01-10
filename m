Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CC4C54EBE
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 00:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjAJA41 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 19:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbjAJA4Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 19:56:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6A93D1D1
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 16:56:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5111C60C6B
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 00:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A58AC433D2;
        Tue, 10 Jan 2023 00:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673312183;
        bh=1UGXqcwoEJnCMP4jRVDvWnCX1hEQMy2cc3Yl8YLcfcY=;
        h=Date:To:From:Subject:From;
        b=RWNvsriVrsptM169ZCIVtsX8SoMKj+GE1ikS96q4o5adIIC4Cb5aUf4o5ZXkHYH6H
         6mXND0D625h24jIZSvU4pnP74R8kK/fsWyhH8Y3wZg7pRzAS/q1kzZp5aPkmzxIORC
         4k+Skw3iBMwxcb2aOSahoOWeRvOVYbwcLacrUulc=
Date:   Mon, 09 Jan 2023 16:56:22 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch added to mm-unstable branch
Message-Id: <20230110005623.7A58AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: skip chain size calculation for pow_of_2 classes
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: skip chain size calculation for pow_of_2 classes
Date: Mon, 9 Jan 2023 12:38:36 +0900

If a class size is power of 2 then it wastes no memory and the best
configuration is 1 physical page per-zspage.

Link: https://lkml.kernel.org/r/20230109033838.2779902-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zsmalloc.c~zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes
+++ a/mm/zsmalloc.c
@@ -2287,6 +2287,9 @@ static int calculate_zspage_chain_size(i
 	int i, min_waste = INT_MAX;
 	int chain_size = 1;
 
+	if (is_power_of_2(class_size))
+		return chain_size;
+
 	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
 		int waste;
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-correctly-handle-all-next_arg-cases.patch
zsmalloc-rework-zspage-chain-size-selection.patch
zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch
zsmalloc-make-zspage-chain-size-configurable.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

