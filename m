From: akpm@linux-foundation.org
Subject: [patch 124/124] checkpatch: remove false unbalanced braces
 warning
Date: Fri, 24 Feb 2017 15:01:43 -0800
Message-ID: <58b0bb57.Mu37RCxUyG2bdS6x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39348 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751859AbdBXXBp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:01:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sven@narfation.org, joe@perches.com

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
