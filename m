Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 884AEC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Mar 2022 19:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiCATDS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 14:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiCATDR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 14:03:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9600D13CF5
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 11:02:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 488EAB81CB5
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 19:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9327C340EE;
        Tue,  1 Mar 2022 19:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646161352;
        bh=scgdJS8s1kBhKJShwBBWI6gzbWdNyIaloCHEO14kjo4=;
        h=Date:To:From:Subject:From;
        b=viwsQuMHgb6bYTfKqGyiZygzvMJ6qX8IdY+o62sZTmgjGLPc1mHV72qhYogJ7Tf8G
         C50gA5Cq41HGFvardynVgRt+xf7guOtWbp2dN7qtxxPEVKGhTx+oikxGH+5sJBJtqJ
         YMMbTTmW2ag+Y+vWxOiQU4ZeRvYOfhwHVEdgIRKA=
Date:   Tue, 01 Mar 2022 11:02:32 -0800
To:     mm-commits@vger.kernel.org, bigeasy@linutronix.de,
        andreyknvl@google.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix-2.patch added to -mm tree
Message-Id: <20220301190232.D9327C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unnecessary check in alloc_thread_stack_node()
has been added to the -mm tree.  Its filename is
     kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix-2.patch

