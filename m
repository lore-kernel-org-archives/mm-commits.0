Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB9FC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 00:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiBAAyr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 19:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiBAAyr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 19:54:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55183C061714
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 16:54:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2204BB82CCC
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 00:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0F5C340E8;
        Tue,  1 Feb 2022 00:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643676883;
        bh=IIlTY8pNMEA+eXMo+27InYpFH90Y8iVdfCUK9dtvE94=;
        h=Date:To:From:Subject:From;
        b=AwaMUNRVyBhNCHI3aMwgY/fl4lJV5b2n6U3AFetyd53nDH9mTjijGFYIiLG+wdX6m
         kfOMXsMZYZ+2sHsp5Di/RikhSLeO+rhNySyjs8ZzN8ppNTYr5o48kW8Xyqx9tlSMpp
         hag7hErORuhTKfdzB3TQ+ySAiIsGMMaOoIelx+0w=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 16:54:42 -0800
Date:   Mon, 31 Jan 2022 16:54:42 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        dwaipayanray1@gmail.com, joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-fix-option-for-some-trailing_statements.patch added to -mm tree
Message-Id: <20220201005442.BB0F5C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --fix option for some TRAILING_STATEMENTS
has been added to the -mm tree.  Its filename is
     checkpatch-add-fix-option-for-some-trailing_statements.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-fix-option-for-some-trailing_statements.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-fix-option-for-some-trailing_statements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --fix option for some TRAILING_STATEMENTS

Single line code like:

	if (foo) bar;

should generally be written:

	if (foo)
		bar;

Add a --fix test to do so.

This fix is not done when an ASSIGN_IN_IF in the same line exists.

Link: https://lkml.kernel.org/r/20220128185924.80137-2-joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-fix-option-for-some-trailing_statements
+++ a/scripts/checkpatch.pl
@@ -5551,6 +5551,7 @@ sub process {
 		    defined($stat) && defined($cond) &&
 		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
+			my $fixed_assign_in_if = 0;
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
 				if (ERROR("ASSIGN_IN_IF",
@@ -5575,6 +5576,7 @@ sub process {
 						$newline .= ')';
 						$newline .= " {" if (defined($brace));
 						fix_insert_line($fixlinenr + 1, $newline);
+						$fixed_assign_in_if = 1;
 					}
 				}
 			}
@@ -5598,8 +5600,20 @@ sub process {
 					$stat_real = "[...]\n$stat_real";
 				}
 
-				ERROR("TRAILING_STATEMENTS",
-				      "trailing statements should be on next line\n" . $herecurr . $stat_real);
+				if (ERROR("TRAILING_STATEMENTS",
+					  "trailing statements should be on next line\n" . $herecurr . $stat_real) &&
+				    !$fixed_assign_in_if &&
+				    $cond_lines == 0 &&
+				    $fix && $perl_version_ok &&
+				    $fixed[$fixlinenr] =~ /^\+(\s*)((?:if|while|for)\s*$balanced_parens)\s*(.*)$/) {
+					my $indent = $1;
+					my $test = $2;
+					my $rest = rtrim($4);
+					if ($rest =~ /;$/) {
+						$fixed[$fixlinenr] = "\+$indent$test";
+						fix_insert_line($fixlinenr + 1, "$indent\t$rest");
+					}
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-fix-option-for-some-trailing_statements.patch

