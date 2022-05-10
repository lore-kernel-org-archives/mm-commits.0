Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B22BC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 22:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbiEJWaJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 18:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiEJWaI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 18:30:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC65269B75
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 15:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E66161811
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 22:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74711C385CF;
        Tue, 10 May 2022 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652221805;
        bh=XbzhOXUh/7mVcmgmQsGx2iJiBCIQF6L0XLT7luIBMKI=;
        h=Date:To:From:Subject:From;
        b=s5Y3G+NPMvPzhbDjDDP+8Mo6c3NvNLFEmmnAkbqll/k8dJXuo7Ph9dyL0tHZMf60H
         RoUSsxPIvYHBCayaFo1wTaza3HoJRAenUG9dCznL3aQjbhart+rXZqM1lhQWVCt8UY
         qsziN7jQzMl3z6r5jKGVXltOJZm1oQhaXrxWyz8I=
Date:   Tue, 10 May 2022 15:30:04 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        baihaowen@meizu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-mca-drop-redundant-spinlock-initialization.patch added to mm-nonmm-unstable branch
Message-Id: <20220510223005.74711C385CF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: mca: Drop redundant spinlock initialization
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-mca-drop-redundant-spinlock-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-mca-drop-redundant-spinlock-initialization.patch

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

ia64-mca-drop-redundant-spinlock-initialization.patch

