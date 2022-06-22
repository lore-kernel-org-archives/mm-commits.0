Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B575CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 19:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbiFVTWp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Jun 2022 15:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiFVTWo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2022 15:22:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5148838D90
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 12:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E12AA60AD7
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 19:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739B4C34114;
        Wed, 22 Jun 2022 19:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655925762;
        bh=gYE8T/h/y5avjfVI+ZikvZcE41p9k0NgLCYsrOHCWmg=;
        h=Date:To:From:Subject:From;
        b=OOtM1Z9VOd1CI78yXeZT/4z2E+hW7KEr2MKPxUPgkCdOvbx/GuV1kOffKSf02ZIhw
         oGm1ZXhZvXEy+l2/4+waqQT7ojYw4z01HOAhUA+fAJ86Xlt7fMiesaWP1Q3WXvgs0R
         itVizYS64Bo0WVrUsi189AYp3unIvOhYAMybZrQI=
Date:   Wed, 22 Jun 2022 12:22:34 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-lookup-algorithm-in-backends-table.patch added to mm-unstable branch
Message-Id: <20220622192241.739B4C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: do not lookup algorithm in backends table
has been added to the -mm mm-unstable branch.  Its filename is
     zram-do-not-lookup-algorithm-in-backends-table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-lookup-algorithm-in-backends-table.patch

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
Date: Wed, 22 Jun 2022 11:35:01 +0900

Always use crypto_has_comp() so that crypto can lookup module, call
usermodhelper to load the modules, wait for usermodhelper to finish and so
on.  Otherwise crypto will do all of these steps under CPU hot-plug lock
and this looks like too much stuff to handle under the CPU hot-plug lock. 
Besides this can end up in a deadlock when usermodhelper triggers a code
path that attempts to lock the CPU hot-plug lock, that zram already holds.

Link: https://lkml.kernel.org/r/20220622023501.517125-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-do-not-lookup-algorithm-in-backends-table
+++ a/drivers/block/zram/zcomp.c
@@ -63,12 +63,6 @@ static int zcomp_strm_init(struct zcomp_
 
 bool zcomp_available_algorithm(const char *comp)
 {
-	int i;
-
-	i = sysfs_match_string(backends, comp);
-	if (i >= 0)
-		return true;
-
 	/*
 	 * Crypto does not ignore a trailing new line symbol,
 	 * so make sure you don't supply a string containing
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-lookup-algorithm-in-backends-table.patch

