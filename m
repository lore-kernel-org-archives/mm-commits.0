Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD61EC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJCVa3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiJCV3y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F3857BD8
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90F17B81370
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42128C433D6;
        Mon,  3 Oct 2022 21:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832164;
        bh=NHu5FU1kpUIlJqiVWnUthcwOtwgCVKIHErNRAN6We+0=;
        h=Date:To:From:Subject:From;
        b=Vw5fFnSlXMSWzWU00ryZyeZxCbefpwMQrxrsS71oBnZDxLIbRcM1vQ8tYGVIJWTsl
         JajyZd9lE3n3Ymrw73d3zmJSIC85313TB5heEHudbvMbi2eYuAkRuOcI4d7ZxOgd7z
         LyfSVwRfSgBv56EC4/sAZkMFrFnPCcXo/UZB61IU=
Date:   Mon, 03 Oct 2022 14:22:43 -0700
To:     mm-commits@vger.kernel.org, simon.horman@corigine.com,
        philippe.schenker@toradex.com, lukas.bulwahn@gmail.com,
        louis.peens@corigine.com, joe@perches.com, dwaipayanray1@gmail.com,
        niklas.soderlund@corigine.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-warn-for-non-standard-fixes-tag-style.patch removed from -mm tree
Message-Id: <20221003212244.42128C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: warn for non-standard fixes tag style
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-for-non-standard-fixes-tag-style.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 Documentation/dev-tools/checkpatch.rst |    7 +++
 scripts/checkpatch.pl                  |   44 +++++++++++++++++++++++
 2 files changed, 51 insertions(+)

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


