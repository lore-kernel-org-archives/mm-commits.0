Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C10C38145
	for <mm-commits@archiver.kernel.org>; Thu,  8 Sep 2022 20:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiIHUnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Sep 2022 16:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIHUnY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2022 16:43:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD046B5A7C
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 13:43:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E151B82292
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 20:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D10C433D6;
        Thu,  8 Sep 2022 20:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662669801;
        bh=7pmMR9pe+2JS5x24LEOKvPvi6LY1gcgNcDbYTdqNn/0=;
        h=Date:To:From:Subject:From;
        b=Gx4WWML/RCLgxTh4j6gQ6dsbY4S+KCjl9joYdPgXH1dBV9LMEyT/+lWySRVObeQDk
         t4YEPdy8dvWZktj8bhyg7zKC7QJlbSm8YaPQleEBFOA0auYIYp3Q098K64J4akDxOp
         2FJl09fU3Vj7FKzxVz6cm9pW9vpYBcgmave9GMLo=
Date:   Thu, 08 Sep 2022 13:43:20 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        jingyuwang_vip@163.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-mqueue-remove-unnecessary-conditionals.patch added to mm-nonmm-unstable branch
Message-Id: <20220908204321.04D10C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: mqueue: remove unnecessary conditionals
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-mqueue-remove-unnecessary-conditionals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-mqueue-remove-unnecessary-conditionals.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Jingyu Wang <jingyuwang_vip@163.com>
Subject: ipc: mqueue: remove unnecessary conditionals
Date: Fri, 9 Sep 2022 02:54:52 +0800

iput() already handles null and non-null parameters, so there is no need
to use if().

Link: https://lkml.kernel.org/r/20220908185452.76590-1-jingyuwang_vip@163.com
Signed-off-by: Jingyu Wang <jingyuwang_vip@163.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/ipc/mqueue.c~ipc-mqueue-remove-unnecessary-conditionals
+++ a/ipc/mqueue.c
@@ -986,8 +986,7 @@ SYSCALL_DEFINE1(mq_unlink, const char __
 
 out_unlock:
 	inode_unlock(d_inode(mnt->mnt_root));
-	if (inode)
-		iput(inode);
+	iput(inode);
 	mnt_drop_write(mnt);
 out_name:
 	putname(name);
_

Patches currently in -mm which might be from jingyuwang_vip@163.com are

ipc-mqueue-remove-unnecessary-conditionals.patch

