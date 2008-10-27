From: akpm@linux-foundation.org
Subject: + checkpatch-structure-member-assignments-are-not-complex.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:32:09 -0700
Message-ID: <200810272132.m9RLW9TC005147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbYJ0VcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:32:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: structure member assignments are not complex
has been added to the -mm tree.  Its filename is
     checkpatch-structure-member-assignments-are-not-complex.patch

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
Subject: checkpatch: structure member assignments are not complex
From: Andy Whitcroft <apw@shadowen.org>

Ensure we do not trigger the complex macros checks on structure member
assignment, for example:

	#define foo .bar = 10

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-structure-member-assignments-are-not-complex scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-structure-member-assignments-are-not-complex
+++ a/scripts/checkpatch.pl
@@ -2167,9 +2167,10 @@ sub process {
 				MODULE_PARAM_DESC|
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
-				__typeof__\(
+				__typeof__\(|
+				\.$Ident\s*=\s*
 			}x;
-			#print "REST<$rest>\n";
+			#print "REST<$rest> dstat<$dstat>\n";
 			if ($rest ne '') {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)
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

