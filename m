From: akpm@linux-foundation.org
Subject: - cpuset-use-seq_cpumask-seq_nodemask.patch removed from -mm tree
Date: Thu, 16 Oct 2008 12:54:59 -0700
Message-ID: <200810161954.m9GJsx8A010587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbYJPTzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, pj@sgi.com, travis@sgi.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpuset: use seq_cpumask(), seq_nodemask()
has been removed from the -mm tree.  Its filename was
     cpuset-use-seq_cpumask-seq_nodemask.patch

This patch was dropped because an updated version will be merged

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
@@ -2444,16 +2444,14 @@ const struct file_operations proc_cpuset
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
alpha-notify_cpu_starting-compile-fixlet.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
sysctl-simplify-strategy.patch
git-vfs.patch
tags-skip-in-filenames.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
seq_file-dont-call-bitmap_scnprintf_len.patch
seq_file-add-seq_cpumask_list-seq_nodemask_list.patch
cpuset-use-seq_mask_-to-print-masks.patch
bitmask-remove-bitmap_scnprintf_len.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

