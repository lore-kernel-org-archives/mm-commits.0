From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-logging-continuations.patch added to -mm
 tree
Date: Thu, 05 Jan 2017 16:37:12 -0800
Message-ID: <586ee6b8.2YQUghNZKlnybzxu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758181AbdAFAfy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:35:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on logging continuations
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-logging-continuations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-logging-continuations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-logging-continuations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-warn-on-embedded-function-names.patch
checkpatch-warn-on-logging-continuations.patch

