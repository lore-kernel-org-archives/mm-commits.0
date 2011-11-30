From: akpm@linux-foundation.org
Subject: + checkpatch-optimise-statement-scanner-when-mid-statement.patch added to -mm tree
Date: Wed, 30 Nov 2011 14:19:54 -0800
Message-ID: <201111302219.pAUMJsUX006178@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:48967 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1K3WT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 17:19:58 -0500
Received: by faaq16 with SMTP id q16so41795faa.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 14:19:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: optimise statement scanner when mid-statement
has been added to the -mm tree.  Its filename is
     checkpatch-optimise-statement-scanner-when-mid-statement.patch

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
Subject: checkpatch: optimise statement scanner when mid-statement

In the middle of a long definition or similar, there is no possibility of
finding a smaller sub-statement.  Optimise this case by skipping statement
aquirey where there are no starts of statement (open brace '{' or
semi-colon ';').  We are likely to scan slightly more than needed still
but this is safest.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-optimise-statement-scanner-when-mid-statement scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-optimise-statement-scanner-when-mid-statement
+++ a/scripts/checkpatch.pl
@@ -1373,6 +1373,7 @@ sub process {
 	my %suppress_ifbraces;
 	my %suppress_whiletrailers;
 	my %suppress_export;
+	my $suppress_statement = 0;
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -1482,6 +1483,7 @@ sub process {
 			%suppress_ifbraces = ();
 			%suppress_whiletrailers = ();
 			%suppress_export = ();
+			$suppress_statement = 0;
 			next;
 
 # track the line number as we move through the hunk, note that
@@ -1809,13 +1811,23 @@ sub process {
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);
-		if ($realcnt && $line =~ /.\s*\S/) {
+#print "LINE<$line>\n";
+		if ($linenr >= $suppress_statement &&
+		    $realcnt && $line =~ /.\s*\S/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
 			$cond =~ s/\n./\n /g;
 
-#print "stat<$stat>\n";
+#print "linenr<$linenr> <$stat>\n";
+			# If this statement has no statement boundaries within
+			# it there is no point in retrying a statement scan
+			# until we hit end of it.
+			my $frag = $stat; $frag =~ s/;+\s*$//;
+			if ($frag !~ /(?:{|;)/) {
+#print "skip<$line_nr_next>\n";
+				$suppress_statement = $line_nr_next;
+			}
 
 			# Find the real next line.
 			$realline_next = $line_nr_next;
@@ -1942,6 +1954,9 @@ sub process {
 
 # Check relative indent for conditionals and blocks.
 		if ($line =~ /\b(?:(?:if|while|for)\s*\(|do\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
+			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
+				ctx_statement_block($linenr, $realcnt, 0)
+					if (!defined $stat);
 			my ($s, $c) = ($stat, $cond);
 
 			substr($s, 0, length($c), '');
@@ -2620,6 +2635,9 @@ sub process {
 # Check for illegal assignment in if conditional -- and check for trailing
 # statements after the conditional.
 		if ($line =~ /do\s*(?!{)/) {
+			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
+				ctx_statement_block($linenr, $realcnt, 0)
+					if (!defined $stat);
 			my ($stat_next) = ctx_statement_block($line_nr_next,
 						$remain_next, $off_next);
 			$stat_next =~ s/\n./\n /g;
_
Subject: Subject: checkpatch: optimise statement scanner when mid-statement

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

