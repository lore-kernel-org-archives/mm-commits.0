From: akpm@linux-foundation.org
Subject: + checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:32:05 -0700
Message-ID: <200810272132.m9RLW5aK005106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbYJ0VcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:32:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: comment detection may miss an implied comment on the last hunk
has been added to the -mm tree.  Its filename is
     checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk.patch

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

checkpatch-add-checks-for-in_atomic.patch
checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk.patch
checkpatch-widen-implied-comment-detection-to-allow-multiple-stars.patch
checkpatch-structure-member-assignments-are-not-complex.patch
checkpatch-__weak-is-an-official-attribute.patch
checkpatch-detect-multiple-bitfield-declarations.patch
checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment.patch
checkpatch-dissallow-spaces-between-stars-in-pointer-types.patch
checkpatch-version-025.patch

