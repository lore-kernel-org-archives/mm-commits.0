From: akpm@linux-foundation.org
Subject: - cpuset-use-seq_mask_-to-print-masks.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:47 -0700
Message-ID: <200810202036.m9KKal5v011457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbYJTUhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:37:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, adobriyan@gmail.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: use seq_*mask_* to print masks
has been removed from the -mm tree.  Its filename was
     cpuset-use-seq_mask_-to-print-masks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: use seq_*mask_* to print masks
From: Lai Jiangshan <laijs@cn.fujitsu.com>

1) seq_file excepts that m->count == m->size when it's buf is full,
   so current code will causes bugs when buf is overflow.

2) There is not too good that cpuset accesses struct seq_file's
   fields directly.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN kernel/cpuset.c~cpuset-use-seq_mask_-to-print-masks kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-use-seq_mask_-to-print-masks
+++ a/kernel/cpuset.c
@@ -2436,19 +2436,15 @@ const struct file_operations proc_cpuset
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
 	seq_printf(m, "Cpus_allowed:\t");
-	m->count += cpumask_scnprintf(m->buf + m->count, m->size - m->count,
-					task->cpus_allowed);
+	seq_cpumask(m, &task->cpus_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Cpus_allowed_list:\t");
-	m->count += cpulist_scnprintf(m->buf + m->count, m->size - m->count,
-					task->cpus_allowed);
+	seq_cpumask_list(m, &task->cpus_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed:\t");
-	m->count += nodemask_scnprintf(m->buf + m->count, m->size - m->count,
-					task->mems_allowed);
+	seq_nodemask(m, &task->mems_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed_list:\t");
-	m->count += nodelist_scnprintf(m->buf + m->count, m->size - m->count,
-					task->mems_allowed);
+	seq_nodemask_list(m, &task->mems_allowed);
 	seq_printf(m, "\n");
 }
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

