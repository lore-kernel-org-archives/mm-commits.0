Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AF5C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbiGDAEZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGDAEZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:04:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B1860EC
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 302106128E
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781ACC341C6;
        Mon,  4 Jul 2022 00:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656893063;
        bh=AAep6D5NGZ3YKgIZwtNiIXRKCN/kNVIHTSFlmCQpQRs=;
        h=Date:To:From:Subject:From;
        b=Rl90r/S5mko4RZT4mtlvLxInCbOQwMaH31I2gR0tpvImKe4KyPGhI1SpxJ6rNTwBx
         K2iwM1UI7805ms08OMrkvrtp+cHEdIitR3111QfUUtl0W8Md9Bd2aSZlz6VzT4+9oV
         qTsWku7NTuan/RiUIA3uIumG4zfseO0MTB8uqvj8=
Date:   Sun, 03 Jul 2022 17:04:22 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-do-not-lookup-algorithm-in-backends-table-v2.patch removed from -mm tree
Message-Id: <20220704000423.781ACC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: do not lookup algorithm in backends table
has been removed from the -mm tree.  Its filename was
     zram-do-not-lookup-algorithm-in-backends-table-v2.patch

This patch was dropped because it was folded into zram-do-not-lookup-algorithm-in-backends-table.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not lookup algorithm in backends table
Date: Fri, 24 Jun 2022 15:06:06 +0900

add comment

Link: https://lkml.kernel.org/r/20220624060606.1014474-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/block/zram/zcomp.c~zram-do-not-lookup-algorithm-in-backends-table-v2
+++ a/drivers/block/zram/zcomp.c
@@ -211,6 +211,11 @@ struct zcomp *zcomp_create(const char *c
 	struct zcomp *comp;
 	int error;
 
+	/*
+	 * Crypto API will execute /sbin/modprobe if the compression module
+	 * is not loaded yet. We must do it here, otherwise we are about to
+	 * call /sbin/modprobe under CPU hot-plug lock.
+	 */
 	if (!zcomp_available_algorithm(compress))
 		return ERR_PTR(-EINVAL);
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-lookup-algorithm-in-backends-table.patch

