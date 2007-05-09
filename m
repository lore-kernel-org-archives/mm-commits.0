From: akpm@linux-foundation.org
Subject: - proc-maps-protection.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:21 -0700
Message-ID: <200705090246.l492kLBi008841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755245AbXEICqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees@outflux.net, arjan@infradead.org, mm-commits@vger.kernel.org


The patch titled
     proc: maps protection
has been removed from the -mm tree.  Its filename was
     proc-maps-protection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: proc: maps protection
From: Kees Cook <kees@outflux.net>

The /proc/pid/ "maps", "smaps", and "numa_maps" files contain sensitive
information about the memory location and usage of processes.  Issues:

- maps should not be world-readable, especially if programs expect any
  kind of ASLR protection from local attackers.
- maps cannot just be 0400 because "-D_FORTIFY_SOURCE=2 -O2" makes glibc
  check the maps when %n is in a *printf call, and a setuid(getuid())
  process wouldn't be able to read its own maps file.  (For reference
  see http://lkml.org/lkml/2006/1/22/150)
- a system-wide toggle is needed to allow prior behavior in the case of
  non-root applications that depend on access to the maps contents.

This change implements a check using "ptrace_may_attach" before allowing
access to read the maps contents.  To control this protection, the new knob
/proc/sys/kernel/maps_protect has been added, with corresponding updates to
the procfs documentation.

[akpm@linux-foundation.org: build fixes]
[akpm@linux-foundation.org: New sysctl numbers are old hat]
Signed-off-by: Kees Cook <kees@outflux.net>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS                            |    2 +-
 Documentation/filesystems/proc.txt |    7 +++++++
 fs/proc/base.c                     |    4 ++++
 fs/proc/internal.h                 |    2 ++
 fs/proc/task_mmu.c                 |   17 ++++++++++++++++-
 fs/proc/task_nommu.c               |    7 +++++++
 kernel/sysctl.c                    |   11 +++++++++++
 7 files changed, 48 insertions(+), 2 deletions(-)

diff -puN CREDITS~proc-maps-protection CREDITS
--- a/CREDITS~proc-maps-protection
+++ a/CREDITS
@@ -661,7 +661,7 @@ N: Kees Cook
 E: kees@outflux.net
 W: http://outflux.net/
 P: 1024D/17063E6D 9FA3 C49C 23C9 D1BC 2E30  1975 1FFF 4BA9 1706 3E6D
-D: Minor updates to SCSI code for the Communications type
+D: Minor updates to SCSI types, added /proc/pid/maps protection
 S: (ask for current address)
 S: USA
 
diff -puN Documentation/filesystems/proc.txt~proc-maps-protection Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-maps-protection
+++ a/Documentation/filesystems/proc.txt
@@ -1138,6 +1138,13 @@ determine whether or not they are still 
 Because the NMI watchdog shares registers with oprofile, by disabling the NMI
 watchdog, oprofile may have more registers to utilize.
 
+maps_protect
+------------
+
+Enables/Disables the protection of the per-process proc entries "maps" and
+"smaps".  When enabled, the contents of these files are visible only to
+readers that are allowed to ptrace() the given process.
+
 
 2.4 /proc/sys/vm - The virtual memory subsystem
 -----------------------------------------------
diff -puN fs/proc/base.c~proc-maps-protection fs/proc/base.c
--- a/fs/proc/base.c~proc-maps-protection
+++ a/fs/proc/base.c
@@ -64,6 +64,7 @@
 #include <linux/smp_lock.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
+#include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
@@ -123,6 +124,9 @@ struct pid_entry {
 		NULL, &proc_info_file_operations,	\
 		{ .proc_read = &proc_##OTYPE } )
 
+int maps_protect;
+EXPORT_SYMBOL(maps_protect);
+
 static struct fs_struct *get_fs_struct(struct task_struct *task)
 {
 	struct fs_struct *fs;
diff -puN fs/proc/internal.h~proc-maps-protection fs/proc/internal.h
--- a/fs/proc/internal.h~proc-maps-protection
+++ a/fs/proc/internal.h
@@ -37,6 +37,8 @@ do {						\
 extern int nommu_vma_show(struct seq_file *, struct vm_area_struct *);
 #endif
 
+extern int maps_protect;
+
 extern void create_seq_entry(char *name, mode_t mode, const struct file_operations *f);
 extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
 extern int proc_tid_stat(struct task_struct *,  char *);
diff -puN fs/proc/task_mmu.c~proc-maps-protection fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-maps-protection
+++ a/fs/proc/task_mmu.c
@@ -3,6 +3,7 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/highmem.h>
+#include <linux/ptrace.h>
 #include <linux/pagemap.h>
 #include <linux/mempolicy.h>
 
@@ -142,6 +143,9 @@ static int show_map_internal(struct seq_
 	dev_t dev = 0;
 	int len;
 
+	if (maps_protect && !ptrace_may_attach(task))
+		return -EACCES;
+
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
@@ -512,11 +516,22 @@ const struct file_operations proc_maps_o
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
 
+static int show_numa_map_checked(struct seq_file *m, void *v)
+{
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+
+	if (maps_protect && !ptrace_may_attach(task))
+		return -EACCES;
+
+	return show_numa_map(m, v);
+}
+
 static struct seq_operations proc_pid_numa_maps_op = {
         .start  = m_start,
         .next   = m_next,
         .stop   = m_stop,
-        .show   = show_numa_map
+        .show   = show_numa_map_checked
 };
 
 static int numa_maps_open(struct inode *inode, struct file *file)
diff -puN fs/proc/task_nommu.c~proc-maps-protection fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-maps-protection
+++ a/fs/proc/task_nommu.c
@@ -2,6 +2,7 @@
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/mount.h>
+#include <linux/ptrace.h>
 #include <linux/seq_file.h>
 #include "internal.h"
 
@@ -143,6 +144,12 @@ out:
 static int show_map(struct seq_file *m, void *_vml)
 {
 	struct vm_list_struct *vml = _vml;
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+
+	if (maps_protect && !ptrace_may_attach(task))
+		return -EACCES;
+
 	return nommu_vma_show(m, vml->vma);
 }
 
diff -puN kernel/sysctl.c~proc-maps-protection kernel/sysctl.c
--- a/kernel/sysctl.c~proc-maps-protection
+++ a/kernel/sysctl.c
@@ -76,6 +76,7 @@ extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
+extern int maps_protect;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -603,6 +604,16 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_PROC_FS
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "maps_protect",
+		.data           = &maps_protect,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+#endif
 
 	{ .ctl_name = 0 }
 };
_

Patches currently in -mm which might be from kees@outflux.net are

origin.patch
