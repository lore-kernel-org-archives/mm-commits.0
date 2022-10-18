Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167DEC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiJRAQk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiJRAOh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:14:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739C989CFE
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:12:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA78EB81BF3
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FF2C43142;
        Tue, 18 Oct 2022 00:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666051770;
        bh=PHmJ5SsCKaxMB8M2wQjkZXjNdg6f0/2Yk2BFYv3VGgo=;
        h=Date:To:From:Subject:From;
        b=uTt3EKwgvsGyJOyfcharGlU9gqISTbOgy/G5YVK/QwgE+Wx5DcB42LVGXdL35ClOX
         dSMVauIqfXldjLI6wGs7zBO28h4GQfhmUTZ7V/wcOWe6gP3hpnQSJo54EVyD9sV3fP
         4smimeWNCxFuDstOlUG5mnzkmP9QUfttWO/l29H0=
Date:   Mon, 17 Oct 2022 17:09:29 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-correct-typos.patch added to mm-unstable branch
Message-Id: <20221018000930.A0FF2C43142@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: correct typos
has been added to the -mm mm-unstable branch.  Its filename is
     zram-correct-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-correct-typos.patch

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
Subject: zram: correct typos
Date: Sun, 9 Oct 2022 18:07:20 +0900

Trivial comment typos fixes.

Link: https://lkml.kernel.org/r/20221009090720.1040633-9-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-correct-typos
+++ a/drivers/block/zram/zram_drv.c
@@ -759,7 +759,7 @@ static ssize_t writeback_store(struct de
 			zram_slot_unlock(zram, index);
 			/*
 			 * Return last IO error unless every IO were
-			 * not suceeded.
+			 * not succeeded.
 			 */
 			ret = err;
 			continue;
@@ -1658,7 +1658,7 @@ static int zram_recompress(struct zram *
 	/*
 	 * Either a compression error or we failed to compressed the object
 	 * in a way that will save us memory. Mark the object so that we
-	 * don't attemp to re-compress it again (RECOMP_SKIP).
+	 * don't attempt to re-compress it again (RECOMP_SKIP).
 	 */
 	if (comp_len_next >= huge_class_size ||
 	    comp_len_next >= comp_len_prev ||
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-correct-typos.patch

