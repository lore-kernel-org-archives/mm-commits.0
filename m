Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0A9C6379F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 01:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjARBKp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 20:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjARBJk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 20:09:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDC63D926
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 17:04:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3882F61495
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 01:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC75C433D2;
        Wed, 18 Jan 2023 01:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674003855;
        bh=bR1ofc6cQsMdZ3aspD6hhqCKsvq5TT96sCuQtUJiOLc=;
        h=Date:To:From:Subject:From;
        b=X3UlurQgplCx6JqkUfOyx1beSyy4So0Rgm19NeQf5s22ro61+cFwL+CJQsV548BRX
         8vJyJvF1CncA1Y/JCjGHbZrGfXeJNQMG1r9UjQyArTBVIfgZzcxG7ZR0TLF4H+M4Mo
         epqKzZ3K9pdlXyoopK447cL/Z6gWQ8MDpae7Lu6k=
Date:   Tue, 17 Jan 2023 17:04:14 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        mike.kravetz@oracle.com, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch added to mm-unstable branch
Message-Id: <20230118010415.8FC75C433D2@smtp.kernel.org>
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

zram-correctly-handle-all-next_arg-cases.patch
zsmalloc-rework-zspage-chain-size-selection.patch
zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch
zsmalloc-make-zspage-chain-size-configurable.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

