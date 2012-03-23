From: akpm@linux-foundation.org
Subject: [folded] checkpatch-add-some-strict-coding-style-checks-v3.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:28:18 -0700
Message-ID: <20120323212818.7F06AA0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36801 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2CWV2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:28:19 -0400
Received: by qcsp5 with SMTP id p5so304559qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:28:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bruce.w.allan@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-add-some-strict-coding-style-checks-v3
has been removed from the -mm tree.  Its filename was
     checkpatch-add-some-strict-coding-style-checks-v3.patch

This patch was dropped because it was folded into checkpatch-add-some-strict-coding-style-checks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch-add-some-strict-coding-style-checks-v3

V2: Scan the entire line for balanced parentheses,
    use the position of the last non-balanced open parenthesis.
    Allow all space indentation too, checkpatch will complain
    in a different message about that if it's too long.
    Fixes a hang in the memset tests.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Bruce W. Allen" <bruce.w.allan@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   45 +++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-some-strict-coding-style-checks-v3 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-some-strict-coding-style-checks-v3
+++ a/scripts/checkpatch.pl
@@ -330,11 +330,15 @@ sub build_types {
 }
 build_types();
 
-our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
-our $lval_parens = qr/(\((?:[^\(\)]+|(-1))*\))/;
 
 our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
-our $LvalOrFunc	= qr{($Lval)\s*($lval_parens{0,1})\s*};
+
+# Using $balanced_parens, $LvalOrFunc, or $FuncArg
+# requires at least perl version v5.10.0
+# Any use must be runtime checked with $^V
+
+our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
+our $LvalOrFunc	= qr{($Lval)\s*($balanced_parens{0,1})\s*};
 our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
 
 sub deparenthesize {
@@ -1350,11 +1354,11 @@ sub pos_last_openparen {
 	for ($pos = 0; $pos < $len; $pos++) {
 		my $string = substr($line, $pos);
 		if ($string =~ /^($FuncArg|$balanced_parens)/) {
-			$pos += length($1);
-		}
-
-		if (substr($line, $pos, 1) eq '(') {
+			$pos += length($1) - 1;
+		} elsif (substr($line, $pos, 1) eq '(') {
 			$last_openparen = $pos;
+		} elsif (index($string, '(') == -1) {
+			last;
 		}
 	}
 
@@ -1821,7 +1825,8 @@ sub process {
 		}
 
 # check multi-line statement indentation matches previous line
-		if ($prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/) {
+		if ($^V && $^V ge 5.10.0 &&
+		    $prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/) {
 			$prevline =~ /^\+(\t*)(.*)$/;
 			my $oldindent = $1;
 			my $rest = $2;
@@ -3203,12 +3208,13 @@ sub process {
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
@@ -3220,17 +3226,18 @@ sub process {
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
@@ -3452,6 +3459,12 @@ sub process {
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
get_maintainer-use-a-default-unknown-s-status-role.patch
get_maintainerpl-add-support-for-moderated-lists.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch
checkpatch-add-strict-tests-for-braces-comments-and-casts.patch
checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch
checkpatch-warn-on-use-of-yield.patch
checkpatch-whitespace-add-remove-blank-lines.patch
checkpatch-check-for-quoted-strings-broken-across-lines.patch

