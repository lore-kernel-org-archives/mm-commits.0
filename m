From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-more-comprehensive-split-strings-warning.patch removed from -mm
 tree
Date: Fri, 24 Jan 2014 11:01:43 -0800
Message-ID: <52e2b897.bWvOJ8nUT3D78iLN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaAXTBn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, joe@perches.com

Subject: [merged] checkpatch-more-comprehensive-split-strings-warning.patch removed from -mm tree
To: joe@perches.com,josh@joshtriplett.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:43 -0800


The patch titled
     Subject: checkpatch: more comprehensive split strings warning
has been removed from the -mm tree.  Its filename was
     checkpatch-more-comprehensive-split-strings-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: more comprehensive split strings warning

The current checkpatch test for split strings does not find several cases
that should be found.

For instance:

 		/* Else poor success; go back to mode in "active" table */
 		} else {
 			IWL_DEBUG_RATE(mvm,
-				       "LQ: GOING BACK TO THE OLD TABLE suc=%d cur-tpt=%d old-tpt=%d\n",
+				       "GOING BACK TO THE OLD TABLE: SR %d "
+				       "cur-tpt %d old-tpt %d\n",
 				       window->success_ratio,
 				       window->average_tpt,
 				      lq_sta->last_tpt);

does not currently emit a warning.

Improve the test to find these cases.

Add more exceptions to reduce false positives for assembly and octal/hex
string constants.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-more-comprehensive-split-strings-warning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-more-comprehensive-split-strings-warning
+++ a/scripts/checkpatch.pl
@@ -2049,16 +2049,12 @@ sub process {
 		}
 
 # Check for user-visible strings broken across lines, which breaks the ability
-# to grep for the string.  Limited to strings used as parameters (those
-# following an open parenthesis), which almost completely eliminates false
-# positives, as well as warning only once per parameter rather than once per
-# line of the string.  Make an exception when the previous string ends in a
-# newline (multiple lines in one string constant) or \n\t (common in inline
-# assembly to indent the instruction on the following line).
+# to grep for the string.  Make exceptions when the previous string ends in a
+# newline (multiple lines in one string constant) or '\t', '\r', ';', or '{'
+# (common in inline assembly) or is a octal \123 or hexadecimal \xaf value
 		if ($line =~ /^\+\s*"/ &&
 		    $prevline =~ /"\s*$/ &&
-		    $prevline =~ /\(/ &&
-		    $prevrawline !~ /\\n(?:\\t)*"\s*$/) {
+		    $prevrawline !~ /(?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$/) {
 			WARN("SPLIT_STRING",
 			     "quoted string split across lines\n" . $hereprev);
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

