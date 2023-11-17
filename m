Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D48BC197A0
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 17:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbjKQRdv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 12:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjKQRdu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 12:33:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D0290
        for <mm-commits@vger.kernel.org>; Fri, 17 Nov 2023 09:33:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D6CC433C8;
        Fri, 17 Nov 2023 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700242426;
        bh=Zn0M0GN3ju9YX9NGk53C6/OwyzxfXjD5f6locgZDa3E=;
        h=Date:To:From:Subject:From;
        b=TI2y3Sut9le7Fuduc4g4dLPnJIhhdC+ZjG2Y707PMAkDvrgnffhwdmY8sInFxH1mC
         0XfBuPZZ/VMwjyRh9gxNNUgAvb2ROjkC07bwM6jjpE0j/6BNe8JKx4QqJKb21WeLdd
         8cGNBSI6yxBYIVYTyIjdOV3j0yo92XV7xVwecpdU=
Date:   Fri, 17 Nov 2023 09:33:46 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, dwaipayanray1@gmail.com, apw@canonical.com,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-do-not-require-an-empty-line-before-error-injection.patch added to mm-nonmm-unstable branch
Message-Id: <20231117173346.A6D6CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: do not require an empty line before error injection
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-do-not-require-an-empty-line-before-error-injection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-do-not-require-an-empty-line-before-error-injection.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: checkpatch: do not require an empty line before error injection
Date: Thu, 9 Nov 2023 16:51:38 +0900

ALLOW_ERROR_INJECTION macro (just like EXPORT_SYMBOL) can immediately
follow a function it annotates.

Link: https://lkml.kernel.org/r/20231109075147.2779461-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com> (maintainer:CHECKPATCH)
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com> (reviewer:CHECKPATCH)
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-do-not-require-an-empty-line-before-error-injection
+++ a/scripts/checkpatch.pl
@@ -4054,7 +4054,7 @@ sub process {
 		if ($prevline =~ /^[\+ ]};?\s*$/ &&
 		    $line =~ /^\+/ &&
 		    !($line =~ /^\+\s*$/ ||
-		      $line =~ /^\+\s*(?:EXPORT_SYMBOL|early_param)/ ||
+		      $line =~ /^\+\s*(?:EXPORT_SYMBOL|early_param|ALLOW_ERROR_INJECTION)/ ||
 		      $line =~ /^\+\s*MODULE_/i ||
 		      $line =~ /^\+\s*\#\s*(?:end|elif|else)/ ||
 		      $line =~ /^\+[a-z_]*init/ ||
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-split-memory-tracking-and-ac-time-tracking.patch
zram-tweak-writeback-config-help.patch
checkpatch-do-not-require-an-empty-line-before-error-injection.patch

