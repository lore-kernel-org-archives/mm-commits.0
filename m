From: akpm@linux-foundation.org
Subject: - checkpatch-track-ifdef-else-endif-when-tracking-blocks.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:02 -0800
Message-ID: <200901072217.n07MH25F016718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762062AbZAGWRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: track #ifdef/#else/#endif when tracking blocks
has been removed from the -mm tree.  Its filename was
     checkpatch-track-ifdef-else-endif-when-tracking-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

