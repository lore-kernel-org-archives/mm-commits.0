From: akpm@linux-foundation.org
Subject: - checkpatch-suspect-indent-handle-macro-continuation.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:16 -0700
Message-ID: <200810182314.m9INEGRY028372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbYJRXOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: suspect indent handle macro continuation
has been removed from the -mm tree.  Its filename was
     checkpatch-suspect-indent-handle-macro-continuation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: suspect indent handle macro continuation
From: Andy Whitcroft <apw@shadowen.org>

When ignoring a macro in the middle of a conditional, we need to ignore
the macro start and any continuation lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-suspect-indent-handle-macro-continuation scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suspect-indent-handle-macro-continuation
+++ a/scripts/checkpatch.pl
@@ -1465,6 +1465,7 @@ sub process {
 			}
 
 			my $cond_ptr = -1;
+			$continuation = 0;
 			while ($cond_ptr != $cond_lines) {
 				$cond_ptr = $cond_lines;
 
@@ -1478,9 +1479,11 @@ sub process {
 				#  1) blank lines, they should be at 0,
 				#  2) preprocessor lines, and
 				#  3) labels.
-				if ($s =~ /^\s*?\n/ ||
+				if ($continuation ||
+				    $s =~ /^\s*?\n/ ||
 				    $s =~ /^\s*#\s*?/ ||
 				    $s =~ /^\s*$Ident\s*:/) {
+					$continuation = ($s =~ /^.*?\\\n/) ? 1 : 0;
 					$s =~ s/^.*?\n//;
 					$cond_lines++;
 				}
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

