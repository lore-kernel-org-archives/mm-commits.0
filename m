Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B95CECAAD3
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 22:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiINWiV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiINWiU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 18:38:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244A67F26B
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 15:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3F0861F13
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 22:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3F8C433D6;
        Wed, 14 Sep 2022 22:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663195098;
        bh=0BfCj05tm20ijF27fGGYuwhWRCbA5nKD7IOtSaIEASY=;
        h=Date:To:From:Subject:From;
        b=f1UYo0/EvZvAD+cdyXD7ZxYLO2aSpu6AYn213bqQljBWn05+nGjdqwimwtoQAi4x/
         VNV9MWOR0O1oSdvUc9ExzULTRIJ2Tw/LwA2pFmrcdAveJ15m8Ho9mv86Jskz6sj1S+
         SWh9p8A/qWCCBFCq5HjXT9LIBZG2W/4iMyq9XuQg=
Date:   Wed, 14 Sep 2022 15:38:17 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-keep-comments-within-80-columns-limit.patch added to mm-unstable branch
Message-Id: <20220914223818.1A3F8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: keep comments within 80-columns limit
has been added to the -mm mm-unstable branch.  Its filename is
     zram-keep-comments-within-80-columns-limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-keep-comments-within-80-columns-limit.patch

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
Subject: zram: keep comments within 80-columns limit
Date: Wed, 14 Sep 2022 14:20:33 +0900

Several trivial fixups (that I should have spotted during review).

Link: https://lkml.kernel.org/r/20220914052033.838050-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-keep-comments-within-80-columns-limit
+++ a/drivers/block/zram/zram_drv.c
@@ -329,8 +329,8 @@ static ssize_t idle_store(struct device
 
 	if (!sysfs_streq(buf, "all")) {
 		/*
-		 * If it did not parse as 'all' try to treat it as an integer when
-		 * we have memory tracking enabled.
+		 * If it did not parse as 'all' try to treat it as an integer
+		 * when we have memory tracking enabled.
 		 */
 		u64 age_sec;
 
@@ -345,7 +345,10 @@ static ssize_t idle_store(struct device
 	if (!init_done(zram))
 		goto out_unlock;
 
-	/* A cutoff_time of 0 marks everything as idle, this is the "all" behavior */
+	/*
+	 * A cutoff_time of 0 marks everything as idle, this is the
+	 * "all" behavior.
+	 */
 	mark_idle(zram, cutoff_time);
 	rv = len;
 
@@ -1416,11 +1419,11 @@ compress_again:
 		if (comp_len != PAGE_SIZE)
 			goto compress_again;
 		/*
-		 * If the page is not compressible, you need to acquire the lock and
-		 * execute the code below. The zcomp_stream_get() call is needed to
-		 * disable the cpu hotplug and grab the zstrm buffer back.
-		 * It is necessary that the dereferencing of the zstrm variable below
-		 * occurs correctly.
+		 * If the page is not compressible, you need to acquire the
+		 * lock and execute the code below. The zcomp_stream_get()
+		 * call is needed to disable the cpu hotplug and grab the
+		 * zstrm buffer back. It is necessary that the dereferencing
+		 * of the zstrm variable below occurs correctly.
 		 */
 		zstrm = zcomp_stream_get(zram->comp);
 	}
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-waste-zram_table_entry-flags-bits.patch
zram-keep-comments-within-80-columns-limit.patch

