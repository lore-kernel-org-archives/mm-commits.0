From: akpm@linux-foundation.org
Subject: - update-checkpatchpl-to-version-017.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:59 -0700
Message-ID: <200804300540.m3U5ex6e029017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756238AbYD3Fli (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     update checkpatch.pl to version 0.17
has been removed from the -mm tree.  Its filename was
     update-checkpatchpl-to-version-017.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: update checkpatch.pl to version 0.17
From: Andy Whitcroft <apw@shadowen.org>

This version brings improvements to external declaration detection, fixes to
quote tracking, fixes to unary tracking, some clarification of wording, and
the usual slew of fixes for false positives.

Of note:
 - much better unary tracking across preprocessor directives
 - UTF8 checks highlight the character at fault
 - widening of mutex detection

Andy Whitcroft (17):
      Version: 0.17
      values: __attribute__ carries through the previous type
      quotes: should only follow "positive" lines
      clarify the indent tabs over spaces wording
      loosen NR_CPUS check for array range initialisers
      detect external function declarations without an extern prefix
      function declaration arguments should be with the identifier
      DEFINE_MUTEX should report in line with struct mutex
      NR_CPUS is valid in preprocessor statements
      comment detection should not start on the @@ line
      types: add support for #undef
      tighten mutex/completion reports to usage
      allow export of function pointers
      values: preprocessor #define is out of line maintain values
      values: #define does not always have parentheses
      unary '*' may be const
      utf8 checks should report location of the invalid character

Wolfram Sang (1):
      make checkpatch.pl really skip <asm/irq.h>

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  131 +++++++++++++++++++++++++++-------------
 1 file changed, 90 insertions(+), 41 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-017 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-017
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.16';
+my $V = '0.17';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -131,6 +131,17 @@ our $NonptrType;
 our $Type;
 our $Declare;
 
+our $UTF8	= qr {
+	[\x09\x0A\x0D\x20-\x7E]              # ASCII
+	| [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
+	|  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
+	| [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
+	|  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
+	|  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
+	| [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
+	|  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
+}x;
+
 our @typeList = (
 	qr{void},
 	qr{char},
@@ -692,7 +703,7 @@ sub annotate_values {
 	while (length($cur)) {
 		@av_paren_type = ('E') if ($#av_paren_type < 0);
 		print " <" . join('', @av_paren_type) .
-					"> <$type> " if ($dbg_values > 1);
+				"> <$type> <$av_pending>" if ($dbg_values > 1);
 		if ($cur =~ /^(\s+)/o) {
 			print "WS($1)\n" if ($dbg_values > 1);
 			if ($1 =~ /\n/ && $av_preprocessor) {
@@ -705,9 +716,18 @@ sub annotate_values {
 			$type = 'T';
 
 		} elsif ($cur =~ /^(#\s*define\s*$Ident)(\(?)/o) {
-			print "DEFINE($1)\n" if ($dbg_values > 1);
+			print "DEFINE($1,$2)\n" if ($dbg_values > 1);
 			$av_preprocessor = 1;
-			$av_pending = 'N';
+			push(@av_paren_type, $type);
+			if ($2 ne '') {
+				$av_pending = 'N';
+			}
+			$type = 'E';
+
+		} elsif ($cur =~ /^(#\s*undef\s*$Ident)/o) {
+			print "UNDEF($1)\n" if ($dbg_values > 1);
+			$av_preprocessor = 1;
+			push(@av_paren_type, $type);
 
 		} elsif ($cur =~ /^(#\s*(?:ifdef|ifndef|if))/o) {
 			print "PRE_START($1)\n" if ($dbg_values > 1);
@@ -715,7 +735,7 @@ sub annotate_values {
 
 			push(@av_paren_type, $type);
 			push(@av_paren_type, $type);
-			$type = 'N';
+			$type = 'E';
 
 		} elsif ($cur =~ /^(#\s*(?:else|elif))/o) {
 			print "PRE_RESTART($1)\n" if ($dbg_values > 1);
@@ -723,7 +743,7 @@ sub annotate_values {
 
 			push(@av_paren_type, $av_paren_type[$#av_paren_type]);
 
-			$type = 'N';
+			$type = 'E';
 
 		} elsif ($cur =~ /^(#\s*(?:endif))/o) {
 			print "PRE_END($1)\n" if ($dbg_values > 1);
@@ -734,11 +754,16 @@ sub annotate_values {
 			# one does, and continue as if the #endif was not here.
 			pop(@av_paren_type);
 			push(@av_paren_type, $type);
-			$type = 'N';
+			$type = 'E';
 
 		} elsif ($cur =~ /^(\\\n)/o) {
 			print "PRECONT($1)\n" if ($dbg_values > 1);
 
+		} elsif ($cur =~ /^(__attribute__)\s*\(?/o) {
+			print "ATTR($1)\n" if ($dbg_values > 1);
+			$av_pending = $type;
+			$type = 'N';
+
 		} elsif ($cur =~ /^(sizeof)\s*(\()?/o) {
 			print "SIZEOF($1)\n" if ($dbg_values > 1);
 			if (defined $2) {
@@ -930,7 +955,7 @@ sub process {
 			# edge is a close comment then we must be in a comment
 			# at context start.
 			my $edge;
-			for (my $ln = $linenr; $ln < ($linenr + $realcnt); $ln++) {
+			for (my $ln = $linenr + 1; $ln < ($linenr + $realcnt); $ln++) {
 				next if ($line =~ /^-/);
 				($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);
 				last if (defined $edge);
@@ -951,9 +976,9 @@ sub process {
 			##print "COMMENT:$in_comment edge<$edge> $rawline\n";
 			sanitise_line_reset($in_comment);
 
-		} elsif ($realcnt) {
+		} elsif ($realcnt && $rawline =~ /^(?:\+| |$)/) {
 			# Standardise the strings and chars within the input to
-			# simplify matching.
+			# simplify matching -- only bother with positive lines.
 			$line = sanitise_line($rawline);
 		}
 		push(@lines, $line);
@@ -1066,17 +1091,14 @@ sub process {
 
 # UTF-8 regex found at http://www.w3.org/International/questions/qa-forms-utf-8.en.php
 		if (($realfile =~ /^$/ || $line =~ /^\+/) &&
-		     !($rawline =~ m/^(
-				[\x09\x0A\x0D\x20-\x7E]              # ASCII
-				| [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
-				|  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
-				| [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
-				|  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
-				|  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
-				| [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
-				|  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
-				)*$/x )) {
-			ERROR("Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $herecurr);
+		    $rawline !~ m/^$UTF8*$/) {
+			my ($utf8_prefix) = ($rawline =~ /^($UTF8*)/);
+
+			my $blank = copy_spacing($rawline);
+			my $ptr = substr($blank, 0, length($utf8_prefix)) . "^";
+			my $hereptr = "$hereline$ptr\n";
+
+			ERROR("Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
 		}
 
 #ignore lines being removed
@@ -1112,7 +1134,7 @@ sub process {
 		if ($rawline =~ /^\+\s* \t\s*\S/ ||
 		    $rawline =~ /^\+\s*        \s*/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("use tabs not spaces\n" . $herevet);
+			ERROR("code indent should use tabs where possible\n" . $herevet);
 		}
 
 # check for RCS/CVS revision markers
@@ -1121,35 +1143,40 @@ sub process {
 		}
 
 # Check for potential 'bare' types
+		my ($stat, $cond);
 		if ($realcnt) {
-			my ($s, $c) = ctx_statement_block($linenr, $realcnt, 0);
-			$s =~ s/\n./ /g;
-			$s =~ s/{.*$//;
+			($stat, $cond) = ctx_statement_block($linenr,
+								$realcnt, 0);
+			$stat =~ s/\n./\n /g;
+			$cond =~ s/\n./\n /g;
+
+			my $s = $stat;
+			$s =~ s/{.*$//s;
 
 			# Ignore goto labels.
-			if ($s =~ /$Ident:\*$/) {
+			if ($s =~ /$Ident:\*$/s) {
 
 			# Ignore functions being called
-			} elsif ($s =~ /^.\s*$Ident\s*\(/) {
+			} elsif ($s =~ /^.\s*$Ident\s*\(/s) {
 
 			# definitions in global scope can only start with types
-			} elsif ($s =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/) {
+			} elsif ($s =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/s) {
 				possible($1, $s);
 
 			# declarations always start with types
-			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:const\s+)?($Ident)\b(:?\s+$Sparse)?\s*\**\s*$Ident\s*(?:;|=|,)/) {
+			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:const\s+)?($Ident)\b(:?\s+$Sparse)?\s*\**\s*$Ident\s*(?:;|=|,)/s) {
 				possible($1, $s);
 			}
 
 			# any (foo ... *) is a pointer cast, and foo is a type
-			while ($s =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/g) {
+			while ($s =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/sg) {
 				possible($1, $s);
 			}
 
 			# Check for any sort of function declaration.
 			# int foo(something bar, other baz);
 			# void (*store_gdt)(x86_descr_ptr *);
-			if ($prev_values eq 'E' && $s =~ /^(.(?:typedef\s*)?(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*(?:\b$Ident|\(\*\s*$Ident\))\s*)\(/) {
+			if ($prev_values eq 'E' && $s =~ /^(.(?:typedef\s*)?(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*(?:\b$Ident|\(\*\s*$Ident\))\s*)\(/s) {
 				my ($name_len) = length($1);
 
 				my $ctx = $s;
@@ -1282,6 +1309,7 @@ sub process {
 			   ($prevline !~ /^ }/) &&
 			   ($prevline !~ /^.DECLARE_$Ident\(\Q$name\E\)/) &&
 			   ($prevline !~ /^.LIST_HEAD\(\Q$name\E\)/) &&
+			   ($prevline !~ /^.$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(/) &&
 			   ($prevline !~ /\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=|\[)/)) {
 				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 			}
@@ -1512,7 +1540,10 @@ sub process {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						ERROR("space required before that '$op' $at\n" . $hereptr);
 					}
-					if ($ctx =~ /.xW/) {
+					if ($op  eq '*' && $cc =~/\s*const\b/) {
+						# A unary '*' may be const
+
+					} elsif ($ctx =~ /.xW/) {
 						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
 					}
 
@@ -1617,7 +1648,7 @@ sub process {
 
 # Check for illegal assignment in if conditional.
 		if ($line =~ /\bif\s*\(/) {
-			my ($s, $c) = ctx_statement_block($linenr, $realcnt, 0);
+			my ($s, $c) = ($stat, $cond);
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/) {
 				ERROR("do not use assignment in if condition\n" . $herecurr);
@@ -1695,7 +1726,7 @@ sub process {
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
 		if ($tree && $rawline =~ m{^.\#\s*include\s*\<asm\/(.*)\.h\>}) {
 			my $checkfile = "$root/include/linux/$1.h";
-			if (-f $checkfile && $1 ne 'irq.h') {
+			if (-f $checkfile && $1 ne 'irq') {
 				WARN("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
 					$herecurr);
 			}
@@ -1910,7 +1941,8 @@ sub process {
 		}
 
 # check for spinlock_t definitions without a comment.
-		if ($line =~ /^.\s*(struct\s+mutex|spinlock_t)\s+\S+;/) {
+		if ($line =~ /^.\s*(struct\s+mutex|spinlock_t)\s+\S+;/ ||
+		    $line =~ /^.\s*(DEFINE_MUTEX)\s*\(/) {
 			my $which = $1;
 			if (!ctx_has_comment($first_line, $linenr)) {
 				CHK("$1 definition without comment\n" . $herecurr);
@@ -1940,8 +1972,22 @@ sub process {
 		}
 
 # check for new externs in .c files.
-		if ($line =~ /^.\s*extern\s/ && ($realfile =~ /\.c$/)) {
-			WARN("externs should be avoided in .c files\n" .  $herecurr);
+		if ($realfile =~ /\.c$/ && defined $stat &&
+		    $stat =~ /^.(?:extern\s+)?$Type\s+$Ident(\s*)\(/s)
+		{
+			my $paren_space = $1;
+
+			my $s = $stat;
+			if (defined $cond) {
+				substr($s, 0, length($cond), '');
+			}
+			if ($s =~ /^\s*;/) {
+				WARN("externs should be avoided in .c files\n" .  $herecurr);
+			}
+
+			if ($paren_space =~ /\n/) {
+				WARN("arguments for function declarations should follow identifier\n" . $herecurr);
+			}
 		}
 
 # checks for new __setup's
@@ -1964,11 +2010,11 @@ sub process {
 		}
 
 # check for semaphores used as mutexes
-		if ($line =~ /\b(DECLARE_MUTEX|init_MUTEX)\s*\(/) {
+		if ($line =~ /^.\s*(DECLARE_MUTEX|init_MUTEX)\s*\(/) {
 			WARN("mutexes are preferred for single holder semaphores\n" . $herecurr);
 		}
 # check for semaphores used as mutexes
-		if ($line =~ /\binit_MUTEX_LOCKED\s*\(/) {
+		if ($line =~ /^.\s*init_MUTEX_LOCKED\s*\(/) {
 			WARN("consider using a completion\n" . $herecurr);
 		}
 # recommend strict_strto* over simple_strto*
@@ -1979,8 +2025,11 @@ sub process {
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
 		if ($line =~ /\bNR_CPUS\b/ &&
-		    $line !~ /^.#\s*define\s+NR_CPUS\s+/ &&
-		    $line !~ /^.\s*$Declare\s.*\[[^\]]*NR_CPUS[^\]]*\]/)
+		    $line !~ /^.#\s*if\b.*\bNR_CPUS\b/ &&
+		    $line !~ /^.#\s*define\b.*\bNR_CPUS\b/ &&
+		    $line !~ /^.\s*$Declare\s.*\[[^\]]*NR_CPUS[^\]]*\]/ &&
+		    $line !~ /\[[^\]]*\.\.\.[^\]]*NR_CPUS[^\]]*\]/ &&
+		    $line !~ /\[[^\]]*NR_CPUS[^\]]*\.\.\.[^\]]*\]/)
 		{
 			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
page-owner-tracking-leak-detector.patch

