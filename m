Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C785C678DB
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 18:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjBMSxb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 13:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjBMSx0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 13:53:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6031F5DC
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 10:53:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3C2CB816D4
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 18:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757F9C433EF;
        Mon, 13 Feb 2023 18:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676314402;
        bh=/Jv9sFUffQHrDqXoZGpTur4UEaDbFlUG9TtBYuuPaY8=;
        h=Date:To:From:Subject:From;
        b=RqCxAuWlWzBi6FJD9KNhUry3VL4HxGFftI0vFPHQSRVvKUIWGdTlYheo0eToGahgn
         dLCTgXH6CKJLhkobninIXglDM5GRdCy64V/zDkmDfdL9VqKQoiC/Q7oLPp+8uAbiuL
         ysGkQw+ESSQjikk3yn35cOSLvAEECoym6zt0Yos0=
Date:   Mon, 13 Feb 2023 10:53:21 -0800
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-call-panic-when-memoryless-node-allocation-fails.patch added to mm-unstable branch
Message-Id: <20230213185322.757F9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: call panic() when memoryless node allocation fails
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-call-panic-when-memoryless-node-allocation-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-call-panic-when-memoryless-node-allocation-fails.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: page_alloc: call panic() when memoryless node allocation fails
Date: Sun, 12 Feb 2023 19:10:27 +0800

In free_area_init(), we will continue to run after allocation of
memoryless node pgdat fails.  However, in the subsequent process (such as
when initializing zonelist), the case that NODE_DATA(nid) is NULL is not
handled, which will cause panic.  Instead of this, it's better to call
panic() directly when the memory allocation fails during system boot.

Link: https://lkml.kernel.org/r/20230212111027.95520-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-page_alloc-call-panic-when-memoryless-node-allocation-fails
+++ a/mm/page_alloc.c
@@ -8422,11 +8422,9 @@ void __init free_area_init(unsigned long
 
 			/* Allocator not initialized yet */
 			pgdat = arch_alloc_nodedata(nid);
-			if (!pgdat) {
-				pr_err("Cannot allocate %zuB for node %d.\n",
-						sizeof(*pgdat), nid);
-				continue;
-			}
+			if (!pgdat)
+				panic("Cannot allocate %zuB for node %d.\n",
+				       sizeof(*pgdat), nid);
 			arch_refresh_nodedata(nid, pgdat);
 			free_area_init_memoryless_node(nid);
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-page_alloc-call-panic-when-memoryless-node-allocation-fails.patch

