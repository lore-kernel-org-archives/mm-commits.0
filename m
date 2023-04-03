Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4F3C77B62
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 20:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbjDCUjI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 16:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbjDCUjG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 16:39:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E215E1
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 13:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD34D62AC5
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 20:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12723C433D2;
        Mon,  3 Apr 2023 20:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680554344;
        bh=E40kNsqBD0uRWOB0ANOZHoWWaWgkcm6ZnZZ/DHiFyzY=;
        h=Date:To:From:Subject:From;
        b=KeYmX9e6QagWG/RJ2spabp3nW12S0LxLl88iRibeafONxk3X1BJy+gpvEKuJr31M+
         pw0KT3JRs7cqn6IyZ4/bowBFEnn1Zi7qB5cSWoRcCcSuuLnavZztoNtXgaLBM8G3qF
         F5PiH00AjBXvHXWmT7ZV7Wq8KGldzmH3UtTMxaHk=
Date:   Mon, 03 Apr 2023 13:39:03 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        lukas.bulwahn@gmail.com, linux@leemhuis.info,
        konstantin@linuxfoundation.org, kai@dev.carbon-project.org,
        joe@perches.com, dwaipayanray1@gmail.com, daniel@ffwll.ch,
        corbet@lwn.net, bagasdotme@gmail.com, apw@canonical.com,
        airlied@gmail.com, matthieu.baerts@tessares.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-dont-print-the-next-line-if-not-defined.patch added to mm-nonmm-unstable branch
Message-Id: <20230403203904.12723C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't print the next line if not defined
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-dont-print-the-next-line-if-not-defined.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-dont-print-the-next-line-if-not-defined.patch

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
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: checkpatch: don't print the next line if not defined
Date: Mon, 03 Apr 2023 18:23:47 +0200

When checking if "Reported-by" tag is followed by "Link:", there is no
need to print the next line if there is no next line.

While at it, also mention in this case that the "Link:" tag should be
followed by a URL, similar to the next warning.

By doing that, the code is now similar to what is done above when checking
if the Co-developed-by tag is properly used.

Link: https://lkml.kernel.org/r/20230314-doc-checkpatch-closes-tag-v4-2-d26d1fa66f9f@tessares.net
Fixes: d7f1d71e5ef6 ("checkpatch: warn when Reported-by: is not followed by Link:")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kai Wasserbäch <kai@dev.carbon-project.org>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-dont-print-the-next-line-if-not-defined
+++ a/scripts/checkpatch.pl
@@ -3162,7 +3162,7 @@ sub process {
 			if ($sign_off =~ /^reported(?:|-and-tested)-by:$/i) {
 				if (!defined $lines[$linenr]) {
 					WARN("BAD_REPORTED_BY_LINK",
-					     "Reported-by: should be immediately followed by Link: to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
+					     "Reported-by: should be immediately followed by Link: with a URL to the report\n" . $herecurr . "\n");
 				} elsif ($rawlines[$linenr] !~ m{^link:\s*https?://}i) {
 					WARN("BAD_REPORTED_BY_LINK",
 					     "Reported-by: should be immediately followed by Link: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
_

Patches currently in -mm which might be from matthieu.baerts@tessares.net are

docs-process-allow-closes-tags-with-links.patch
checkpatch-dont-print-the-next-line-if-not-defined.patch
checkpatch-use-a-list-of-link-tags.patch
checkpatch-allow-closes-tags-with-links.patch
checkpatch-check-for-misuse-of-the-link-tags.patch

