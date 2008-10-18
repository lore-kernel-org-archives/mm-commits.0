From: akpm@linux-foundation.org
Subject: - checkpatch-conditional-indent-labels-have-different-indent-rules.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:12 -0700
Message-ID: <200810182313.m9INDCrd028137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbYJRXNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: conditional indent -- labels have different indent rules
has been removed from the -mm tree.  Its filename was
     checkpatch-conditional-indent-labels-have-different-indent-rules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: conditional indent -- labels have different indent rules
From: Andy Whitcroft <apw@shadowen.org>

Labels have different indent rules and must be ignored when checking the
conditional indent levels.  Also correct identify labels in single
statement conditionals.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-conditional-indent-labels-have-different-indent-rules scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-conditional-indent-labels-have-different-indent-rules
+++ a/scripts/checkpatch.pl
@@ -782,9 +782,9 @@ sub annotate_values {
 			}
 			$type = 'N';
 
-		} elsif ($cur =~ /^(if|while|typeof|__typeof__|for)\b/o) {
+		} elsif ($cur =~ /^(if|while|for)\b/o) {
 			print "COND($1)\n" if ($dbg_values > 1);
-			$av_pending = 'N';
+			$av_pending = 'E';
 			$type = 'N';
 
 		} elsif ($cur =~/^(case)/o) {
@@ -792,7 +792,7 @@ sub annotate_values {
 			$av_pend_colon = 'C';
 			$type = 'N';
 
-		} elsif ($cur =~/^(return|else|goto)/o) {
+		} elsif ($cur =~/^(return|else|goto|typeof|__typeof__)\b/o) {
 			print "KEYWORD($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
@@ -1846,6 +1846,11 @@ sub process {
 				$check = 0;
 			}
 
+			# Ignore the current line if it is label.
+			if ($s =~ /^\s*$Ident\s*:/) {
+				$check = 0;
+			}
+
 			my (undef, $sindent) = line_stats("+" . $s);
 
 			##print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s>\n";
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

