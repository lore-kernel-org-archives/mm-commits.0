From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-documentation-update.patch removed from -mm tree
Date: Wed, 14 Jan 2009 17:25:45 -0800
Message-ID: <200901150125.n0F1Pkcn026221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbZAOBZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 20:25:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zbr@ioremap.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: OOM documentation update
has been removed from the -mm tree.  Its filename was
     oom-documentation-update.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: OOM documentation update
From: Evgeniy Polyakov <zbr@ioremap.net>

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN Documentation/filesystems/proc.txt~oom-documentation-update Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~oom-documentation-update
+++ a/Documentation/filesystems/proc.txt
@@ -2027,6 +2027,32 @@ increase the likelihood of this process 
 values are in the range -16 to +15, plus the special value -17, which disables
 oom-killing altogether for this process.
 
+The process to be killed in an out-of-memory situation is selected among all others
+based on its badness score. This value equals the original memory size of the process
+and is then updated according to its CPU time (utime + stime) and the
+run time (uptime - start time). The longer it runs the smaller is the score.
+Badness score is divided by the square root of the CPU time and then by
+the double square root of the run time.
+
+Swapped out tasks are killed first. Half of each child's memory size is added to
+the parent's score if they do not share the same memory. Thus forking servers
+are the prime candidates to be killed. Having only one 'hungry' child will make
+parent less preferable than the child.
+
+/proc/<pid>/oom_score shows process' current badness score.
+
+The following heuristics are then applied:
+ * if the task was reniced, its score doubles
+ * superuser or direct hardware access tasks (CAP_SYS_ADMIN, CAP_SYS_RESOURCE
+ 	or CAP_SYS_RAWIO) have their score divided by 4
+ * if oom condition happened in one cpuset and checked task does not belong
+ 	to it, its score is divided by 8
+ * the resulting score is multiplied by two to the power of oom_adj, i.e.
+	points <<= oom_adj when it is positive and
+	points >>= -(oom_adj) otherwise
+
+The task with the highest badness score is then killed.
+
 2.13 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
 
_

Patches currently in -mm which might be from zbr@ioremap.net are

oom-documentation-update.patch

