From: akpm@linux-foundation.org
Subject: + checkpatch-add-some-strict-coding-style-checks-v3.patch added to -mm tree
Date: Fri, 02 Mar 2012 14:26:27 -0800
Message-ID: <20120302222627.A584CA02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62756 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2CBW0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Mar 2012 17:26:30 -0500
Received: by wejx9 with SMTP id x9so84458wej.1
        for <mm-commits@vger.kernel.org>; Fri, 02 Mar 2012 14:26:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bruce.w.allan@intel.com


The patch titled
     Subject: checkpatch-add-some-strict-coding-style-checks-v3
has been added to the -mm tree.  Its filename is
     checkpatch-add-some-strict-coding-style-checks-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: checkpatch-add-some-strict-coding-style-checks-v3

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatch-add-some-strict-coding-style-checks-v3.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch

