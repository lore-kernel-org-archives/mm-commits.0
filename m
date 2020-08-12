Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19124C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9095206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196114;
	bh=INbGWtERZKeHobCEI4Xc7n26e677S2Gx8dXkZdqii24=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=g/+S+joVenD9vgMdV4pjhsqyVPa5NTaja1wrnNgjuaspJqITzYdB04vxOdmRFdWxQ
	 llHn+ZCIGVrATSo1YOQhqTJJUE9R6vIhb01cC+GlPJG94Sun8aUDQxTIPn8E2MPimm
	 FVJPCftDKeQJVaDBhM8b1WOpu3PHj3tS6ZjbBa4c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgHLBfO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbgHLBfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 719C8206B2;
        Wed, 12 Aug 2020 01:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196113;
        bh=INbGWtERZKeHobCEI4Xc7n26e677S2Gx8dXkZdqii24=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Yuc6XR73yhqdX39h7z/kul2LPjMq7s8WWgd+euufo5mqRL9rQXoFoUtcUmv8qLaqL
         RcfBe/Gi1wWkktKbt76Y+Ov+dJeB5nTuFrYRNSGeEh/Ts7oZyiUkcJ/bEMIXchRpdA
         Mw0FGwy10IWdp66OTLGdAMnFQxKqiWHD5fzA9yZo=
Date:   Tue, 11 Aug 2020 18:35:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, quentin@isovalent.com,
        torvalds@linux-foundation.org
Subject:  [patch 094/165] checkpatch: fix CONST_STRUCT when
 const_structs.checkpatch is missing
Message-ID: <20200812013513.w9IivYYmQ%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Quentin Monnet <quentin@isovalent.com>
Subject: checkpatch: fix CONST_STRUCT when const_structs.checkpatch is missing

Checkpatch reports warnings when some specific structs are not declared as
const in the code.  The list of structs to consider was initially defined
in the checkpatch.pl script itself, but it was later moved to an external
file (scripts/const_structs.checkpatch), in commit bf1fa1dae68e
("checkpatch: externalize the structs that should be const").  This
introduced two minor issues:

- When file scripts/const_structs.checkpatch is not present (for
  example, if checkpatch is run outside of the kernel directory with the
  "--no-tree" option), a warning is printed to stderr to tell the user
  that "No structs that should be const will be found". This is fair,
  but the warning is printed unconditionally, even if the option
  "--ignore CONST_STRUCT" is passed. In the latter case, we explicitly
  ask checkpatch to skip this check, so no warning should be printed.

- When scripts/const_structs.checkpatch is missing, or even when trying
  to silence the warning by adding an empty file, $const_structs is set
  to "", and the regex used for finding structs that should be const,
  "$line =~ /struct\s+($const_structs)(?!\s*\{)/)", matches all
  structs found in the code, thus reporting a number of false positives.

Let's fix the first item by skipping scripts/const_structs.checkpatch
processing if "CONST_STRUCT" checks are ignored, and the second one by
skipping the test if $const_structs is not defined. Since we modify the
read_words() function a little bit, update the checks for
$typedefsfile/$typeOtherTypedefs as well.

Link: http://lkml.kernel.org/r/20200623221822.3727-1-quentin@isovalent.com
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-const_struct-when-const_structscheckpatch-is-missing
+++ a/scripts/checkpatch.pl
@@ -59,7 +59,7 @@ my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
 my $codespellfile = "/usr/share/codespell/dictionary.txt";
 my $conststructsfile = "$D/const_structs.checkpatch";
-my $typedefsfile = "";
+my $typedefsfile;
 my $color = "auto";
 my $allow_c99_comments = 1; # Can be overridden by --ignore C99_COMMENT_TOLERANCE
 # git output parsing needs US English output, so first set backtick child process LANGUAGE
@@ -756,7 +756,7 @@ sub read_words {
 				next;
 			}
 
-			$$wordsRef .= '|' if ($$wordsRef ne "");
+			$$wordsRef .= '|' if (defined $$wordsRef);
 			$$wordsRef .= $line;
 		}
 		close($file);
@@ -766,16 +766,18 @@ sub read_words {
 	return 0;
 }
 
-my $const_structs = "";
-read_words(\$const_structs, $conststructsfile)
-    or warn "No structs that should be const will be found - file '$conststructsfile': $!\n";
+my $const_structs;
+if (show_type("CONST_STRUCT")) {
+	read_words(\$const_structs, $conststructsfile)
+	    or warn "No structs that should be const will be found - file '$conststructsfile': $!\n";
+}
 
-my $typeOtherTypedefs = "";
-if (length($typedefsfile)) {
+if (defined($typedefsfile)) {
+	my $typeOtherTypedefs;
 	read_words(\$typeOtherTypedefs, $typedefsfile)
 	    or warn "No additional types will be considered - file '$typedefsfile': $!\n";
+	$typeTypedefs .= '|' . $typeOtherTypedefs if (defined $typeOtherTypedefs);
 }
-$typeTypedefs .= '|' . $typeOtherTypedefs if ($typeOtherTypedefs ne "");
 
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", (@modifierList, @modifierListFile)) . "\n)";
@@ -6643,7 +6645,8 @@ sub process {
 
 # check for various structs that are normally const (ops, kgdb, device_tree)
 # and avoid what seem like struct definitions 'struct foo {'
-		if ($line !~ /\bconst\b/ &&
+		if (defined($const_structs) &&
+		    $line !~ /\bconst\b/ &&
 		    $line =~ /\bstruct\s+($const_structs)\b(?!\s*\{)/) {
 			WARN("CONST_STRUCT",
 			     "struct $1 should normally be const\n" . $herecurr);
_
