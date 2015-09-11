From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-suspect_code_indent-test.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:13 -0700
Message-ID: <55f3197d.xKXJaBOdd7xohhCy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbIKSMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve SUSPECT_CODE_INDENT test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-suspect_code_indent-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve SUSPECT_CODE_INDENT test

Many lines exist like

	if (foo)
			bar;

where the tabbed indentation of the branch is not one more than the "if"
line above it.

checkpatch should emit a warning on those lines.

Miscellenea:

o Remove comments from branch blocks
o Skip blank lines in block

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-suspect_code_indent-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-suspect_code_indent-test
+++ a/scripts/checkpatch.pl
@@ -3076,15 +3076,22 @@ sub process {
 
 			substr($s, 0, length($c), '');
 
-			# Make sure we remove the line prefixes as we have
-			# none on the first line, and are going to readd them
-			# where necessary.
-			$s =~ s/\n./\n/gs;
+			# remove inline comments
+			$s =~ s/$;/ /g;
+			$c =~ s/$;/ /g;
 
 			# Find out how long the conditional actually is.
 			my @newlines = ($c =~ /\n/gs);
 			my $cond_lines = 1 + $#newlines;
 
+			# Make sure we remove the line prefixes as we have
+			# none on the first line, and are going to readd them
+			# where necessary.
+			$s =~ s/\n./\n/gs;
+			while ($s =~ /\n\s+\\\n/) {
+				$cond_lines += $s =~ s/\n\s+\\\n/\n/g;
+			}
+
 			# We want to check the first line inside the block
 			# starting at the end of the conditional, so remove:
 			#  1) any blank line termination
@@ -3150,8 +3157,10 @@ sub process {
 
 			#print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s> cond_lines<$cond_lines> stat_real<$stat_real> stat<$stat>\n";
 
-			if ($check && (($sindent % 8) != 0 ||
-			    ($sindent <= $indent && $s ne ''))) {
+			if ($check && $s ne '' &&
+			    (($sindent % 8) != 0 ||
+			     ($sindent < $indent) ||
+			     ($sindent > $indent + 8))) {
 				WARN("SUSPECT_CODE_INDENT",
 				     "suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");
 			}
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

