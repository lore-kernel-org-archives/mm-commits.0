From: akpm@linux-foundation.org
Subject: [merged] checkpatch-warn-on-logging-continuations.patch removed
 from -mm tree
Date: Mon, 27 Feb 2017 12:29:23 -0800
Message-ID: <58b48c23.AdRpyFA4Bykm+Bdl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbdB0Ukd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:40:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on logging continuations
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-logging-continuations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn on logging continuations

pr_cont(...) and printk(KERN_CONT ...) uses should be discouraged
as their output can be interleaved by multiple logging processes.

Link: http://lkml.kernel.org/r/7100ba00098694ec81471a299583ed068975fd05.1483465888.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-logging-continuations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-logging-continuations
+++ a/scripts/checkpatch.pl
@@ -5287,6 +5287,12 @@ sub process {
 			}
 		}
 
+# check for logging continuations
+		if ($line =~ /\bprintk\s*\(\s*KERN_CONT\b|\bpr_cont\s*\(/) {
+			WARN("LOGGING_CONTINUATION",
+			     "Avoid logging continuation uses where feasible\n" . $herecurr);
+		}
+
 # check for mask then right shift without a parentheses
 		if ($^V && $^V ge 5.10.0 &&
 		    $line =~ /$LvalOrFunc\s*\&\s*($LvalOrFunc)\s*>>/ &&
_

Patches currently in -mm which might be from joe@perches.com are

checkpatchpl-warn-against-using-%z-fix.patch

