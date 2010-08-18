From: akpm@linux-foundation.org
Subject: + checkpatch-suggest-cleanpatch-and-cleanfile-when-appropriate.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:14 -0700
Message-ID: <201008182025.o7IKPE0w010322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab0HRUZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, bzolnier@gmail.com


The patch titled
     checkpatch: suggest cleanpatch and cleanfile when appropriate
has been added to the -mm tree.  Its filename is
     checkpatch-suggest-cleanpatch-and-cleanfile-when-appropriate.patch

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
Subject: checkpatch: suggest cleanpatch and cleanfile when appropriate
From: Andy Whitcroft <apw@canonical.com>

When we hit types of whitespace which may be fixed by scripts/cleanpatch
and scripts/cleanfile suggest their use in our report.

Suggested-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-suggest-cleanpatch-and-cleanfile-when-appropriate scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suggest-cleanpatch-and-cleanfile-when-appropriate
+++ a/scripts/checkpatch.pl
@@ -103,6 +103,8 @@ for my $key (keys %debug) {
 	die "$@" if ($@);
 }
 
+my $rpt_cleaners = 0;
+
 if ($terse) {
 	$emacs = 1;
 	$quiet++;
@@ -1389,6 +1391,7 @@ sub process {
 		} elsif ($rawline =~ /^\+.*\S\s+$/ || $rawline =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			ERROR("trailing whitespace\n" . $herevet);
+			$rpt_cleaners = 1;
 		}
 
 # check for Kconfig help text having a real description
@@ -1450,6 +1453,7 @@ sub process {
 		    $rawline =~ /^\+\s*        \s*/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			ERROR("code indent should use tabs where possible\n" . $herevet);
+			$rpt_cleaners = 1;
 		}
 
 # check for space before tabs.
@@ -2842,6 +2846,15 @@ sub process {
 		print "\n" if ($quiet == 0);
 	}
 
+	if ($quiet == 0) {
+		# If there were whitespace errors which cleanpatch can fix
+		# then suggest that.
+		if ($rpt_cleaners) {
+			print "NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or\n";
+			print "      scripts/cleanfile\n\n";
+		}
+	}
+
 	if ($clean == 1 && $quiet == 0) {
 		print "$vname has no obvious style problems and is ready for submission.\n"
 	}
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

