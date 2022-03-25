Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C9BC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244440AbiCYAbX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244454AbiCYAbX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:31:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6945642D
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D42DB826FF
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF16C340ED;
        Fri, 25 Mar 2022 00:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168188;
        bh=apnVtfMxkMs2OTOO1Ar3XbsB+80UofVPzRz2sEeL0ks=;
        h=Date:To:From:Subject:From;
        b=1ql+oT7mjGBIIddFF2wLqKZNibslNeKOveOxQPin3dZYptBrfkthiEf9HKUmu2RGv
         w3uJ5nXX2kflY/6b3M+DjWpSrncpEk7qj5LiipeAOIsb6rc7mktoQzlJNVY3VTkd5o
         VU8rv2pSZXc19qUXgcvs2T61snjwvBBiDBsjVs3Y=
Date:   Thu, 24 Mar 2022 17:29:47 -0700
To:     mm-commits@vger.kernel.org, bigeasy@linutronix.de,
        andreyknvl@google.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix-2.patch removed from -mm tree
Message-Id: <20220325002947.EEF16C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unnecessary check in alloc_thread_stack_node()
has been removed from the -mm tree.  Its filename was
     kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix-2.patch

This patch was dropped because it was folded into kasan-arm64-reset-pointer-tags-of-vmapped-stacks.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm: remove unnecessary check in alloc_thread_stack_node()

The "stack" pointer cannot be NULL at this point so there is no
need to check.

Link: https://lkml.kernel.org/r/20220301080706.GB17208@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/fork.c~kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix-2
+++ a/kernel/fork.c
@@ -328,8 +328,7 @@ static int alloc_thread_stack_node(struc
 	 * so cache the vm_struct.
 	 */
 	tsk->stack_vm_area = vm;
-	if (stack)
-		stack = kasan_reset_tag(stack);
+	stack = kasan_reset_tag(stack);
 	tsk->stack = stack;
 	return 0;
 }
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

kasan-arm64-reset-pointer-tags-of-vmapped-stacks.patch

