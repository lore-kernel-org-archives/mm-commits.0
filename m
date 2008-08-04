From: akpm@linux-foundation.org
Subject: + cpuset-use-seq_cpumask-seq_nodemask.patch added to -mm tree
Date: Mon, 04 Aug 2008 16:41:12 -0700
Message-ID: <200808042341.m74NfCnO005872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758737AbYHDXlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 19:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, pj@sgi.com, travis@sgi.com, viro@zeniv.linux.org.uk


The patch titled
     cpuset: use seq_cpumask(), seq_nodemask()
has been added to the -mm tree.  Its filename is
     cpuset-use-seq_cpumask-seq_nodemask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: use seq_cpumask(), seq_nodemask()
From: Alexey Dobriyan <adobriyan@gmail.com>

-ENOCHANGELOG

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/cpuset.c~cpuset-use-seq_cpumask-seq_nodemask kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-use-seq_cpumask-seq_nodemask
+++ a/kernel/cpuset.c
@@ -2392,16 +2392,14 @@ const struct file_operations proc_cpuset
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
 	seq_printf(m, "Cpus_allowed:\t");
-	m->count += cpumask_scnprintf(m->buf + m->count, m->size - m->count,
-					task->cpus_allowed);
+	seq_cpumask(m, &task->cpus_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Cpus_allowed_list:\t");
 	m->count += cpulist_scnprintf(m->buf + m->count, m->size - m->count,
 					task->cpus_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed:\t");
-	m->count += nodemask_scnprintf(m->buf + m->count, m->size - m->count,
-					task->mems_allowed);
+	seq_nodemask(m, &task->mems_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed_list:\t");
 	m->count += nodelist_scnprintf(m->buf + m->count, m->size - m->count,
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
vt8623fb-fix-kernel-oops.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
seq_file-add-seq_cpumask-seq_nodemask.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
devpts-switch-to-ida-checkpatch-fixes.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

