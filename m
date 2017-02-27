From: akpm@linux-foundation.org
Subject: [merged] checkpatch-remove-false-unbalanced-braces-warning.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:29:31 -0800
Message-ID: <58b48c2b.bCb/Q0ozNM8MWzXM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33548 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdB0Ubs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:31:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven@narfation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove false unbalanced braces warning
has been removed from the -mm tree.  Its filename was
     checkpatch-remove-false-unbalanced-braces-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sven Eckelmann <sven@narfation.org>
Subject: checkpatch: remove false unbalanced braces warning

Lines containing "} else {" should not be detected as unbalanced braces. 
But the second check can be reduced to ".+else\s*{" and it therefore never
checked if the beginning of a line contains any other character (like the
relevant "}").  This check would also return true for "} else {" and
create warnings like

    CHECK: Unbalanced braces around else statement
    #391: FILE: ./net/batman-adv/tvlv.c:391:
    +   } else {

The check can be changed to check the whole line for the missing "}" to
avoid this false positive.

Fixes: 0d1532456c26 ("checkpatch: notice unbalanced else braces in a patch")
Link: http://lkml.kernel.org/r/20170220121644.12209-1-sven@narfation.org
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-remove-false-unbalanced-braces-warning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-remove-false-unbalanced-braces-warning
+++ a/scripts/checkpatch.pl
@@ -5105,8 +5105,8 @@ sub process {
 		}
 
 # check for single line unbalanced braces
-		if ($sline =~ /.\s*\}\s*else\s*$/ ||
-		    $sline =~ /.\s*else\s*\{\s*$/) {
+		if ($sline =~ /^.\s*\}\s*else\s*$/ ||
+		    $sline =~ /^.\s*else\s*\{\s*$/) {
 			CHK("BRACES", "Unbalanced braces around else statement\n" . $herecurr);
 		}
 
_

Patches currently in -mm which might be from sven@narfation.org are


