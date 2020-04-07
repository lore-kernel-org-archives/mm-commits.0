From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 131/166] checkpatch: fix minor typo and mixed
 space+tab in indentation
Date: Mon, 06 Apr 2020 20:11:01 -0700
Message-ID: <20200407031101.5BsF-FTbR%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgDGDLC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:02 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, borneo.antonio@gmail.com, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Antonio Borneo <borneo.antonio@gmail.com>
Subject: checkpatch: fix minor typo and mixed space+tab in indentation

Fix spelling of "concatenation".
Don't use tab after space in indentation.

Link: http://lkml.kernel.org/r/20200122163852.124417-2-borneo.antonio@gmail.com
Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-minor-typo-and-mixed-spacetab-in-indentation
+++ a/scripts/checkpatch.pl
@@ -4615,7 +4615,7 @@ sub process {
 					    ($op eq '>' &&
 					     $ca =~ /<\S+\@\S+$/))
 					{
-					    	$ok = 1;
+						$ok = 1;
 					}
 
 					# for asm volatile statements
@@ -4950,7 +4950,7 @@ sub process {
 			# conditional.
 			substr($s, 0, length($c), '');
 			$s =~ s/\n.*//g;
-			$s =~ s/$;//g; 	# Remove any comments
+			$s =~ s/$;//g;	# Remove any comments
 			if (length($c) && $s !~ /^\s*{?\s*\\*\s*$/ &&
 			    $c !~ /}\s*while\s*/)
 			{
@@ -4989,7 +4989,7 @@ sub process {
 # if and else should not have general statements after it
 		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/) {
 			my $s = $1;
-			$s =~ s/$;//g; 	# Remove any comments
+			$s =~ s/$;//g;	# Remove any comments
 			if ($s !~ /^\s*(?:\sif|(?:{|)\s*\\?\s*$)/) {
 				ERROR("TRAILING_STATEMENTS",
 				      "trailing statements should be on next line\n" . $herecurr);
@@ -5165,7 +5165,7 @@ sub process {
 			{
 			}
 
-			# Flatten any obvious string concatentation.
+			# Flatten any obvious string concatenation.
 			while ($dstat =~ s/($String)\s*$Ident/$1/ ||
 			       $dstat =~ s/$Ident\s*($String)/$1/)
 			{
_
