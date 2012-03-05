From: akpm@linux-foundation.org
Subject: + checkpatch-add-strict-tests-for-braces-comments-and-casts.patch added to -mm tree
Date: Mon, 05 Mar 2012 12:21:40 -0800
Message-ID: <20120305202141.6AC59A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:55127 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab2CEUVn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Mar 2012 15:21:43 -0500
Received: by vcbfk26 with SMTP id fk26so528487vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Mar 2012 12:21:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@shadowen.org


The patch titled
     Subject: checkpatch: add --strict tests for braces, comments and casts
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-tests-for-braces-comments-and-casts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: checkpatch: add --strict tests for braces, comments and casts

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatch-add-some-strict-coding-style-checks-v3.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch
checkpatch-add-strict-tests-for-braces-comments-and-casts.patch
checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch

