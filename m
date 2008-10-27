From: akpm@linux-foundation.org
Subject: + checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:32:15 -0700
Message-ID: <200810272132.m9RLWFuW005176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbYJ0VcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:32:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: comment ends inside strings is most likely not an open comment
has been added to the -mm tree.  Its filename is
     checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment.patch

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
Subject: checkpatch: comment ends inside strings is most likely not an open comment
From: Andy Whitcroft <apw@shadowen.org>

When we are detecting whether a comment is open when we start a hunk we
check for the first comment edge in the hunk and assume its inverse. 
However if the hunk contains something like below, then we will assume
that a comment was open.  Update this heuristic to see if the comment edge
is obviously within double quotes and ignore it if so:

	foo(" */);

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment
+++ a/scripts/checkpatch.pl
@@ -367,7 +367,7 @@ sub sanitise_line {
 			}
 		}
 
-		#print "SQ:$sanitise_quote\n";
+		#print "c<$c> SQ<$sanitise_quote>\n";
 		if ($off != 0 && $sanitise_quote eq '*/' && $c ne "\t") {
 			substr($res, $off, 1, $;);
 		} elsif ($off != 0 && $sanitise_quote && $c ne "\t") {
@@ -1103,8 +1103,11 @@ sub process {
 				$cnt--;
 				#print "RAW<$rawlines[$ln - 1]>\n";
 				last if (!defined $rawlines[$ln - 1]);
-				($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);
-				last if (defined $edge);
+				if ($rawlines[$ln - 1] =~ m@(/\*|\*/)@ &&
+				    $rawlines[$ln - 1] !~ m@"[^"]*(?:/\*|\*/)[^"]*"@) {
+					($edge) = $1;
+					last;
+				}
 			}
 			if (defined $edge && $edge eq '*/') {
 				$in_comment = 1;
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

