From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-some-strict-coding-style-checks.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:15 -0700
Message-ID: <20120326193015.5EAF5A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:38491 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716Ab2CZTaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2012 15:30:17 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id i8so288281laa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bruce.w.allan@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add some --strict coding style checks
has been removed from the -mm tree.  Its filename was
     checkpatch-add-some-strict-coding-style-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add some --strict coding style checks

Argument alignment across multiple lines should match the open
parenthesis.

Logical continuations should be at the end of the previous line, not the
start of a new line.

These are not required by CodingStyle so make the tests active only when
using --strict.

Improved by some examples from Bruce Allen.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Bruce W. Allen" <bruce.w.allan@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   94 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 10 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-some-strict-coding-style-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-some-strict-coding-style-checks
+++ a/scripts/checkpatch.pl
@@ -330,10 +330,15 @@ sub build_types {
 }
 build_types();
 
-our $match_balanced_parentheses = qr/(\((?:[^\(\)]+|(-1))*\))/;
 
 our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
-our $LvalOrFunc	= qr{($Lval)\s*($match_balanced_parentheses{0,1})\s*};
+
+# Using $balanced_parens, $LvalOrFunc, or $FuncArg
+# requires at least perl version v5.10.0
+# Any use must be runtime checked with $^V
+
+our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
+our $LvalOrFunc	= qr{($Lval)\s*($balanced_parens{0,1})\s*};
 our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
 
 sub deparenthesize {
@@ -1330,6 +1335,36 @@ sub check_absolute_file {
 	}
 }
 
+sub pos_last_openparen {
+	my ($line) = @_;
+
+	my $pos = 0;
+
+	my $opens = $line =~ tr/\(/\(/;
+	my $closes = $line =~ tr/\)/\)/;
+
+	my $last_openparen = 0;
+
+	if (($opens == 0) || ($closes >= $opens)) {
+		return -1;
+	}
+
+	my $len = length($line);
+
+	for ($pos = 0; $pos < $len; $pos++) {
+		my $string = substr($line, $pos);
+		if ($string =~ /^($FuncArg|$balanced_parens)/) {
+			$pos += length($1) - 1;
+		} elsif (substr($line, $pos, 1) eq '(') {
+			$last_openparen = $pos;
+		} elsif (index($string, '(') == -1) {
+			last;
+		}
+	}
+
+	return $last_openparen + 1;
+}
+
 sub process {
 	my $filename = shift;
 
@@ -1783,6 +1818,37 @@ sub process {
 			     "please, no space before tabs\n" . $herevet);
 		}
 
+# check for && or || at the start of a line
+		if ($rawline =~ /^\+\s*(&&|\|\|)/) {
+			CHK("LOGICAL_CONTINUATIONS",
+			    "Logical continuations should be on the previous line\n" . $hereprev);
+		}
+
+# check multi-line statement indentation matches previous line
+		if ($^V && $^V ge 5.10.0 &&
+		    $prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/) {
+			$prevline =~ /^\+(\t*)(.*)$/;
+			my $oldindent = $1;
+			my $rest = $2;
+
+			my $pos = pos_last_openparen($rest);
+			if ($pos >= 0) {
+				$line =~ /^\+([ \t]*)/;
+				my $newindent = $1;
+
+				my $goodtabindent = $oldindent .
+					"\t" x ($pos / 8) .
+					" "  x ($pos % 8);
+				my $goodspaceindent = $oldindent . " "  x $pos;
+
+				if ($newindent ne $goodtabindent &&
+				    $newindent ne $goodspaceindent) {
+					CHK("PARENTHESIS_ALIGNMENT",
+					    "Alignment should match open parenthesis\n" . $hereprev);
+				}
+			}
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments
@@ -3142,12 +3208,13 @@ sub process {
 		}
 
 # Check for misused memsets
-		if (defined $stat &&
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
 		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*$FuncArg\s*\)/s) {
 
 			my $ms_addr = $2;
-			my $ms_val = $8;
-			my $ms_size = $14;
+			my $ms_val = $7;
+			my $ms_size = $12;
 
 			if ($ms_size =~ /^(0x|)0$/i) {
 				ERROR("MEMSET",
@@ -3159,17 +3226,18 @@ sub process {
 		}
 
 # typecasts on min/max could be min_t/max_t
-		if (defined $stat &&
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
 		    $stat =~ /^\+(?:.*?)\b(min|max)\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\)/) {
-			if (defined $2 || defined $8) {
+			if (defined $2 || defined $7) {
 				my $call = $1;
 				my $cast1 = deparenthesize($2);
 				my $arg1 = $3;
-				my $cast2 = deparenthesize($8);
-				my $arg2 = $9;
+				my $cast2 = deparenthesize($7);
+				my $arg2 = $8;
 				my $cast;
 
-				if ($cast1 ne "" && $cast2 ne "") {
+				if ($cast1 ne "" && $cast2 ne "" && $cast1 ne $cast2) {
 					$cast = "$cast1 or $cast2";
 				} elsif ($cast1 ne "") {
 					$cast = $cast1;
@@ -3391,6 +3459,12 @@ sub process {
 	}
 
 	if ($quiet == 0) {
+
+		if ($^V lt 5.10.0) {
+			print("NOTE: perl $^V is not modern enough to detect all possible issues.\n");
+			print("An upgrade to at least perl v5.10.0 is suggested.\n\n");
+		}
+
 		# If there were whitespace errors which cleanpatch can fix
 		# then suggest that.
 		if ($rpt_cleaners) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fix-remoteproc-f-typo.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

