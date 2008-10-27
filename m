From: akpm@linux-foundation.org
Subject: + checkpatch-detect-multiple-bitfield-declarations.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:32:13 -0700
Message-ID: <200810272132.m9RLWDbs005173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299AbYJ0VcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: detect multiple bitfield declarations
has been added to the -mm tree.  Its filename is
     checkpatch-detect-multiple-bitfield-declarations.patch

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

checkpatch-add-checks-for-in_atomic.patch
checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk.patch
checkpatch-widen-implied-comment-detection-to-allow-multiple-stars.patch
checkpatch-structure-member-assignments-are-not-complex.patch
checkpatch-__weak-is-an-official-attribute.patch
checkpatch-detect-multiple-bitfield-declarations.patch
checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment.patch
checkpatch-dissallow-spaces-between-stars-in-pointer-types.patch
checkpatch-version-025.patch

