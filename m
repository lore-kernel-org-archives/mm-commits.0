From: akpm@linux-foundation.org
Subject: + checkpatch-add-some-strict-coding-style-checks.patch added to -mm tree
Date: Fri, 24 Feb 2012 12:47:01 -0800
Message-ID: <20120224204701.B893FA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61763 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2BXUrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 15:47:05 -0500
Received: by wibhm9 with SMTP id hm9so28705wib.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 12:47:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bruce.w.allan@intel.com


The patch titled
     Subject: checkpatch: add some --strict coding style checks
has been added to the -mm tree.  Its filename is
     checkpatch-add-some-strict-coding-style-checks.patch

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

 scripts/checkpatch.pl |   65 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-some-strict-coding-style-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-some-strict-coding-style-checks
+++ a/scripts/checkpatch.pl
@@ -330,10 +330,11 @@ sub build_types {
 }
 build_types();
 
-our $match_balanced_parentheses = qr/(\((?:[^\(\)]+|(-1))*\))/;
+our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
+our $lval_parens = qr/(\((?:[^\(\)]+|(-1))*\))/;
 
 our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
-our $LvalOrFunc	= qr{($Lval)\s*($match_balanced_parentheses{0,1})\s*};
+our $LvalOrFunc	= qr{($Lval)\s*($lval_parens{0,1})\s*};
 our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
 
 sub deparenthesize {
@@ -1330,6 +1331,36 @@ sub check_absolute_file {
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
+			$pos += length($1);
+		}
+
+		if (substr($line, $pos, 1) eq '(') {
+			$last_openparen = $pos;
+		}
+	}
+
+	return $last_openparen + 1;
+}
+
 sub process {
 	my $filename = shift;
 
@@ -1783,6 +1814,36 @@ sub process {
 			     "please, no space before tabs\n" . $herevet);
 		}
 
+# check for && or || at the start of a line
+		if ($rawline =~ /^\+\s*(&&|\|\|)/) {
+			CHK("LOGICAL_CONTINUATIONS",
+			    "Logical continuations should be on the previous line\n" . $hereprev);
+		}
+
+# check multi-line statement indentation matches previous line
+		if ($prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/) {
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
_
Subject: Subject: checkpatch: add some --strict coding style checks

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch

