Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F64C27C6D
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbjHPWj3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347004AbjHPWjB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:39:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEA82701
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CCEB662EE
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AA3C433C8;
        Wed, 16 Aug 2023 22:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692225539;
        bh=uR0v5DfDHmuja8ugq9OJtLHEBPBdDQ2E5L3bTL0MJm8=;
        h=Date:To:From:Subject:From;
        b=NTtFpOq1jNMyU1MK+HHcoWB2GJTu0dMXw761AlqXTNQQQD77v1TVGPQcSHo0sTbNt
         ls6i6kFyiky6p2NSjECNJyDOo3ImwmKMIecxreeZsbTioscOC1PtsdB/sP0YKFUPQT
         /Pu8QTVDIBk7jl1/kxAJc8udH46WlUSCMJxlgprs=
Date:   Wed, 16 Aug 2023 15:38:58 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de, geert+renesas@glider.be,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-bloat-o-meter-count-weak-symbol-sizes.patch added to mm-nonmm-unstable branch
Message-Id: <20230816223858.F1AA3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: count weak symbol sizes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-bloat-o-meter-count-weak-symbol-sizes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-bloat-o-meter-count-weak-symbol-sizes.patch

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
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: scripts/bloat-o-meter: count weak symbol sizes
Date: Wed, 16 Aug 2023 17:33:34 +0200

Currently, bloat-o-meter does not take into account weak symbols, and
thus ignores any size changes in code or data marked __weak.

Fix this by handling weak code ("w"/"W") and data ("v"/"V").

Link: https://lkml.kernel.org/r/a1e7abd2571c3bbfe75345d6ee98b276d2d5c39d.1692200010.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-count-weak-symbol-sizes
+++ a/scripts/bloat-o-meter
@@ -100,12 +100,12 @@ def print_result(symboltype, symbolforma
     print("Total: Before=%d, After=%d, chg %+.2f%%" % (otot, ntot, percent))
 
 if args.c:
-    print_result("Function", "tT")
-    print_result("Data", "dDbB")
+    print_result("Function", "tTwW")
+    print_result("Data", "dDbBvV")
     print_result("RO Data", "rR")
 elif args.d:
-    print_result("Data", "dDbBrR")
+    print_result("Data", "dDbBrRvV")
 elif args.t:
-    print_result("Function", "tT")
+    print_result("Function", "tTwW")
 else:
-    print_result("Function", "tTdDbBrR")
+    print_result("Function", "tTdDbBrRvVwW")
_

Patches currently in -mm which might be from geert+renesas@glider.be are

scripts-bloat-o-meter-count-weak-symbol-sizes.patch

