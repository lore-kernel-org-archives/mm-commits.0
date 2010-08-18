From: akpm@linux-foundation.org
Subject: + checkpatch-ensure-kconfig-help-checks-only-apply-when-we-are-adding-help.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:27 -0700
Message-ID: <201008182025.o7IKPSd6010348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145Ab0HRUbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: ensure kconfig help checks only apply when we are adding help
has been added to the -mm tree.  Its filename is
     checkpatch-ensure-kconfig-help-checks-only-apply-when-we-are-adding-help.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: ensure kconfig help checks only apply when we are adding help
From: Andy Whitcroft <apw@canonical.com>

When checking the length of the help we need to be sure we are seeing the
whole story before erroring.  Firstly we only want to check when adding
the help in the first place.  Second we need to be sure that we are seeing
the end of the entry, nominally when there is no context below or that
context shows the start of the next entry.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-ensure-kconfig-help-checks-only-apply-when-we-are-adding-help scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ensure-kconfig-help-checks-only-apply-when-we-are-adding-help
+++ a/scripts/checkpatch.pl
@@ -1400,18 +1400,34 @@ sub process {
 		}
 
 # check for Kconfig help text having a real description
+# Only applies when adding the entry originally, after that we do not have
+# sufficient context to determine whether it is indeed long enough.
 		if ($realfile =~ /Kconfig/ &&
-		    $line =~ /\+?\s*(---)?help(---)?$/) {
+		    $line =~ /\+\s*(?:---)?help(?:---)?$/) {
 			my $length = 0;
-			for (my $l = $linenr; defined($lines[$l]); $l++) {
-				my $f = $lines[$l];
+			my $cnt = $realcnt;
+			my $ln = $linenr + 1;
+			my $f;
+			my $is_end = 0;
+			while ($cnt > 0 && defined $lines[$ln - 1]) {
+				$f = $lines[$ln - 1];
+				$cnt-- if ($lines[$ln - 1] !~ /^-/);
+				$is_end = $lines[$ln - 1] =~ /^\+/;
+				$ln++;
+
+				next if ($f =~ /^-/);
+				$f =~ s/^.//;
 				$f =~ s/#.*//;
 				$f =~ s/^\s+//;
 				next if ($f =~ /^$/);
-				last if ($f =~ /^\s*config\s/);
+				if ($f =~ /^\s*config\s/) {
+					$is_end = 1;
+					last;
+				}
 				$length++;
 			}
-			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($length < 4);
+			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_end && $length < 4);
+			#print "is_end<$is_end> length<$length>\n";
 		}
 
 # check we are in a valid source file if not then ignore this hunk
_

Patches currently in -mm which might be from apw@canonical.com are

checkpatch-fix-regressions-in-fix-handling-of-leading-spaces.patch
checkpatch-types-may-sit-on-a-line-on-their-own.patch
checkpatch-suggest-cleanpatch-and-cleanfile-when-appropriate.patch
checkpatch-ensure-we-do-not-collapse-bracketed-sections-into-constants.patch
checkpatch-handle-casts-better-fixing-false-categorisation-of-as-binary.patch
checkpatch-returning-errno-typically-should-be-negative.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-simplify-and-consolidate-missing-space-after-checks.patch
checkpatch-ensure-kconfig-help-checks-only-apply-when-we-are-adding-help.patch
checkpatch-check-for-incorrect-permissions.patch
checkpatch-add-additional-attribute-defines.patch
checkpatch-update-copyright-dates.patch
checkpatch-clean-up-structure-definition-macro-handline.patch
checkpatch-handle-export_symbol-for-device_attr-and-similar.patch
checkpatch-statement-block-context-analyser-should-look-at-sanitised-lines.patch
checkpatch-version-031.patch

