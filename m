Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8EEC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjDRXmP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbjDRXlP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:41:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF0315450
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D2876023A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CFCC433D2;
        Tue, 18 Apr 2023 23:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861224;
        bh=NcIHYrB2Vw4pGwkO6TCkeZ7OUHcGPy5uK9Jsu8k4K9g=;
        h=Date:To:From:Subject:From;
        b=tBaJ/tv1xN4Upo7XZwejU4UfF+MORJREKn4021J36E0GCmcOGmWAizR/MKvSS/puO
         VWxXdMfaBqSj8/DZ7Lzxbq2yF8GA7vW66EuCxfhGEi3kIdiUrxjCKO1CQQKWgJ2UIk
         Gu/WP19vhgw2UnjBywvzJKaBiXy0/l22mJojEEAw=
Date:   Tue, 18 Apr 2023 16:40:24 -0700
To:     mm-commits@vger.kernel.org, jan.kiszka@siemens.com,
        f.fainelli@gmail.com, aouledameur@baylibre.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-timerlist-convert-int-chunks-to-str.patch removed from -mm tree
Message-Id: <20230418234024.96CFCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: timerlist: convert int chunks to str
has been removed from the -mm tree.  Its filename was
     scripts-gdb-timerlist-convert-int-chunks-to-str.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


