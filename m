From: akpm@linux-foundation.org
Subject: + checkpatch-track-ifdef-else-endif-when-tracking-blocks.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:04:40 -0800
Message-ID: <200812090004.mB904e28031175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593AbYLIAFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:05:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: track #ifdef/#else/#endif when tracking blocks
has been added to the -mm tree.  Its filename is
     checkpatch-track-ifdef-else-endif-when-tracking-blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: track #ifdef/#else/#endif when tracking blocks
From: Andy Whitcroft <apw@canonical.com>

When picking up a complete statement or block for analysis we cannot
simply track open/close/etc parenthesis we must take into account
preprocessor section boundaries.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-track-ifdef-else-endif-when-tracking-blocks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-track-ifdef-else-endif-when-tracking-blocks
+++ a/scripts/checkpatch.pl
@@ -405,6 +405,7 @@ sub ctx_statement_block {
 
 	my $type = '';
 	my $level = 0;
+	my @stack = ([$type, $level]);
 	my $p;
 	my $c;
 	my $len = 0;
@@ -436,6 +437,16 @@ sub ctx_statement_block {
 		$remainder = substr($blk, $off);
 
 		#warn "CSB: c<$c> type<$type> level<$level> remainder<$remainder> coff_set<$coff_set>\n";
+
+		# Handle nested #if/#else.
+		if ($remainder =~ /^#\s*(?:ifndef|ifdef|if)\s/) {
+			push(@stack, [ $type, $level ]);
+		} elsif ($remainder =~ /^#\s*(?:else|elif)\b/) {
+			($type, $level) = @{$stack[$#stack - 1]};
+		} elsif ($remainder =~ /^#\s*endif\b/) {
+			($type, $level) = @{pop(@stack)};
+		}
+
 		# Statement ends at the ';' or a close '}' at the
 		# outermost level.
 		if ($level == 0 && $c eq ';') {
@@ -582,11 +593,22 @@ sub ctx_block_get {
 	my @res = ();
 
 	my $level = 0;
+	my @stack = ($level);
 	for ($line = $start; $remain > 0; $line++) {
 		next if ($rawlines[$line] =~ /^-/);
 		$remain--;
 
 		$blk .= $rawlines[$line];
+
+		# Handle nested #if/#else.
+		if ($rawlines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
+			push(@stack, $level);
+		} elsif ($rawlines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
+			$level = $stack[$#stack - 1];
+		} elsif ($rawlines[$line] =~ /^.\s*#\s*endif\b/) {
+			$level = pop(@stack);
+		}
+
 		foreach my $c (split(//, $rawlines[$line])) {
 			##print "C<$c>L<$level><$open$close>O<$off>\n";
 			if ($off > 0) {
_

Patches currently in -mm which might be from apw@canonical.com are

linux-next.patch
checkpatch-update-copyrights.patch
checkpatch-add-warning-for-p0-patches.patch
checkpatch-allow-parentheses-on-return-for-comparisons.patch
checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch
checkpatch-loosen-spacing-on-typedef-function-checks.patch
checkpatch-fix-continuation-detection-when-handling-spacing-on-operators.patch
checkpatch-track-ifdef-else-endif-when-tracking-blocks.patch
checkpatch-do-not-report-nr_static-as-a-static-declaration.patch
checkpatch-ensure-we-actually-detect-if-assignments-split-across-lines.patch
checkpatch-struct-file_operations-should-normally-be-const.patch
checkpatch-fix-the-perlcritic-errors.patch
checkpatch-version-026.patch

