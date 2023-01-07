Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B236C5479D
	for <mm-commits@archiver.kernel.org>; Sat,  7 Jan 2023 01:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjAGBAS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 20:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236974AbjAGA7o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 19:59:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D927FEF0
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 16:59:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FA9561FA7
        for <mm-commits@vger.kernel.org>; Sat,  7 Jan 2023 00:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A5BC433EF;
        Sat,  7 Jan 2023 00:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673053182;
        bh=eY1K3Opd6g2eVCnc66RsgWmJph47WpxAu2BvOfFNSxY=;
        h=Date:To:From:Subject:From;
        b=SbQenqP71b2Szlx7pp4tGGws4BMLXB7b54Wm53hMPKciy9j/WCWjxUZHGvuYZthFq
         xG0b84XpwMjXPFFVdNB3fFraolgJnVwWNaVfrXiLpSgaD1d1pnXcPI94O/RlUFO4CD
         YEZu9KMa2haafBykMR3dup4EIniOafafOWbwftJI=
Date:   Fri, 06 Jan 2023 16:59:41 -0800
To:     mm-commits@vger.kernel.org, paul.gortmaker@windriver.com,
        nborisov@suse.com, apantykhin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-bloat-o-meter-use-the-reverse-flag-for-sort.patch added to mm-nonmm-unstable branch
Message-Id: <20230107005942.61A5BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: use the reverse flag for sort
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-bloat-o-meter-use-the-reverse-flag-for-sort.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-bloat-o-meter-use-the-reverse-flag-for-sort.patch

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
From: Alexander Pantyukhin <apantykhin@gmail.com>
Subject: scripts/bloat-o-meter: use the reverse flag for sort
Date: Fri, 6 Jan 2023 14:13:19 +0500

The sort function has the inbuilt reversal option.  We can use it to save
some time.

Link: https://lkml.kernel.org/r/20230106091319.3824-1-apantykhin@gmail.com
Signed-off-by: Alexander Pantyukhin <apantykhin@gmail.com>
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-use-the-reverse-flag-for-sort
+++ a/scripts/bloat-o-meter
@@ -80,8 +80,7 @@ def calc(oldfile, newfile, format):
         if d<0: shrink, down = shrink+1, down-d
         delta.append((d, name))
 
-    delta.sort()
-    delta.reverse()
+    delta.sort(reverse=True)
     return grow, shrink, add, remove, up, down, delta, old, new, otot, ntot
 
 def print_result(symboltype, symbolformat):
_

Patches currently in -mm which might be from apantykhin@gmail.com are

scripts-bloat-o-meter-use-the-reverse-flag-for-sort.patch

