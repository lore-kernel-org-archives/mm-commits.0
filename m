From: akpm@linux-foundation.org
Subject: - checkpatch-suspect-indent-count-condition-lines-correctly.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:50 -0700
Message-ID: <200810182313.m9INDolR028267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbYJRXN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: suspect indent count condition lines correctly
has been removed from the -mm tree.  Its filename was
     checkpatch-suspect-indent-count-condition-lines-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: suspect indent count condition lines correctly
From: Andy Whitcroft <apw@shadowen.org>

Correct calculation of the number of lines of condition where we have
suspect indent.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-suspect-indent-count-condition-lines-correctly scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suspect-indent-count-condition-lines-correctly
+++ a/scripts/checkpatch.pl
@@ -1417,7 +1417,8 @@ sub process {
 			$s =~ s/\n./\n/gs;
 
 			# Find out how long the conditional actually is.
-			my $cond_lines = 0 + $c =~ /\n/gs;
+			my @newlines = ($c =~ /\n/gs);
+			my $cond_lines = 1 + $#newlines;
 
 			# We want to check the first line inside the block
 			# starting at the end of the conditional, so remove:
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

