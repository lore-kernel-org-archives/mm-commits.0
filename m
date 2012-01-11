From: akpm@linux-foundation.org
Subject: [merged] checkpatch-optimise-statement-scanner-when-mid-statement.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:15 -0800
Message-ID: <20120111213115.989E810004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33196 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051Ab2AKVbQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:16 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so137318ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: optimise statement scanner when mid-statement
has been removed from the -mm tree.  Its filename was
     checkpatch-optimise-statement-scanner-when-mid-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

