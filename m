Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F231C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 19:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiFXTSw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiFXTSv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 15:18:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925194A3C4
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 12:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4056CB82BE4
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 19:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE797C34114;
        Fri, 24 Jun 2022 19:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656098328;
        bh=Nrcfee0pcal0zAi0dgdG2djPofC/mtMXDYQFDoA4dVk=;
        h=Date:To:From:Subject:From;
        b=k8G4AvbGUpgv4fd67/xuvLSgKZru51IA/YxRzsnhJhOje0I1vYpixDSPkonSe99rn
         OYO9j/i93SywKavJNNKgj401lH2yRtDK0LoYiH9oyfNrKfjNfiUS8mhGAZRAkoJy1c
         68i0UfKqQ6VZdkiCnuVM+5TRfevU/vbSGfhzhPgs=
Date:   Fri, 24 Jun 2022 12:18:47 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-lookup-algorithm-in-backends-table-v2.patch added to mm-unstable branch
Message-Id: <20220624191847.DE797C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: do not lookup algorithm in backends table
has been added to the -mm mm-unstable branch.  Its filename is
     zram-do-not-lookup-algorithm-in-backends-table-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-lookup-algorithm-in-backends-table-v2.patch

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
zram-do-not-lookup-algorithm-in-backends-table-v2.patch

