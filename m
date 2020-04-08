From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-fix-minor-typo-and-mixed-spacetab-in-indentation.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 19:01:34 -0700
Message-ID: <20200408020134.WOkM4svmW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgDHCBg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borneo.antonio@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix minor typo and mixed space+tab in indentation
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-minor-typo-and-mixed-spacetab-in-indentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from borneo.antonio@gmail.com are
