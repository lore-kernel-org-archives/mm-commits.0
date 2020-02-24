From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 checkpatch-fix-minor-typo-and-mixed-spacetab-in-indentation.patch added to
 -mm tree
Date: Mon, 24 Feb 2020 15:39:59 -0800
Message-ID: <20200224233959.pD1KAmeLE%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728341AbgBXXkA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 18:40:00 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borneo.antonio@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix minor typo and mixed space+tab in indentation
has been added to the -mm tree.  Its filename is
     checkpatch-fix-minor-typo-and-mixed-spacetab-in-indentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-minor-typo-and-mixed-spacetab-in-indentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-minor-typo-and-mixed-spacetab-in-indentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4629,7 +4629,7 @@ sub process {
 					    ($op eq '>' &&
 					     $ca =~ /<\S+\@\S+$/))
 					{
-					    	$ok = 1;
+						$ok = 1;
 					}
 
 					# for asm volatile statements
@@ -4964,7 +4964,7 @@ sub process {
 			# conditional.
 			substr($s, 0, length($c), '');
 			$s =~ s/\n.*//g;
-			$s =~ s/$;//g; 	# Remove any comments
+			$s =~ s/$;//g;	# Remove any comments
 			if (length($c) && $s !~ /^\s*{?\s*\\*\s*$/ &&
 			    $c !~ /}\s*while\s*/)
 			{
@@ -5003,7 +5003,7 @@ sub process {
 # if and else should not have general statements after it
 		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/) {
 			my $s = $1;
-			$s =~ s/$;//g; 	# Remove any comments
+			$s =~ s/$;//g;	# Remove any comments
 			if ($s !~ /^\s*(?:\sif|(?:{|)\s*\\?\s*$)/) {
 				ERROR("TRAILING_STATEMENTS",
 				      "trailing statements should be on next line\n" . $herecurr);
@@ -5179,7 +5179,7 @@ sub process {
 			{
 			}
 
-			# Flatten any obvious string concatentation.
+			# Flatten any obvious string concatenation.
 			while ($dstat =~ s/($String)\s*$Ident/$1/ ||
 			       $dstat =~ s/$Ident\s*($String)/$1/)
 			{
_

Patches currently in -mm which might be from borneo.antonio@gmail.com are

checkpatch-fix-minor-typo-and-mixed-spacetab-in-indentation.patch
checkpatch-fix-multiple-const-types.patch
checkpatch-add-command-line-option-for-tab-size.patch
