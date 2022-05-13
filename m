Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8DEC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377798AbiEMT1a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383958AbiEMT0D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:26:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8603B3B3ED
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:23:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14372B8315D
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B411BC34113;
        Fri, 13 May 2022 19:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469825;
        bh=TO10REQjHz4DKExcIGRhcYKOvfrjDjVXt1nUMGWtDxs=;
        h=Date:To:From:Subject:From;
        b=2fVZeHj4tuz+heZIo0fThs/vLMdUoP07o5gmgr5i3Xb6sLL/zCDaJmMXaZQ3DzNAV
         EfoWtZc0XfGYaujkCr3G4cdTJX5JKVPOzArFeUkXsGUyGoViF3Ki3npUskyiAsYAmy
         UE5J4KrjK44dY9Q3DTt2A+Iq0dLTvmEuwfIhsQ6Y=
Date:   Fri, 13 May 2022 12:23:45 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        baihaowen@meizu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-mca-drop-redundant-spinlock-initialization.patch removed from -mm tree
Message-Id: <20220513192345.B411BC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: mca: Drop redundant spinlock initialization
has been removed from the -mm tree.  Its filename was
     ia64-mca-drop-redundant-spinlock-initialization.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haowen Bai <baihaowen@meizu.com>
Subject: ia64: mca: Drop redundant spinlock initialization

mlogbuf_rlock has declared and initialized by DEFINE_SPINLOCK,
so we don't need to spin_lock_init again, drop it.

Link: https://lkml.kernel.org/r/1652176897-4754-1-git-send-email-baihaowen@meizu.com
Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/mca.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/ia64/kernel/mca.c~ia64-mca-drop-redundant-spinlock-initialization
+++ a/arch/ia64/kernel/mca.c
@@ -290,7 +290,6 @@ static void ia64_mlogbuf_finish(int wait
 {
 	BREAK_LOGLEVEL(console_loglevel);
 
-	spin_lock_init(&mlogbuf_rlock);
 	ia64_mlogbuf_dump();
 	printk(KERN_EMERG "mlogbuf_finish: printing switched to urgent mode, "
 		"MCA/INIT might be dodgy or fail.\n");
_

Patches currently in -mm which might be from baihaowen@meizu.com are


