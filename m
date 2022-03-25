Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99C0C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357497AbiCYBhF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357501AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDD033E08
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC4EA60A75
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB26C340EC;
        Fri, 25 Mar 2022 01:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172033;
        bh=LdtcGG10HORZtYTfrklhdLl0jwkF/PXwYqczmG0NHMU=;
        h=Date:To:From:Subject:From;
        b=jTckl2dchLV2/pwghg7l9/3bqg8SBMxZuSybnIRmGtroegxqOz28i4VJSL0XQc+kI
         2bClNPYfCnm0xlDpq/30x2wqC7XmtjZ1xGpf9I8DEzlVC5FtNkOs3YZ09UL3CvT9gd
         g/UZausvgk1DXRxCUhrjttzgrRmQW3ihfTNCVxac=
Date:   Thu, 24 Mar 2022 18:33:52 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        dwaipayanray1@gmail.com, joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] checkpatch-add-fix-option-for-some-trailing_statements.patch removed from -mm tree
Message-Id: <20220325013353.2AB26C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --fix option for some TRAILING_STATEMENTS
has been removed from the -mm tree.  Its filename was
     checkpatch-add-fix-option-for-some-trailing_statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


