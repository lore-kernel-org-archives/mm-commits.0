Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3165BC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 22:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLOWYz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 17:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLOWYy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 17:24:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C1457B47
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 14:24:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCB6CB81CC8
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 22:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AEAC433EF;
        Thu, 15 Dec 2022 22:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671143090;
        bh=d44tSfV999aS5NBHO7jC79y87g8x3b9v5e85OQmkX7s=;
        h=Date:To:From:Subject:From;
        b=xCX4VVkl3AezZjF5przEewQrnudM42L9hQz6+hyS7UjZEoWguJ0uAxjoaXbYIFtD/
         Ds/Wl7Zu0HIVrr43yuPI1QHPENaHdWTol0TA6JFJkSW9tgUc14DejpC0v+m3nHuD59
         gZczdea71jEYOtJKWGfo9SVi5Lw2Zr9kqNt3WMvw=
Date:   Thu, 15 Dec 2022 14:24:49 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-zram-zsmalloc-add-an-additional-co-maintainer.patch added to mm-unstable branch
Message-Id: <20221215222450.76AEAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: zram: zsmalloc: Add an additional co-maintainer
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-zram-zsmalloc-add-an-additional-co-maintainer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-zram-zsmalloc-add-an-additional-co-maintainer.patch

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
From: Minchan Kim <minchan@kernel.org>
Subject: MAINTAINERS: zram: zsmalloc: Add an additional co-maintainer
Date: Tue, 13 Dec 2022 09:07:31 -0800

Move Sergey to co-maintainer for zram/zsmalloc since he has helped to
contribute/review those areas actively for eight years, which is quite
helpful.  Since Nitin has been inactive for several years, it's time to
move his name into CREDITS.

Link: https://lkml.kernel.org/r/20221213170731.796121-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    6 ++----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/CREDITS~maintainers-zram-zsmalloc-add-an-additional-co-maintainer
+++ a/CREDITS
@@ -1439,6 +1439,10 @@ N: Justin Guyett
 E: jguyett@andrew.cmu.edu
 D: via-rhine net driver hacking
 
+N: Nitin Gupta
+E: ngupta@vflare.org
+D: zsmalloc memory allocator and zram block device driver
+
 N: Danny ter Haar
 E: dth@cistron.nl
 D: /proc/cpuinfo, reboot on panic , kernel pre-patch tester ;)
--- a/MAINTAINERS~maintainers-zram-zsmalloc-add-an-additional-co-maintainer
+++ a/MAINTAINERS
@@ -23002,8 +23002,7 @@ F:	drivers/media/pci/zoran/
 
 ZRAM COMPRESSED RAM BLOCK DEVICE DRVIER
 M:	Minchan Kim <minchan@kernel.org>
-M:	Nitin Gupta <ngupta@vflare.org>
-R:	Sergey Senozhatsky <senozhatsky@chromium.org>
+M:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/admin-guide/blockdev/zram.rst
@@ -23016,8 +23015,7 @@ F:	drivers/tty/serial/zs.*
 
 ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
 M:	Minchan Kim <minchan@kernel.org>
-M:	Nitin Gupta <ngupta@vflare.org>
-R:	Sergey Senozhatsky <senozhatsky@chromium.org>
+M:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/zsmalloc.rst
_

Patches currently in -mm which might be from minchan@kernel.org are

maintainers-zram-zsmalloc-add-an-additional-co-maintainer.patch

