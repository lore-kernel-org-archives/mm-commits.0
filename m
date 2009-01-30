From: akpm@linux-foundation.org
Subject: [merged] oom-documentation-update.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:13:42 -0800
Message-ID: <200901301913.n0UJDgp6026396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbZA3TOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zbr@ioremap.net, randy.dunlap@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: OOM documentation update
has been removed from the -mm tree.  Its filename was
     oom-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: OOM documentation update
From: Evgeniy Polyakov <zbr@ioremap.net>

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   28 +++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN Documentation/filesystems/proc.txt~oom-documentation-update Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~oom-documentation-update
+++ a/Documentation/filesystems/proc.txt
@@ -2027,6 +2027,34 @@ increase the likelihood of this process 
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
+The task with the highest badness score is then selected and its children
+are killed, process itself will be killed in an OOM situation when it does
+not have children or some of them disabled oom like described above.
+
 2.13 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
 
_

Patches currently in -mm which might be from zbr@ioremap.net are

origin.patch
linux-next.patch

