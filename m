From: akpm@linux-foundation.org
Subject: - checkpatch-handle-do-without-braces-if-we-have-enough-context.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:00 -0700
Message-ID: <200810182314.m9INE0o9028303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbYJRXOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: handle do without braces if we have enough context
has been removed from the -mm tree.  Its filename was
     checkpatch-handle-do-without-braces-if-we-have-enough-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

