Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0902C38141
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjAUBUf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjAUBUe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:20:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3943A7B2EA
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:20:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9475620E8
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BEEC433D2;
        Sat, 21 Jan 2023 01:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674264028;
        bh=EAhVXHkgprfwll+BymPpmeL958W0RYhDO6+CMTVnI3A=;
        h=Date:To:From:Subject:From;
        b=AICVdby0zj5KVI2mfwlCS3aTFXR8Kt5DbIs93FLSA/JwYruPN85DzW2ssgExItG54
         hteYhzhgba8jyLAwX40CyN6Moy4DPgDMuY1BiOxCinTlRtn+jJtsqu1s1xYNYnDPLA
         ZSUGG5ONj4cX4C7lov1B8yRuoOmwTUM/5Y3VBn9s=
Date:   Fri, 20 Jan 2023 17:20:27 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        kai@dev.carbon-project.org, joe@perches.com,
        dwaipayanray1@gmail.com, apw@canonical.com, linux@leemhuis.info,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-use-proper-way-for-show-problematic-line.patch added to mm-nonmm-unstable branch
Message-Id: <20230121012028.29BEEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: use proper way for show problematic line
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-use-proper-way-for-show-problematic-line.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-use-proper-way-for-show-problematic-line.patch

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
From: Thorsten Leemhuis <linux@leemhuis.info>
Subject: checkpatch: use proper way for show problematic line
Date: Fri, 20 Jan 2023 13:35:20 +0100

Instead of using an unnecessarily complicated approach to print a line
that is warned about, use `$herecurr` instead, just like everywhere else
in checkpatch.

While at it, remove a superfluous space in one of the changed lines, too. 
In a unmodified line also remove a superfluous check for a space before a
signed-off-by tag, to me consistent with the check at the start of the
section.

All three problems were found by Joe Perches during review of new code
inspired by the code modified here.

Link: https://lkml.kernel.org/r/a6d455c5196219b2095c2ac3645498052845f32e.1674217480.git.linux@leemhuis.info
Signed-off-by: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kai Wasserbäch <kai@dev.carbon-project.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/checkpatch.pl~checkpatch-use-proper-way-for-show-problematic-line
+++ a/scripts/checkpatch.pl
@@ -3144,17 +3144,17 @@ sub process {
 			if ($sign_off =~ /^co-developed-by:$/i) {
 				if ($email eq $author) {
 					WARN("BAD_SIGN_OFF",
-					      "Co-developed-by: should not be used to attribute nominal patch author '$author'\n" . "$here\n" . $rawline);
+					      "Co-developed-by: should not be used to attribute nominal patch author '$author'\n" . $herecurr);
 				}
 				if (!defined $lines[$linenr]) {
 					WARN("BAD_SIGN_OFF",
-					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . "$here\n" . $rawline);
-				} elsif ($rawlines[$linenr] !~ /^\s*signed-off-by:\s*(.*)/i) {
+					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . $herecurr);
+				} elsif ($rawlines[$linenr] !~ /^signed-off-by:\s*(.*)/i) {
 					WARN("BAD_SIGN_OFF",
-					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . "$here\n" . $rawline . "\n" .$rawlines[$linenr]);
+					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . $herecurr . $rawlines[$linenr] . "\n");
 				} elsif ($1 ne $email) {
 					WARN("BAD_SIGN_OFF",
-					     "Co-developed-by and Signed-off-by: name/email do not match \n" . "$here\n" . $rawline . "\n" .$rawlines[$linenr]);
+					     "Co-developed-by and Signed-off-by: name/email do not match\n" . $herecurr . $rawlines[$linenr] . "\n");
 				}
 			}
 
_

Patches currently in -mm which might be from linux@leemhuis.info are

checkpatch-use-proper-way-for-show-problematic-line.patch

