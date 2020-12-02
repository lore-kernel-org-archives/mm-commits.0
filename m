Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E1CC6369E
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 22:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7940B22203
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 22:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgLBW5w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 17:57:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgLBW5v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 17:57:51 -0500
Date:   Wed, 02 Dec 2020 14:57:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606949831;
        bh=BneV0sUTRwEEhGk9pGxzhcQTof6Lyg9AcsNlnJ0/uPg=;
        h=From:To:Subject:From;
        b=aEFFJr1i1MsDlHxFk2chFlC4VzPk03uKEQFGxifAV2vt8gvLodKyXtbYwHaheHAjt
         wb08quiBXKAPtRmgGaOb/x+GyERlNFwfXspOK7wGPSxxKHrR5G6Ff5LML7FNa6zMFh
         W5GXHfEdfQnEdIsHEGQukM51iPYuwALwLeK2LFm8=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org, yepeilin.cs@gmail.com
Subject:  +
 checkpatch-add-warning-for-lines-starting-with-a-in-commit-log.patch added
 to -mm tree
Message-ID: <20201202225710.2D-VBuZbS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add warning for lines starting with a '#' in commit log
has been added to the -mm tree.  Its filename is
     checkpatch-add-warning-for-lines-starting-with-a-in-commit-log.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-warning-for-lines-starting-with-a-in-commit-log.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-warning-for-lines-starting-with-a-in-commit-log.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: add warning for lines starting with a '#' in commit log

Commit log lines starting with '#' are dropped by git as comments.
Add a check to emit a warning for these lines.

Also add a --fix option to insert a space before the leading '#' in
such lines.

Link: https://lkml.kernel.org/r/20201202205740.127986-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Peilin Ye <yepeilin.cs@gmail.com>
Tested-by: Peilin Ye <yepeilin.cs@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-lines-starting-with-a-in-commit-log
+++ a/scripts/checkpatch.pl
@@ -3033,6 +3033,15 @@ sub process {
 			$commit_log_possible_stack_dump = 0;
 		}
 
+# Check for lines starting with a #
+		if ($in_commit_log && $line =~ /^#/) {
+			if (WARN("COMMIT_COMMENT_SYMBOL",
+				 "Commit log lines starting with '#' are dropped by git as comments\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/^/ /;
+			}
+		}
+
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log && !$commit_log_possible_stack_dump &&
 		    $line !~ /^\s*(?:Link|Patchwork|http|https|BugLink|base-commit):/i &&
_

Patches currently in -mm which might be from dwaipayanray1@gmail.com are

checkpatch-add-new-exception-to-repeated-word-check.patch
checkpatch-extend-attributes-check-to-handle-more-patterns.patch
checkpatch-improve-email-parsing.patch
checkpatch-fix-spelling-errors-and-remove-repeated-word.patch
checkpatch-fix-unescaped-left-brace.patch
checkpatch-add-warning-for-unnecessary-use-of-%h-and-%hh.patch
checkpatch-add-warning-for-lines-starting-with-a-in-commit-log.patch

