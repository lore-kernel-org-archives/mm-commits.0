From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-ability-to-fix-coalesce-string-fragments-on-multiple-lines.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:46 -0800
Message-ID: <5489eb0a.dq3nm36AQNFGhY3W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbaLKTFr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add ability to --fix (coalesce) string fragments on multiple lines
has been removed from the -mm tree.  Its filename was
     checkpatch-add-ability-to-fix-coalesce-string-fragments-on-multiple-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add ability to --fix (coalesce) string fragments on multiple lines

Add --fix option to coalesce string fragments.

This does not coalesce string fragments that have newline terminations or
are otherwise exempted.

Other miscellanea:

o move all the string tests together.
o fix get_quoted_string function for tab characters
o fix concatination typo

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  115 ++++++++++++++++++++++++----------------
 1 file changed, 69 insertions(+), 46 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-ability-to-fix-coalesce-string-fragments-on-multiple-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-ability-to-fix-coalesce-string-fragments-on-multiple-lines
+++ a/scripts/checkpatch.pl
@@ -946,7 +946,7 @@ sub sanitise_line {
 sub get_quoted_string {
 	my ($line, $rawline) = @_;
 
-	return "" if ($line !~ m/(\"[X]+\")/g);
+	return "" if ($line !~ m/(\"[X\t]+\")/g);
 	return substr($rawline, $-[0], $+[0] - $-[0]);
 }
 
@@ -1847,6 +1847,7 @@ sub process {
 	my $non_utf8_charset = 0;
 
 	my $last_blank_line = 0;
+	my $last_coalesced_string_linenr = -1;
 
 	our @report = ();
 	our $cnt_lines = 0;
@@ -2413,33 +2414,6 @@ sub process {
 			     "line over $max_line_length characters\n" . $herecurr);
 		}
 
-# Check for user-visible strings broken across lines, which breaks the ability
-# to grep for the string.  Make exceptions when the previous string ends in a
-# newline (multiple lines in one string constant) or '\t', '\r', ';', or '{'
-# (common in inline assembly) or is a octal \123 or hexadecimal \xaf value
-		if ($line =~ /^\+\s*"/ &&
-		    $prevline =~ /"\s*$/ &&
-		    $prevrawline !~ /(?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$/) {
-			WARN("SPLIT_STRING",
-			     "quoted string split across lines\n" . $hereprev);
-		}
-
-# check for missing a space in a string concatination
-		if ($prevrawline =~ /[^\\]\w"$/ && $rawline =~ /^\+[\t ]+"\w/) {
-			WARN('MISSING_SPACE',
-			     "break quoted strings at a space character\n" . $hereprev);
-		}
-
-# check for spaces before a quoted newline
-		if ($rawline =~ /^.*\".*\s\\n/) {
-			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
-				 "unnecessary whitespace before a quoted newline\n" . $herecurr) &&
-			    $fix) {
-				$fixed[$fixlinenr] =~ s/^(\+.*\".*)\s+\\n/$1\\n/;
-			}
-
-		}
-
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
 			WARN("MISSING_EOF_NEWLINE",
@@ -4458,6 +4432,55 @@ sub process {
 			     "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
 		}
 
+# Check for user-visible strings broken across lines, which breaks the ability
+# to grep for the string.  Make exceptions when the previous string ends in a
+# newline (multiple lines in one string constant) or '\t', '\r', ';', or '{'
+# (common in inline assembly) or is a octal \123 or hexadecimal \xaf value
+		if ($line =~ /^\+\s*"[X\t]*"/ &&
+		    $prevline =~ /"\s*$/ &&
+		    $prevrawline !~ /(?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$/) {
+			if (WARN("SPLIT_STRING",
+				 "quoted string split across lines\n" . $hereprev) &&
+				     $fix &&
+				     $prevrawline =~ /^\+.*"\s*$/ &&
+				     $last_coalesced_string_linenr != $linenr - 1) {
+				my $extracted_string = get_quoted_string($line, $rawline);
+				my $comma_close = "";
+				if ($rawline =~ /\Q$extracted_string\E(\s*\)\s*;\s*$|\s*,\s*)/) {
+					$comma_close = $1;
+				}
+
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+				fix_delete_line($fixlinenr, $rawline);
+				my $fixedline = $prevrawline;
+				$fixedline =~ s/"\s*$//;
+				$fixedline .= substr($extracted_string, 1) . trim($comma_close);
+				fix_insert_line($fixlinenr - 1, $fixedline);
+				$fixedline = $rawline;
+				$fixedline =~ s/\Q$extracted_string\E\Q$comma_close\E//;
+				if ($fixedline !~ /\+\s*$/) {
+					fix_insert_line($fixlinenr, $fixedline);
+				}
+				$last_coalesced_string_linenr = $linenr;
+			}
+		}
+
+# check for missing a space in a string concatenation
+		if ($prevrawline =~ /[^\\]\w"$/ && $rawline =~ /^\+[\t ]+"\w/) {
+			WARN('MISSING_SPACE',
+			     "break quoted strings at a space character\n" . $hereprev);
+		}
+
+# check for spaces before a quoted newline
+		if ($rawline =~ /^.*\".*\s\\n/) {
+			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
+				 "unnecessary whitespace before a quoted newline\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/^(\+.*\".*)\s+\\n/$1\\n/;
+			}
+
+		}
+
 # concatenated string without spaces between elements
 		if ($line =~ /"X+"[A-Z_]+/ || $line =~ /[A-Z_]+"X+"/) {
 			CHK("CONCATENATED_STRING",
@@ -4470,6 +4493,24 @@ sub process {
 			     "Consecutive strings are generally better as a single string\n" . $herecurr);
 		}
 
+# check for %L{u,d,i} in strings
+		my $string;
+		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
+			$string = substr($rawline, $-[1], $+[1] - $-[1]);
+			$string =~ s/%%/__/g;
+			if ($string =~ /(?<!%)%L[udi]/) {
+				WARN("PRINTF_L",
+				     "\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
+				last;
+			}
+		}
+
+# check for line continuations in quoted strings with odd counts of "
+		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
+			WARN("LINE_CONTINUATIONS",
+			     "Avoid line continuations in quoted strings\n" . $herecurr);
+		}
+
 # warn about #if 0
 		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
 			CHK("REDUNDANT_CODE",
@@ -4754,12 +4795,6 @@ sub process {
 			}
 		}
 
-# check for line continuations in quoted strings with odd counts of "
-		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
-			WARN("LINE_CONTINUATIONS",
-			     "Avoid line continuations in quoted strings\n" . $herecurr);
-		}
-
 # check for struct spinlock declarations
 		if ($line =~ /^.\s*\bstruct\s+spinlock\s+\w+\s*;/) {
 			WARN("USE_SPINLOCK_T",
@@ -5169,18 +5204,6 @@ sub process {
 			      "#define of '$1' is wrong - use Kconfig variables or standard guards instead\n" . $herecurr);
 		}
 
-# check for %L{u,d,i} in strings
-		my $string;
-		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
-			$string = substr($rawline, $-[1], $+[1] - $-[1]);
-			$string =~ s/%%/__/g;
-			if ($string =~ /(?<!%)%L[udi]/) {
-				WARN("PRINTF_L",
-				     "\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
-				last;
-			}
-		}
