Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67429C6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 18:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIUSUN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 14:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiIUSUM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 14:20:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913F97FF81
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 11:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25E81B83262
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 18:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF65C433C1;
        Wed, 21 Sep 2022 18:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663784406;
        bh=RoMB/34/lt8cMrKMa1pqtnl6IhV9Rlw+WJ1zY1Xr0D4=;
        h=Date:To:From:Subject:From;
        b=PYsXTSgosk5UL0ZfN/7h4E5gPVFTDqJbwuIXzLvyBm1NvPtBFI2yUOfC3qG4kae1S
         dggE/C9yk+R6QikuMuYc4lBGfB/tLimejafr6OuMq5ULFAjpdrL6oWZ+3k4ix2GupK
         CdCUUpXGlXy8mFD7lv8Y0ngM/NLcsYof5aEJYSIg=
Date:   Wed, 21 Sep 2022 11:20:05 -0700
To:     mm-commits@vger.kernel.org, simon.horman@corigine.com,
        philippe.schenker@toradex.com, lukas.bulwahn@gmail.com,
        louis.peens@corigine.com, joe@perches.com, dwaipayanray1@gmail.com,
        niklas.soderlund@corigine.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-warn-for-non-standard-fixes-tag-style.patch added to mm-nonmm-unstable branch
Message-Id: <20220921182006.ABF65C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn for non-standard fixes tag style
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-warn-for-non-standard-fixes-tag-style.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-warn-for-non-standard-fixes-tag-style.patch

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
From: Niklas Söderlund <niklas.soderlund@corigine.com>
Subject: checkpatch: warn for non-standard fixes tag style
Date: Wed, 14 Sep 2022 12:02:55 +0200

Add a warning for fixes tags that does not follow community conventions.

Link: https://lkml.kernel.org/r/20220914100255.1048460-1-niklas.soderlund@corigine.com
Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Reviewed-by: Philippe Schenker <philippe.schenker@toradex.com>
Acked-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Reviewed-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/dev-tools/checkpatch.rst~checkpatch-warn-for-non-standard-fixes-tag-style
+++ a/Documentation/dev-tools/checkpatch.rst
@@ -612,6 +612,13 @@ Commit message
 
     See: https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes
 
+  **BAD_FIXES_TAG**
+    The Fixes: tag is malformed or does not follow the community conventions.
+    This can occur if the tag have been split into multiple lines (e.g., when
+    pasted in an email program with word wrapping enabled).
+
+    See: https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes
+
 
 Comparison style
 ----------------
--- a/scripts/checkpatch.pl~checkpatch-warn-for-non-standard-fixes-tag-style
+++ a/scripts/checkpatch.pl
@@ -3146,6 +3146,50 @@ sub process {
 			}
 		}
 
+# Check Fixes: styles is correct
+		if (!$in_header_lines &&
+		    $line =~ /^\s*fixes:?\s*(?:commit\s*)?[0-9a-f]{5,}\b/i) {
+			my $orig_commit = "";
+			my $id = "0123456789ab";
+			my $title = "commit title";
+			my $tag_case = 1;
+			my $tag_space = 1;
+			my $id_length = 1;
+			my $id_case = 1;
+			my $title_has_quotes = 0;
+
+			if ($line =~ /(\s*fixes:?)\s+([0-9a-f]{5,})\s+($balanced_parens)/i) {
+				my $tag = $1;
+				$orig_commit = $2;
+				$title = $3;
+
+				$tag_case = 0 if $tag eq "Fixes:";
+				$tag_space = 0 if ($line =~ /^fixes:? [0-9a-f]{5,} ($balanced_parens)/i);
+
+				$id_length = 0 if ($orig_commit =~ /^[0-9a-f]{12}$/i);
+				$id_case = 0 if ($orig_commit !~ /[A-F]/);
+
+				# Always strip leading/trailing parens then double quotes if existing
+				$title = substr($title, 1, -1);
+				if ($title =~ /^".*"$/) {
+					$title = substr($title, 1, -1);
+					$title_has_quotes = 1;
+				}
+			}
+
+			my ($cid, $ctitle) = git_commit_info($orig_commit, $id,
+							     $title);
+
+			if ($ctitle ne $title || $tag_case || $tag_space ||
+			    $id_length || $id_case || !$title_has_quotes) {
+				if (WARN("BAD_FIXES_TAG",
+				     "Please use correct Fixes: style 'Fixes: <12 chars of sha1> (\"<title line>\")' - ie: 'Fixes: $cid (\"$ctitle\")'\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] = "Fixes: $cid (\"$ctitle\")";
+				}
+			}
+		}
+
 # Check email subject for common tools that don't need to be mentioned
 		if ($in_header_lines &&
 		    $line =~ /^Subject:.*\b(?:checkpatch|sparse|smatch)\b[^:]/i) {
_

Patches currently in -mm which might be from niklas.soderlund@corigine.com are

checkpatch-warn-for-non-standard-fixes-tag-style.patch

