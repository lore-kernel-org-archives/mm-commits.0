From: akpm@linux-foundation.org
Subject: [merged] checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:59 -0800
Message-ID: <20120111213059.A5FC41E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33196 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab2AKVbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:00 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so137318ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: correctly track the end of preprocessor commands in context
has been removed from the -mm tree.  Its filename was
     checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: correctly track the end of preprocessor commands in context

When looking for a statement we currently run on through preprocessor
commands.  This means that a header file with just definitions is parsed
over and over again combining all of the lines from the current line to
the end of file leading to severe performance issues.

Fix up context accumulation to track preprocessor commands and stop when
reaching the end of them.  At the same time vastly simplify the #define
handling.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   90 +++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 51 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context
+++ a/scripts/checkpatch.pl
@@ -676,6 +676,10 @@ sub ctx_statement_block {
 			if ($off >= $len) {
 				last;
 			}
+			if ($level == 0 && substr($blk, $off) =~ /^.\s*#\s*define/) {
+				$level++;
+				$type = '#';
+			}
 		}
 		$p = $c;
 		$c = substr($blk, $off, 1);
@@ -738,6 +742,13 @@ sub ctx_statement_block {
 				last;
 			}
 		}
+		# Preprocessor commands end at the newline unless escaped.
+		if ($type eq '#' && $c eq "\n" && $p ne "\\") {
+			$level--;
+			$type = '';
+			$off++;
+			last;
+		}
 		$off++;
 	}
 	# We are truly at the end, so shuffle to the next line.
@@ -1801,6 +1812,8 @@ sub process {
 			$stat =~ s/\n./\n /g;
 			$cond =~ s/\n./\n /g;
 
+#print "stat<$stat>\n";
+
 			# Find the real next line.
 			$realline_next = $line_nr_next;
 			if (defined $realline_next &&
@@ -2781,47 +2794,13 @@ sub process {
 			my $cnt = $realcnt;
 			my ($off, $dstat, $dcond, $rest);
 			my $ctx = '';
-
-			my $args = defined($1);
-
-			# Find the end of the macro and limit our statement
-			# search to that.
-			while ($cnt > 0 && defined $lines[$ln - 1] &&
-				$lines[$ln - 1] =~ /^(?:-|..*\\$)/)
-			{
-				$ctx .= $rawlines[$ln - 1] . "\n";
-				$cnt-- if ($lines[$ln - 1] !~ /^-/);
-				$ln++;
-			}
-			$ctx .= $rawlines[$ln - 1];
-
 			($dstat, $dcond, $ln, $cnt, $off) =
-				ctx_statement_block($linenr, $ln - $linenr + 1, 0);
+				ctx_statement_block($linenr, $realcnt, 0);
+			$ctx = $dstat;
 			#print "dstat<$dstat> dcond<$dcond> cnt<$cnt> off<$off>\n";
 			#print "LINE<$lines[$ln-1]> len<" . length($lines[$ln-1]) . "\n";
 
-			# Extract the remainder of the define (if any) and
-			# rip off surrounding spaces, and trailing \'s.
-			$rest = '';
-			while ($off != 0 || ($cnt > 0 && $rest =~ /\\\s*$/)) {
-				#print "ADDING cnt<$cnt> $off <" . substr($lines[$ln - 1], $off) . "> rest<$rest>\n";
-				if ($off != 0 || $lines[$ln - 1] !~ /^-/) {
-					$rest .= substr($lines[$ln - 1], $off) . "\n";
-					$cnt--;
-				}
-				$ln++;
-				$off = 0;
-			}
-			$rest =~ s/\\\n.//g;
-			$rest =~ s/^\s*//s;
-			$rest =~ s/\s*$//s;
-
-			# Clean up the original statement.
-			if ($args) {
-				substr($dstat, 0, length($dcond), '');
-			} else {
-				$dstat =~ s/^.\s*\#\s*define\s+$Ident\s*//;
-			}
+			$dstat =~ s/^.\s*\#\s*define\s+$Ident(?:\([^\)]*\))?\s*//;
 			$dstat =~ s/$;//g;
 			$dstat =~ s/\\\n.//g;
 			$dstat =~ s/^\s*//s;
@@ -2847,23 +2826,32 @@ sub process {
 				^\"|\"$
 			}x;
 			#print "REST<$rest> dstat<$dstat> ctx<$ctx>\n";
-			if ($rest ne '' && $rest ne ',') {
-				if ($rest !~ /while\s*\(/ &&
-				    $dstat !~ /$exceptions/)
-				{
-					ERROR("MULTISTATEMENT_MACRO_USE_DO_WHILE",
-					      "Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
+			if ($dstat ne '' &&
+			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
+			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
+			    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&			# 10 // foo()
+			    $dstat !~ /$exceptions/ &&
+			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
+			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;$/ &&	# do {...} while (...);
+			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
+			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()
+			    $dstat !~ /^do\s*{/ &&					# do {...
+			    $dstat !~ /^\({/)						# ({...
+			{
+				$ctx =~ s/\n*$//;
+				my $herectx = $here . "\n";
+				my $cnt = statement_rawlines($ctx);
+
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";
 				}
 
-			} elsif ($ctx !~ /;/) {
-				if ($dstat ne '' &&
-				    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&
-				    $dstat !~ /$exceptions/ &&
-				    $dstat !~ /^\.$Ident\s*=/ &&
-				    $dstat =~ /$Operators/)
-				{
+				if ($dstat =~ /;/) {
+					ERROR("MULTISTATEMENT_MACRO_USE_DO_WHILE",
+					      "Macros with multiple statements should be enclosed in a do - while loop\n" . "$herectx");
+				} else {
 					ERROR("COMPLEX_MACRO",
-					      "Macros with complex values should be enclosed in parenthesis\n" . "$here\n$ctx\n");
+					      "Macros with complex values should be enclosed in parenthesis\n" . "$herectx");
 				}
 			}
 		}
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

