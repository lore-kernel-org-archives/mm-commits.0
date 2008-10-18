From: akpm@linux-foundation.org
Subject: - checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:22 -0700
Message-ID: <200810182313.m9INDMf6028170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbYJRXNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: fix up comment checks search to scan the entire block
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: fix up comment checks search to scan the entire block
From: Andy Whitcroft <apw@shadowen.org>

We are not counting the lines in the block correctly which causes the
comment scan to stop prematurly and thus miss comments which end at the
end of the block.  Fix this up.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block
+++ a/scripts/checkpatch.pl
@@ -1029,9 +1029,14 @@ sub process {
 			# edge is a close comment then we must be in a comment
 			# at context start.
 			my $edge;
-			for (my $ln = $linenr + 1; $ln < ($linenr + $realcnt); $ln++) {
-				next if ($line =~ /^-/);
-				($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);
+			my $cnt = $realcnt;
+			for (my $ln = $linenr + 1; $cnt > 0; $ln++) {
+				next if (defined $rawlines[$ln - 1] &&
+					 $rawlines[$ln - 1] =~ /^-/);
+				$cnt--;
+				#print "RAW<$rawlines[$ln - 1]>\n";
+				($edge) = (defined $rawlines[$ln - 1] &&
+					$rawlines[$ln - 1] =~ m@(/\*|\*/)@);
 				last if (defined $edge);
 			}
 			if (defined $edge && $edge eq '*/') {
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

