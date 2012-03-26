From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-strict-tests-for-braces-comments-and-casts.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:28 -0700
Message-ID: <20120326193028.688C3A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:62516 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2CZTa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:29 -0400
Received: by qabg24 with SMTP id g24so336122qab.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict tests for braces, comments and casts
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-tests-for-braces-comments-and-casts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --strict tests for braces, comments and casts

Add some more subjective --strict tests.

Add a test for block comments that start with a blank line followed only
by a line with just the comment block initiator.  Prefer a blank line
followed by /* comment...

Add a test for unnecessary spaces after a cast.

Add a test for symmetric uses of braces in if/else blocks.
If one branch needs braces, then all branches should use braces.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-tests-for-braces-comments-and-casts scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-tests-for-braces-comments-and-casts
+++ a/scripts/checkpatch.pl
@@ -1849,6 +1849,17 @@ sub process {
 			}
 		}
 
+		if ($line =~ /^\+.*\*[ \t]*\)[ \t]+/) {
+			CHK("SPACING",
+			    "No space is necessary after a cast\n" . $hereprev);
+		}
+
+		if ($rawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
+		    $prevrawline =~ /^\+[ \t]*$/) {
+			CHK("BLOCK_COMMENT_STYLE",
+			    "Don't begin block comments with only a /* line, use /* comment...\n" . $hereprev);
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments
@@ -2961,7 +2972,8 @@ sub process {
 			#print "chunks<$#chunks> linenr<$linenr> endln<$endln> level<$level>\n";
 			#print "APW: <<$chunks[1][0]>><<$chunks[1][1]>>\n";
 			if ($#chunks > 0 && $level == 0) {
-				my $allowed = 0;
+				my @allowed = ();
+				my $allow = 0;
 				my $seen = 0;
 				my $herectx = $here . "\n";
 				my $ln = $linenr - 1;
@@ -2972,6 +2984,7 @@ sub process {
 					my ($whitespace) = ($cond =~ /^((?:\s*\n[+-])*\s*)/s);
 					my $offset = statement_rawlines($whitespace) - 1;
 
+					$allowed[$allow] = 0;
 					#print "COND<$cond> whitespace<$whitespace> offset<$offset>\n";
 
 					# We have looked at and allowed this specific line.
@@ -2984,23 +2997,34 @@ sub process {
 
 					$seen++ if ($block =~ /^\s*{/);
 
-					#print "cond<$cond> block<$block> allowed<$allowed>\n";
+					#print "cond<$cond> block<$block> allowed<$allowed[$allow]>\n";
 					if (statement_lines($cond) > 1) {
 						#print "APW: ALLOWED: cond<$cond>\n";
-						$allowed = 1;
+						$allowed[$allow] = 1;
 					}
 					if ($block =~/\b(?:if|for|while)\b/) {
 						#print "APW: ALLOWED: block<$block>\n";
-						$allowed = 1;
+						$allowed[$allow] = 1;
 					}
 					if (statement_block_size($block) > 1) {
 						#print "APW: ALLOWED: lines block<$block>\n";
-						$allowed = 1;
+						$allowed[$allow] = 1;
 					}
+					$allow++;
 				}
-				if ($seen && !$allowed) {
-					WARN("BRACES",
-					     "braces {} are not necessary for any arm of this statement\n" . $herectx);
+				if ($seen) {
+					my $sum_allowed = 0;
+					foreach (@allowed) {
+						$sum_allowed += $_;
+					}
+					if ($sum_allowed == 0) {
+						WARN("BRACES",
+						     "braces {} are not necessary for any arm of this statement\n" . $herectx);
+					} elsif ($sum_allowed != $allow &&
+						 $seen != $allow) {
+						CHK("BRACES",
+						    "braces {} should be used on all arms of this statement\n" . $herectx);
+					}
 				}
 			}
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fix-remoteproc-f-typo.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

