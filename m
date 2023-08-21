Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DADFEE49AE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjHUUrc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjHUUrR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545DBCE
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9BF564B11
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3951EC433C7;
        Mon, 21 Aug 2023 20:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650834;
        bh=fdXuGr9wTOcQ1ZEC7WdcD7tRS1OezJKQlCyG1oaZnFg=;
        h=Date:To:From:Subject:From;
        b=rw23IXdTVfXwvGo5t85pOBVgkr70H+OudWmeJlqQoTOCDYxcOOUncloTV2zviHjqm
         Ywv7RRpSp8YsOp20wQDG4Hcz2YqpX+/nkmVPXtvtr3l0AzNbIEwwYQvfP5J8jdLZ0K
         Muov2N4hYBQrCb62jIRKea8qU76uxIScLCMNcZsI=
Date:   Mon, 21 Aug 2023 13:47:13 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de, geert+renesas@glider.be,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-bloat-o-meter-count-weak-symbol-sizes.patch removed from -mm tree
Message-Id: <20230821204714.3951EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/bloat-o-meter: count weak symbol sizes
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-count-weak-symbol-sizes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


