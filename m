From: akpm@linux-foundation.org
Subject: - checkpatch-detect-multiple-bitfield-declarations.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:39 -0800
Message-ID: <200901072216.n07MGdEu016372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757155AbZAGWQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: detect multiple bitfield declarations
has been removed from the -mm tree.  Its filename was
     checkpatch-detect-multiple-bitfield-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: detect multiple bitfield declarations
From: Andy Whitcroft <apw@shadowen.org>

Detect the colons (:) which make up secondary bitfield declarations and
apply binary colon checks.  For example the following is common idiom:

	int foo:1,
	    bar:1;

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-detect-multiple-bitfield-declarations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-detect-multiple-bitfield-declarations
+++ a/scripts/checkpatch.pl
@@ -844,11 +844,11 @@ sub annotate_values {
 			$type = 'V';
 			$av_pending = 'V';
 
-		} elsif ($cur =~ /^($Ident\s*):/) {
-			if ($type eq 'E') {
-				$av_pend_colon = 'L';
-			} elsif ($type eq 'T') {
+		} elsif ($cur =~ /^($Ident\s*):(?:\s*\d+\s*(,|=|;))?/) {
+			if (defined $2 && $type eq 'C' || $type eq 'T') {
 				$av_pend_colon = 'B';
+			} elsif ($type eq 'E') {
+				$av_pend_colon = 'L';
 			}
 			print "IDENT_COLON($1,$type>$av_pend_colon)\n" if ($dbg_values > 1);
 			$type = 'V';
@@ -866,6 +866,10 @@ sub annotate_values {
 			$type = 'E';
 			$av_pend_colon = 'O';
 
+		} elsif ($cur =~/^(,)/) {
+			print "COMMA($1)\n" if ($dbg_values > 1);
+			$type = 'C';
+
 		} elsif ($cur =~ /^(\?)/o) {
 			print "QUESTION($1)\n" if ($dbg_values > 1);
 			$type = 'N';
@@ -881,7 +885,7 @@ sub annotate_values {
 			}
 			$av_pend_colon = 'O';
 
-		} elsif ($cur =~ /^(;|\[)/o) {
+		} elsif ($cur =~ /^(\[)/o) {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch

