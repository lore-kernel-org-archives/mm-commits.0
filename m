Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3080AC77B6C
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 23:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjDFXS3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 19:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjDFXS2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 19:18:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B092F9EE1
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 16:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34F2B649F3
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 23:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E77C433D2;
        Thu,  6 Apr 2023 23:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680823106;
        bh=xOWmIlomIfUameBADcI7T+VSI/LpXCXL1iPqSqqlcUo=;
        h=Date:To:From:Subject:From;
        b=sDhXCfWx0ZBWOXO9islcfaoNT8DC3Tk1q5fhOHc3lnaYv7XmOxc0ui25ac6aR0HR5
         PFprD8H4bula4Hd5zz73dU3IfcXmKmoYcEYVPiI2E+9JLAMGS471ApB/Cea639gKKD
         YR0ZPgB0KlfoXIqYBB2syKoqK/tFeAlwsLnMcel0=
Date:   Thu, 06 Apr 2023 16:18:26 -0700
To:     mm-commits@vger.kernel.org, jan.kiszka@siemens.com,
        f.fainelli@gmail.com, aouledameur@baylibre.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-timerlist-convert-int-chunks-to-str.patch added to mm-nonmm-unstable branch
Message-Id: <20230406231826.86E77C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: timerlist: convert int chunks to str
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-timerlist-convert-int-chunks-to-str.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-timerlist-convert-int-chunks-to-str.patch

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
From: Amjad Ouled-Ameur <aouledameur@baylibre.com>
Subject: scripts/gdb: timerlist: convert int chunks to str
Date: Thu, 6 Apr 2023 15:12:17 -0700

join() expects strings but integers are given.

Convert chunks list to strings before passing it to join()

Link: https://lkml.kernel.org/r/20230406221217.1585486-4-f.fainelli@gmail.com
Signed-off-by: Amjad Ouled-Ameur <aouledameur@baylibre.com>
Signed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/timerlist.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/timerlist.py~scripts-gdb-timerlist-convert-int-chunks-to-str
+++ a/scripts/gdb/linux/timerlist.py
@@ -174,7 +174,7 @@ def pr_cpumask(mask):
     if 0 < extra <= 4:
         chunks[0] = chunks[0][0]  # Cut off the first 0
 
-    return "".join(chunks)
+    return "".join(str(chunks))
 
 
 class LxTimerList(gdb.Command):
_

Patches currently in -mm which might be from aouledameur@baylibre.com are

scripts-gdb-timerlist-convert-int-chunks-to-str.patch

