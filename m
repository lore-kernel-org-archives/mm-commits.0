Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A127C433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B08264F1F
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhB0CdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhB0Ccn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 772A264F4F;
        Sat, 27 Feb 2021 02:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393134;
        bh=YuBb1TQyi7NWTaM+fKIuNIau0Cg/Wq6bHj9XyBmnuCE=;
        h=Date:From:To:Subject:From;
        b=aSks1+tcs+3z4X/eWe9t+m/qFcc7ZZ0fBAwM6aPGANLAlCTe+f7l779t+c1a/LmlT
         5hnABQxWaDFEMoY4taGxcpSd4OYTiXnTCccc7bEwh759GQwX9FPTcpper/NErjbbpw
         ace5dI/OtQ8Q135Xh55tkYt35ZqlmDxS9e5i8mOw=
Date:   Fri, 26 Feb 2021 18:32:14 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-improve-blank-line-after-declaration-test.patch removed from -mm
 tree
Message-ID: <20210227023214.NRNxZQs1Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve blank line after declaration test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-blank-line-after-declaration-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve blank line after declaration test

Avoid multiple false positives by ignoring attributes.

Various attributes like volatile and ____cacheline_aligned_in_smp cause
checkpatch to emit invalid "Missing a blank line after declarations"
messages.

Use copies of $sline and $prevline, remove $Attribute and $Sparse, and use
the existing tests to avoid these false positives.

Miscellanea:

o Add volatile to $Attribute

This also reduces checkpatch runtime a bit by moving the indentation
comparison test to the start of the block to avoid multiple unnecessary
regex tests.

Link: https://lkml.kernel.org/r/9015fd00742bf4e5b824ad6d7fd7189530958548.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   52 ++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-blank-line-after-declaration-test
+++ a/scripts/checkpatch.pl
@@ -382,6 +382,7 @@ our $InitAttribute = qr{$InitAttributeDa
 # We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
 our $Attribute	= qr{
 			const|
+			volatile|
 			__percpu|
 			__nocast|
 			__safe|
@@ -3776,43 +3777,48 @@ sub process {
 		}
 
 # check for missing blank lines after declarations
-		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
-			# actual declarations
-		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
+# (declarations must have the same indentation and not be at the start of line)
+		if (($prevline =~ /\+(\s+)\S/) && $sline =~ /^\+$1\S/) {
+			# use temporaries
+			my $sl = $sline;
+			my $pl = $prevline;
+			# remove $Attribute/$Sparse uses to simplify comparisons
+			$sl =~ s/\b(?:$Attribute|$Sparse)\b//g;
+			$pl =~ s/\b(?:$Attribute|$Sparse)\b//g;
+			if (($pl =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
 			# function pointer declarations
-		     $prevline =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
+			     $pl =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
 			# foo bar; where foo is some local typedef or #define
-		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
+			     $pl =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
-		     $prevline =~ /^\+\s+$declaration_macros/) &&
+			     $pl =~ /^\+\s+$declaration_macros/) &&
 			# for "else if" which can look like "$Ident $Ident"
-		    !($prevline =~ /^\+\s+$c90_Keywords\b/ ||
+			    !($pl =~ /^\+\s+$c90_Keywords\b/ ||
 			# other possible extensions of declaration lines
-		      $prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
+			      $pl =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
 			# not starting a section or a macro "\" extended line
-		      $prevline =~ /(?:\{\s*|\\)$/) &&
+			      $pl =~ /(?:\{\s*|\\)$/) &&
 			# looks like a declaration
-		    !($sline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
+			    !($sl =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
 			# function pointer declarations
-		      $sline =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
+			      $sl =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
 			# foo bar; where foo is some local typedef or #define
-		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
+			      $sl =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
-		      $sline =~ /^\+\s+$declaration_macros/ ||
+			      $sl =~ /^\+\s+$declaration_macros/ ||
 			# start of struct or union or enum
-		      $sline =~ /^\+\s+(?:static\s+)?(?:const\s+)?(?:union|struct|enum|typedef)\b/ ||
+			      $sl =~ /^\+\s+(?:static\s+)?(?:const\s+)?(?:union|struct|enum|typedef)\b/ ||
 			# start or end of block or continuation of declaration
-		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(\[])/ ||
+			      $sl =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(\[])/ ||
 			# bitfield continuation
-		      $sline =~ /^\+\s+$Ident\s*:\s*\d+\s*[,;]/ ||
+			      $sl =~ /^\+\s+$Ident\s*:\s*\d+\s*[,;]/ ||
 			# other possible extensions of declaration lines
-		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/) &&
-			# indentation of previous and current line are the same
-		    (($prevline =~ /\+(\s+)\S/) && $sline =~ /^\+$1\S/)) {
-			if (WARN("LINE_SPACING",
-				 "Missing a blank line after declarations\n" . $hereprev) &&
-			    $fix) {
-				fix_insert_line($fixlinenr, "\+");
+			      $sl =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
+				if (WARN("LINE_SPACING",
+					 "Missing a blank line after declarations\n" . $hereprev) &&
+				    $fix) {
+					fix_insert_line($fixlinenr, "\+");
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are


