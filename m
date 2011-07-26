From: akpm@linux-foundation.org
Subject: [merged] checkpatch-suggest-using-min_t-or-max_t-v2.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:01 -0700
Message-ID: <201107260755.p6Q7t49k003415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab1GZHzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: suggest using min_t or max_t
has been removed from the -mm tree.  Its filename was
     checkpatch-suggest-using-min_t-or-max_t-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: suggest using min_t or max_t
From: Joe Perches <joe@perches.com>

A common issue with min() or max() is using a cast on one or both of the
arguments when using min_t/max_t could be better.

Add cast detection to uses of min/max and suggest an appropriate use of
min_t or max_t instead.

Caveat:  This only works for min() or max() on a single line.
         It does not find min() or max() split across multiple lines.

This does find:
	min((u32)foo, bar);
But it does not find:
	max((unsigned long)foo,
	    bar);

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-suggest-using-min_t-or-max_t-v2 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suggest-using-min_t-or-max_t-v2
+++ a/scripts/checkpatch.pl
@@ -268,6 +268,20 @@ sub build_types {
 }
 build_types();
 
+our $match_balanced_parentheses = qr/(\((?:[^\(\)]+|(-1))*\))/;
+
+our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
+our $LvalOrFunc	= qr{($Lval)\s*($match_balanced_parentheses{0,1})\s*};
+
+sub deparenthesize {
+	my ($string) = @_;
+	return "" if (!defined($string));
+	$string =~ s@^\s*\(\s*@@g;
+	$string =~ s@\s*\)\s*$@@g;
+	$string =~ s@\s+@ @g;
+	return $string;
+}
+
 $chk_signoff = 0 if ($file);
 
 my @dep_includes = ();
@@ -2290,6 +2304,27 @@ sub process {
 			}
 		}
 
+# typecasts on min/max could be min_t/max_t
+		if ($line =~ /^\+(?:.*?)\b(min|max)\s*\($Typecast{0,1}($LvalOrFunc)\s*,\s*$Typecast{0,1}($LvalOrFunc)\s*\)/) {
+			if (defined $2 || defined $8) {
+				my $call = $1;
+				my $cast1 = deparenthesize($2);
+				my $arg1 = $3;
+				my $cast2 = deparenthesize($8);
+				my $arg2 = $9;
+				my $cast;
+
+				if ($cast1 ne "" && $cast2 ne "") {
+					$cast = "$cast1 or $cast2";
+				} elsif ($cast1 ne "") {
+					$cast = $cast1;
+				} else {
+					$cast = $cast2;
+				}
+				WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
+			}
+		}
+
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
 			ERROR("space required before the open parenthesis '('\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-orphan-framerelay-dlci.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

