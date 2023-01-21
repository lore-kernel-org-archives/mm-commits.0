Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB19C27C76
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjAUBUb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjAUBUa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:20:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A4C7DF98
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:20:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C269B8261B
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5190C4339B;
        Sat, 21 Jan 2023 01:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674264024;
        bh=86WqtBjUl8p8LtbFHM7nvjR6CniAj5LyNC3BoulA1xg=;
        h=Date:To:From:Subject:From;
        b=gTGxRsL8VqeSGDJuIr8M403R4bCaMqSVHqZ09ol7yl5rgeMznhEkFZj1Z10s8X2ww
         1WNvhD5zXFIvgPWyUR6S7PAb3zSxbNl3rbwf9NfbsYy0GaqzwF41ZBd46uZ0M2UaTz
         CZehWgb0WTk62L4MpKLZAIO/Ska99jINtrAQUq3o=
Date:   Fri, 20 Jan 2023 17:20:24 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        linux@leemhuis.info, joe@perches.com, dwaipayanray1@gmail.com,
        apw@canonical.com, kai@dev.carbon-project.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-warn-when-unknown-tags-are-used-for-links.patch added to mm-nonmm-unstable branch
Message-Id: <20230121012024.D5190C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn when unknown tags are used for links
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-warn-when-unknown-tags-are-used-for-links.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-warn-when-unknown-tags-are-used-for-links.patch

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
From: Kai Wasserbäch <kai@dev.carbon-project.org>
Subject: checkpatch: warn when unknown tags are used for links
Date: Fri, 20 Jan 2023 13:35:18 +0100

Patch series "checkpatch.pl: warn about discouraged tags and missing Link:
tags", v4.

The first two changes make checkpatch.pl check for a few mistakes wrt to
links to bug reports Linus recently complained about a few times. 
Avoiding those is also important for my regression tracking efforts a lot,
as the automated tracking performed by regzbot relies on the proper usage
of the Link: tag.

The third patch fixes a few small oddities noticed in existing code during
review of the two changes.


This patch (of 3):

Issue a warning when encountering URLs behind unknown tags, as Linus
recently stated ```please stop making up random tags that make no sense. 
Just use "Link:"```[1].  That statement was triggered by an use of
'BugLink', but that's not the only tag people invented:

$ git log -100000 --no-merges --format=email -P \
   --grep='^\w+:[ 	]*http' | grep -Poh '^\w+:[ 	]*http' | \
  sort | uniq -c | sort -rn | head -n 20
 103958 Link: http
    418 BugLink: http
    372 Patchwork: http
    280 Closes: http
    224 Bug: http
    123 References: http
     84 Bugzilla: http
     61 URL: http
     42 v1: http
     38 Datasheet: http
     20 v2: http
      9 Ref: http
      9 Fixes: http
      9 Buglink: http
      8 v3: http
      8 Reference: http
      7 See: http
      6 1: http
      5 link: http
      3 Link:http

Some of these non-standard tags make it harder for external tools that
rely on use of proper tags.  One of those tools is the regression tracking
bot 'regzbot', which looks out for "Link:" tags pointing to reports of
tracked regressions.

The initial idea was to use a disallow list to raise an error when
encountering known unwanted tags like BugLink:; during review it was
requested to use a list of allowed tags instead[2].

Link: https://lkml.kernel.org/r/cover.1674217480.git.linux@leemhuis.info
Link: https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/ [1]
Link: https://lore.kernel.org/all/15f7df96d49082fb7799dda6e187b33c84f38831.camel@perches.com/ [2]
Link: https://lkml.kernel.org/r/3b036087d80b8c0e07a46a1dbaaf4ad0d018f8d5.1674217480.git.linux@leemhuis.info
Signed-off-by: Kai Wasserbäch <kai@dev.carbon-project.org>
Co-developed-by: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/checkpatch.pl~checkpatch-warn-when-unknown-tags-are-used-for-links
+++ a/scripts/checkpatch.pl
@@ -3252,6 +3252,18 @@ sub process {
 			$commit_log_possible_stack_dump = 0;
 		}
 
+# Check for odd tags before a URI/URL
+		if ($in_commit_log &&
+		    $line =~ /^\s*(\w+):\s*http/ && $1 ne 'Link') {
+			if ($1 =~ /^v(?:ersion)?\d+/i) {
+				WARN("COMMIT_LOG_VERSIONING",
+				     "Patch version information should be after the --- line\n" . $herecurr);
+			} else {
+				WARN("COMMIT_LOG_USE_LINK",
+				     "Unknown link reference '$1:', use 'Link:' instead\n" . $herecurr);
+			}
+		}
+
 # Check for lines starting with a #
 		if ($in_commit_log && $line =~ /^#/) {
 			if (WARN("COMMIT_COMMENT_SYMBOL",
_

Patches currently in -mm which might be from kai@dev.carbon-project.org are

checkpatch-warn-when-unknown-tags-are-used-for-links.patch
checkpatch-warn-when-reported-by-is-not-followed-by-link.patch

