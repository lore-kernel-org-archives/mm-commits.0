From: akpm@linux-foundation.org
Subject: + cpuset-use-seq_mask_-to-print-masks.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:54:44 -0700
Message-ID: <200810161954.m9GJsi1C010553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361AbYJPTzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, adobriyan@gmail.com, menage@google.com, pj@sgi.com


The patch titled
     cpuset: use seq_*mask_* to print masks
has been added to the -mm tree.  Its filename is
     cpuset-use-seq_mask_-to-print-masks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
devcgroup-remove-spin_lock.patch
seq_file-dont-call-bitmap_scnprintf_len.patch
seq_file-add-seq_cpumask_list-seq_nodemask_list.patch
cpuset-use-seq_mask_-to-print-masks.patch
bitmask-remove-bitmap_scnprintf_len.patch

