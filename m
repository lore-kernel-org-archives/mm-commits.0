From: akpm@linux-foundation.org
Subject: - checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:41 -0800
Message-ID: <200901072216.n07MGf4D016415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761873AbZAGWQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: comment ends inside strings is most likely not an open comment
has been removed from the -mm tree.  Its filename was
     checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

