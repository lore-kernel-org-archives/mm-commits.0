Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C8BC001DB
	for <mm-commits@archiver.kernel.org>; Tue,  8 Aug 2023 21:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjHHVAV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Aug 2023 17:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbjHHVAA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2023 17:00:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F5091B16
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 11:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED473629ED
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 18:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478D3C433C8;
        Tue,  8 Aug 2023 18:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691518994;
        bh=qt/kcNw4aVfmquXguqDIFkNnjFSqn38ahZ1aKBwPMEo=;
        h=Date:To:From:Subject:From;
        b=hdIfUqTlaM+dashjVX6lCStVM9zh0+269y6TZUPOaqafXuSb99z+ckAiEyeWcF2od
         4BHWIxT3H4ZXFAVuLq9uwZ3XVEQuxHCTCdVDAl/6Ujnfth//B11Aq9IIob5uZPBEq/
         dGm+LU3ZHC2tYgeDD81c9k995N1Wy6dMiuy1fZS0=
Date:   Tue, 08 Aug 2023 11:23:13 -0700
To:     mm-commits@vger.kernel.org, alexjlzheng@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-remove-redundant-checks-for-root-memcg.patch added to mm-unstable branch
Message-Id: <20230808182314.478D3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: remove redundant checks for root memcg
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-remove-redundant-checks-for-root-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-remove-redundant-checks-for-root-memcg.patch

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
From: Jinliang Zheng <alexjlzheng@tencent.com>
Subject: writeback: remove redundant checks for root memcg
Date: Tue, 8 Aug 2023 16:44:32 +0800

The check for root memcg will be done in wb_get_lookup(), so remove the
redundant one to simplify the code.

Link: https://lkml.kernel.org/r/20230808084431.1632934-1-alexjlzheng@tencent.com
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/backing-dev.c~writeback-remove-redundant-checks-for-root-memcg
+++ a/mm/backing-dev.c
@@ -732,9 +732,6 @@ struct bdi_writeback *wb_get_create(stru
 
 	might_alloc(gfp);
 
-	if (!memcg_css->parent)
-		return &bdi->wb;
-
 	do {
 		wb = wb_get_lookup(bdi, memcg_css);
 	} while (!wb && !cgwb_create(bdi, memcg_css, gfp));
_

Patches currently in -mm which might be from alexjlzheng@tencent.com are

writeback-remove-redundant-checks-for-root-memcg.patch

