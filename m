From: akpm@linux-foundation.org
Subject: - checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:07 -0700
Message-ID: <200810182313.m9IND7kr028131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbYJRXNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: square brackets -- exemption for array slices in braces
has been removed from the -mm tree.  Its filename was
     checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: square brackets -- exemption for array slices in braces
From: Andy Whitcroft <apw@shadowen.org>

It is wholy reasonable to have square brackets representing array slices
in braces on the same line.  These should be spaced.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-square-brackets-exemption-for-array-slices-in-braces scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-square-brackets-exemption-for-array-slices-in-braces
+++ a/scripts/checkpatch.pl
@@ -1493,11 +1493,13 @@ sub process {
 
 # check for spacing round square brackets; allowed:
 #  1. with a type on the left -- int [] a;
-#  2. at the beginning of a line for slice initialisers -- [0..10] = 5,
+#  2. at the beginning of a line for slice initialisers -- [0...10] = 5,
+#  3. inside a curly brace -- = { [0...10] = 5 }
 		while ($line =~ /(.*?\s)\[/g) {
 			my ($where, $prefix) = ($-[1], $1);
 			if ($prefix !~ /$Type\s+$/ &&
-			    ($where != 0 || $prefix !~ /^.\s+$/)) {
+			    ($where != 0 || $prefix !~ /^.\s+$/) &&
+			    $prefix !~ /{\s+$/) {
 				ERROR("space prohibited before open square bracket '['\n" . $herecurr);
 			}
 		}
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

