Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42ABEC77B7E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjFAWPq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjFAWPl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:15:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5405E5A
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:15:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65115649F2
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2F8C433EF;
        Thu,  1 Jun 2023 22:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685657713;
        bh=qj7xUjTUZxcogyD7/u/f0ukEzg+HTvYhgoXZuh2Fx2E=;
        h=Date:To:From:Subject:From;
        b=G5ubJ9CKgy0142FNVk2S0pkoHM8EXJEJUhYML9WDueA8i+zlxAuPAE/4ICBgKkolU
         D5a4ILLND3nyfnuzw2UJ0YI1fKdBQ9iYOwOcUfS81EcoQxA3pmjSPGM6Xs38wSWZwI
         07ALOaPed+WASfmntU1ZdP0/FsHHEq+X3BY3z2PE=
Date:   Thu, 01 Jun 2023 15:15:13 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, gustavoars@kernel.org, dwaipayanray1@gmail.com,
        apw@canonical.com, keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-check-for-0-length-and-1-element-arrays.patch added to mm-nonmm-unstable branch
Message-Id: <20230601221513.BD2F8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check for 0-length and 1-element arrays
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-check-for-0-length-and-1-element-arrays.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-check-for-0-length-and-1-element-arrays.patch

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
From: Kees Cook <keescook@chromium.org>
Subject: checkpatch: check for 0-length and 1-element arrays
Date: Thu, 1 Jun 2023 09:07:46 -0700

Fake flexible arrays have been deprecated since last millennium.  Proper
C99 flexible arrays must be used throughout the kernel so
CONFIG_FORTIFY_SOURCE and CONFIG_UBSAN_BOUNDS can provide proper array
bounds checking.

[joe@perches.com: handle __packed for srtucts]
Link: https://lkml.kernel.org/r/20230601160746.up.948-kees@kernel.org
Link: https://lore.kernel.org/r/20230517204530.never.151-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-check-for-0-length-and-1-element-arrays
+++ a/scripts/checkpatch.pl
@@ -7418,6 +7418,16 @@ sub process {
 			}
 		}
 
+# check for array definition/declarations that should use flexible arrays instead
+		if ($sline =~ /^[\+ ]\s*\}(?:\s*__packed)?\s*;\s*$/ &&
+		    $prevline =~ /^\+\s*(?:\}(?:\s*__packed\s*)?|$Type)\s*$Ident\s*\[\s*(0|1)\s*\]\s*;\s*$/) {
+			if (ERROR("FLEXIBLE_ARRAY",
+				  "Use C99 flexible arrays - see https://docs.kernel.org/process/deprecated.html#zero-length-and-one-element-arrays\n" . $hereprev) &&
+			    $1 == '0' && $fix) {
+				$fixed[$fixlinenr - 1] =~ s/\[\s*0\s*\]/[]/;
+			}
+		}
+
 # nested likely/unlikely calls
 		if ($line =~ /\b(?:(?:un)?likely)\s*\(\s*!?\s*(IS_ERR(?:_OR_NULL|_VALUE)?|WARN)/) {
 			WARN("LIKELY_MISUSE",
_

Patches currently in -mm which might be from keescook@chromium.org are

checkpatch-check-for-0-length-and-1-element-arrays.patch

