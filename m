From: akpm@linux-foundation.org
Subject: [to-be-updated] checkpatch-suggest-using-min_t-or-max_t.patch removed from -mm tree
Date: Fri, 27 May 2011 13:43:45 -0700
Message-ID: <201105272043.p4RKhj7o020124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437Ab1E0UoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:44:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: suggest using min_t() or max_t()
has been removed from the -mm tree.  Its filename was
     checkpatch-suggest-using-min_t-or-max_t.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: suggest using min_t() or max_t()
From: Joe Perches <joe@perches.com>

A common issue with min() or max() is using a cast on one or both of the
arguments when using min_t/max_t could be better.

Add cast detection to uses of min/max and suggest an appropriate use of
min_t or max_t instead.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-suggest-using-min_t-or-max_t scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suggest-using-min_t-or-max_t
+++ a/scripts/checkpatch.pl
@@ -268,6 +268,20 @@ sub build_types {
 }
 build_types();
 
+our $match_balanced_parentheses = qr/(\((?:[^\(\)]++|(?-1))*\))/;
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
@@ -2285,6 +2299,27 @@ sub process {
 			}
 		}
 
+# typecasts on min/max could be min_t/max_t
+		if ($line =~ /^\+.*\b(min|max)\s*\($Typecast{0,1}($LvalOrFunc)\s*,\s*$Typecast{0,1}($LvalOrFunc)\s*\)/) {
+			if (defined $2 || defined $7) {
+				my $call = $1;
+				my $cast1 = deparenthesize($2);
+				my $arg1 = $3;
+				my $cast2 = deparenthesize($7);
+				my $arg2 = $8;
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

