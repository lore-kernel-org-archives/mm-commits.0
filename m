From: akpm@linux-foundation.org
Subject: - checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:31 -0800
Message-ID: <200901072216.n07MGVcL016196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761097AbZAGWQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: comment detection may miss an implied comment on the last hunk
has been removed from the -mm tree.  Its filename was
     checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: comment detection may miss an implied comment on the last hunk
From: Andy Whitcroft <apw@shadowen.org>

When detecting implied comments from leading stars we may incorrectly
think we have detected an edge one way or the other when we have not if we
drop off the end of the last hunk.  Fix this up.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk
+++ a/scripts/checkpatch.pl
@@ -1097,8 +1097,8 @@ sub process {
 					 $rawlines[$ln - 1] =~ /^-/);
 				$cnt--;
 				#print "RAW<$rawlines[$ln - 1]>\n";
-				($edge) = (defined $rawlines[$ln - 1] &&
-					$rawlines[$ln - 1] =~ m@(/\*|\*/)@);
+				last if (!defined $rawlines[$ln - 1]);
+				($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);
 				last if (defined $edge);
 			}
 			if (defined $edge && $edge eq '*/') {
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch

