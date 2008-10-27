From: akpm@linux-foundation.org
Subject: + checkpatch-widen-implied-comment-detection-to-allow-multiple-stars.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:32:07 -0700
Message-ID: <200810272132.m9RLW7gn005114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbYJ0VcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: widen implied comment detection to allow multiple stars
has been added to the -mm tree.  Its filename is
     checkpatch-widen-implied-comment-detection-to-allow-multiple-stars.patch

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
Subject: checkpatch: widen implied comment detection to allow multiple stars
From: Andy Whitcroft <apw@shadowen.org>

Some people use double star '**' as a comment continuation, and start
comments with complete lines of stars.  Widen the implied comment
detection to pick these up.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-widen-implied-comment-detection-to-allow-multiple-stars scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-widen-implied-comment-detection-to-allow-multiple-stars
+++ a/scripts/checkpatch.pl
@@ -1109,7 +1109,7 @@ sub process {
 			# is the start of a diff block and this line starts
 			# ' *' then it is very likely a comment.
 			if (!defined $edge &&
-			    $rawlines[$linenr] =~ m@^.\s* \*(?:\s|$)@)
+			    $rawlines[$linenr] =~ m@^.\s*(?:\*\*+| \*)(?:\s|$)@)
 			{
 				$in_comment = 1;
 			}
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

