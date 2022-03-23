Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292ABC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345385AbiCWXHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345382AbiCWXHd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA1D90275
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81758B8214D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F83C340E8;
        Wed, 23 Mar 2022 23:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076760;
        bh=ysZmpeV/l5YwaM09UBum8uJ1PSGLUG1fw3LtofnMG0Q=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Heo9WJzmYRZU8Fl8osl1Le0zjL5pLhXIfBIrXmpsv+gMvU135CR7F/VApOidV7ijl
         Q6qrd6NcYzgY06+aSLYgcg1bWVdk8ikmuedrVbKenroe9g+O4FVfQL/xQ7lgB0T1c0
         TteDEK1yzP7To7GdhFqveWI6l0B580Wq6CpLdCTI=
Date:   Wed, 23 Mar 2022 16:05:59 -0700
To:     lukas.bulwahn@gmail.com, dwaipayanray1@gmail.com, joe@perches.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 14/41] checkpatch: add --fix option for some TRAILING_STATEMENTS
Message-Id: <20220323230600.40F83C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
