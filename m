From: akpm@linux-foundation.org
Subject: + checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch added to -mm tree
Date: Wed, 30 Nov 2011 14:19:56 -0800
Message-ID: <201111302219.pAUMJvSo001420@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54481 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1K3WUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 17:20:00 -0500
Received: by mail-ee0-f74.google.com with SMTP id u44so18732eeu.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 14:19:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com, rostedt@goodmis.org


The patch titled
     Subject: checkpatch: only apply kconfig help checks for options which prompt
has been added to the -mm tree.  Its filename is
     checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch

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
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: only apply kconfig help checks for options which prompt

The intent of this check is to catch the options which the user will see
and ensure they are properly described.  It is also common for internal
only options to have a brief description.  Allow this form.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt
+++ a/scripts/checkpatch.pl
@@ -1674,19 +1674,26 @@ sub process {
 # Only applies when adding the entry originally, after that we do not have
 # sufficient context to determine whether it is indeed long enough.
 		if ($realfile =~ /Kconfig/ &&
-		    $line =~ /\+\s*(?:---)?help(?:---)?$/) {
+		    $line =~ /.\s*config\s+/) {
 			my $length = 0;
 			my $cnt = $realcnt;
 			my $ln = $linenr + 1;
 			my $f;
+			my $is_start = 0;
 			my $is_end = 0;
-			while ($cnt > 0 && defined $lines[$ln - 1]) {
+			for (; $cnt > 0 && defined $lines[$ln - 1]; $ln++) {
 				$f = $lines[$ln - 1];
 				$cnt-- if ($lines[$ln - 1] !~ /^-/);
 				$is_end = $lines[$ln - 1] =~ /^\+/;
-				$ln++;
 
 				next if ($f =~ /^-/);
+
+				if ($lines[$ln - 1] =~ /.\s*(?:bool|tristate)\s*\"/) {
+					$is_start = 1;
+				} elsif ($lines[$ln - 1] =~ /.\s*(?:---)?help(?:---)?$/) {
+					$length = -1;
+				}
+
 				$f =~ s/^.//;
 				$f =~ s/#.*//;
 				$f =~ s/^\s+//;
@@ -1698,8 +1705,8 @@ sub process {
 				$length++;
 			}
 			WARN("CONFIG_DESCRIPTION",
-			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_end && $length < 4);
-			#print "is_end<$is_end> length<$length>\n";
+			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);
+			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
 		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
_
Subject: Subject: checkpatch: only apply kconfig help checks for options which prompt

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch
checkpatch-check-for-common-memset-parameter-issues-against-statments.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-is-not-a-valid-modifier.patch
checkpatch-optimise-statement-scanner-when-mid-statement.patch
checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch
checkpatch-fix-export_symbol-handling-following-a-function.patch
checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch
checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch
checkpatch-fix-complex-macros-handling-of-square-brackets.patch
checkpatch-ensure-cast-type-is-unique-in-the-context-parser.patch
checkpatch-typeof-may-have-more-complex-arguments.patch

