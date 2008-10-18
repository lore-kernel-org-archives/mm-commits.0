From: akpm@linux-foundation.org
Subject: - checkpatch-case-default-checks-should-only-check-changed-lines.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:42 -0700
Message-ID: <200810182313.m9INDghi028237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbYJRXNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: case/default checks should only check changed lines
has been removed from the -mm tree.  Its filename was
     checkpatch-case-default-checks-should-only-check-changed-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: case/default checks should only check changed lines
From: Andy Whitcroft <apw@shadowen.org>

We should only be checking changes lines for the trailing statement check
on case/default statements.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-case-default-checks-should-only-check-changed-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-case-default-checks-should-only-check-changed-lines
+++ a/scripts/checkpatch.pl
@@ -1363,14 +1363,6 @@ sub process {
 				ERROR("switch and case should be at the same indent\n$hereline$err");
 			}
 		}
-		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
-		    $line !~ /\G(?:
-			(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
-			\s*return\s+
-		    )/xg)
-		{
-			ERROR("trailing statements should be on next line\n" . $herecurr);
-		}
 
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
@@ -1986,6 +1978,15 @@ sub process {
 				ERROR("trailing statements should be on next line\n" . $herecurr);
 			}
 		}
+# case and default should not have general statements after them
+		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
+		    $line !~ /\G(?:
+			(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
+			\s*return\s+
+		    )/xg)
+		{
+			ERROR("trailing statements should be on next line\n" . $herecurr);
+		}
 
 		# Check for }<nl>else {, these must be at the same
 		# indent level to be relevant to each other.
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

