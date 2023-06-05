Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967AAC77B73
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 21:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjFEV4f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 17:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjFEV4e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 17:56:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B4FFD
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 14:56:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED72F622CB
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 21:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC83C433D2;
        Mon,  5 Jun 2023 21:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686002192;
        bh=HNyIe0YndxfuiEMKsqkO/CBFaB5N5+ZQM0GdKsZN78k=;
        h=Date:To:From:Subject:From;
        b=WwR9tSnmHIwiQZKccz82Fq+AYfVh0O+0WPfUxo/jSXwjHW2XAWa9Ti0+POGMR4Www
         G2v/WbWjXIG8Jobl0hGAM0uvXyeZ0T5jJFd3SjTWfUU/TE0d+2oyE0CDBbf9GFotz1
         RIp31AuDJnYff767t1150uQs8Q1vRuRhrWytKQTY=
Date:   Mon, 05 Jun 2023 14:56:31 -0700
To:     mm-commits@vger.kernel.org, zhiguangni01@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-improve-the-execution-efficiency-of-early_ioremap_setup.patch added to mm-unstable branch
Message-Id: <20230605215632.4DC83C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap.c: improve the execution efficiency of early_ioremap_setup()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-improve-the-execution-efficiency-of-early_ioremap_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-improve-the-execution-efficiency-of-early_ioremap_setup.patch

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
From: Liam Ni <zhiguangni01@gmail.com>
Subject: mm/early_ioremap.c: improve the execution efficiency of early_ioremap_setup()
Date: Sat, 3 Jun 2023 10:31:16 +0800

Reduce the number of invalid loops of the function early_ioremap_setup()
to improve the efficiency of function execution

Link: https://lkml.kernel.org/r/CACZJ9cU6t5sLoDwE6_XOg+UJLpZt4+qHfjYN2bA0s+3y9y6pQQ@mail.gmail.com
Signed-off-by: LiamNi <zhiguangni01@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/early_ioremap.c~mm-improve-the-execution-efficiency-of-early_ioremap_setup
+++ a/mm/early_ioremap.c
@@ -72,12 +72,10 @@ void __init early_ioremap_setup(void)
 {
 	int i;
 
-	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
-		if (WARN_ON(prev_map[i]))
-			break;
-
-	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		WARN_ON_ONCE(prev_map[i]);
 		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
+	}
 }
 
 static int __init check_early_ioremap_leak(void)
_

Patches currently in -mm which might be from zhiguangni01@gmail.com are

mm-improve-the-execution-efficiency-of-early_ioremap_setup.patch

