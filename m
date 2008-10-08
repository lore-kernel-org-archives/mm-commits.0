From: akpm@linux-foundation.org
Subject: + checkpatch-handle-do-without-braces-if-we-have-enough-context.patch added to -mm tree
Date: Wed, 08 Oct 2008 15:23:39 -0700
Message-ID: <200810082223.m98MNdpg013605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbYJHWXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Oct 2008 18:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: handle do without braces if we have enough context
has been added to the -mm tree.  Its filename is
     checkpatch-handle-do-without-braces-if-we-have-enough-context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: handle do without braces if we have enough context
From: Andy Whitcroft <apw@shadowen.org>

If we have sufficient context detect and handle do without braces ({). 
Else these incorrectly trigger a trailing statements error for the
associated while.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-handle-do-without-braces-if-we-have-enough-context scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-handle-do-without-braces-if-we-have-enough-context
+++ a/scripts/checkpatch.pl
@@ -1051,6 +1051,7 @@ sub process {
 
 	# suppression flags
 	my %suppress_ifbraces;
+	my %suppress_whiletrailers;
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -1156,6 +1157,7 @@ sub process {
 			$prev_values = 'E';
 
 			%suppress_ifbraces = ();
+			%suppress_whiletrailers = ();
 			next;
 
 # track the line number as we move through the hunk, note that
@@ -1301,9 +1303,9 @@ sub process {
 		}
 
 # Check for potential 'bare' types
-		my ($stat, $cond, $line_nr_next, $remain_next);
+		my ($stat, $cond, $line_nr_next, $remain_next, $off_next);
 		if ($realcnt && $line =~ /.\s*\S/) {
-			($stat, $cond, $line_nr_next, $remain_next) =
+			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
 			$cond =~ s/\n./\n /g;
@@ -1952,7 +1954,26 @@ sub process {
 
 # Check for illegal assignment in if conditional -- and check for trailing
 # statements after the conditional.
-		if ($line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
+		if ($line =~ /do\s*(?!{)/) {
+			my ($stat_next) = ctx_statement_block($line_nr_next,
+						$remain_next, $off_next);
+			$stat_next =~ s/\n./\n /g;
+			##print "stat<$stat> stat_next<$stat_next>\n";
+
+			if ($stat_next =~ /^\s*while\b/) {
+				# If the statement carries leading newlines,
+				# then count those as offsets.
+				my ($whitespace) =
+					($stat_next =~ /^((?:\s*\n[+-])*\s*)/s);
+				my $offset =
+					statement_rawlines($whitespace) - 1;
+
+				$suppress_whiletrailers{$line_nr_next +
+								$offset} = 1;
+			}
+		}
+		if (!defined $suppress_whiletrailers{$linenr} &&
+		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/) {
_

Patches currently in -mm which might be from apw@shadowen.org are

mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch
checkpatch-values-double-ampersand-may-be-unary.patch
checkpatch-conditional-indent-labels-have-different-indent-rules.patch
checkpatch-switch-indent-allow-plain-return.patch
checkpatch-add-tests-for-the-attribute-matcher.patch
checkpatch-____cacheline_aligned-et-al-are-modifiers.patch
checkpatch-complex-macros-fix-up-extension-handling.patch
checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block.patch
checkpatch-include-asm-checks-should-be-anchored.patch
checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc.patch
checkpatch-report-any-absolute-references-to-kernel-source-files.patch
checkpatch-report-the-real-first-line-of-all-suspect-indents.patch
checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch
checkpatch-%lx-tests-should-hand-%%-as-a-literal.patch
checkpatch-report-the-correct-lines-for-single-statement-blocks.patch
checkpatch-perform-indent-checks-on-perl.patch
checkpatch-version-022.patch
checkpatch-case-default-checks-should-only-check-changed-lines.patch
checkpatch-suppress-errors-triggered-by-short-patch.patch
checkpatch-handle-comment-quote-nesting-correctly.patch
checkpatch-check-line-endings-in-text-format-files.patch
checkpatch-suspect-indent-count-condition-lines-correctly.patch
checkpatch-ensure-we-only-apply-checks-to-the-lines-within-hunks.patch
checkpatch-version-023.patch
checkpatch-do-is-not-a-possible-type.patch
checkpatch-labels-are-not-possible-types.patch
checkpatch-handle-do-without-braces-if-we-have-enough-context.patch
checkpatch-macros-which-define-structure-members-are-not-complex.patch
checkpatch-accept-any-sized-le-be-type.patch
checkpatch-pull-out-known-acceptable-typedefs.patch
checkpatch-suspect-code-indent-must-stop-at-else-elif.patch
checkpatch-complex-macros-checks-miss-square-brackets.patch
checkpatch-define_-macros-are-real-definitions-for-exports.patch
checkpatch-trailing-statements-ensure-we-report-the-end-of-the-line.patch
checkpatch-suspect-indent-handle-macro-continuation.patch
checkpatch-allow-for-comments-either-side-of-a-brace-on-case.patch
checkpatch-version-024.patch
page-owner-tracking-leak-detector.patch

