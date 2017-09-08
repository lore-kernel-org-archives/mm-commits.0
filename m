From: akpm@linux-foundation.org
Subject: [patch 049/126] fs, proc: remove priv argument from
 is_stack
Date: Fri, 08 Sep 2017 16:13:35 -0700
Message-ID: <20170908231335.kkIVeuh5H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757173AbdIHXNh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:13:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, luto@amacapital.net, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Michal Hocko <mhocko@suse.com>
Subject: fs, proc: remove priv argument from is_stack

b18cb64ead40 ("fs/proc: Stop trying to report thread stacks") removed the
priv parameter user in is_stack so the argument is redundant.  Drop it.

[arnd@arndb.de: remove unused variable]
  Link: http://lkml.kernel.org/r/20170801120150.1520051-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/20170728075833.7241-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c   |    8 +++-----
 fs/proc/task_nommu.c |    5 ++---
 2 files changed, 5 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-remove-priv-argument-from-is_stack fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-remove-priv-argument-from-is_stack
+++ a/fs/proc/task_mmu.c
@@ -268,8 +268,7 @@ static int do_maps_open(struct inode *in
  * Indicate if the VMA is a stack for the given task; for
  * /proc/PID/maps that is the stack of the main task.
  */
-static int is_stack(struct proc_maps_private *priv,
-		    struct vm_area_struct *vma)
+static int is_stack(struct vm_area_struct *vma)
 {
 	/*
 	 * We make no effort to guess what a given thread considers to be
@@ -302,7 +301,6 @@ show_map_vma(struct seq_file *m, struct
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
-	struct proc_maps_private *priv = m->private;
 	vm_flags_t flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
@@ -350,7 +348,7 @@ show_map_vma(struct seq_file *m, struct
 			goto done;
 		}
 
-		if (is_stack(priv, vma))
+		if (is_stack(vma))
 			name = "[stack]";
 	}
 
@@ -1768,7 +1766,7 @@ static int show_numa_map(struct seq_file
 		seq_file_path(m, file, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_puts(m, " heap");
-	} else if (is_stack(proc_priv, vma)) {
+	} else if (is_stack(vma)) {
 		seq_puts(m, " stack");
 	}
 
diff -puN fs/proc/task_nommu.c~fs-proc-remove-priv-argument-from-is_stack fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~fs-proc-remove-priv-argument-from-is_stack
+++ a/fs/proc/task_nommu.c
@@ -125,8 +125,7 @@ unsigned long task_statm(struct mm_struc
 	return size;
 }
 
-static int is_stack(struct proc_maps_private *priv,
-		    struct vm_area_struct *vma)
+static int is_stack(struct vm_area_struct *vma)
 {
 	struct mm_struct *mm = vma->vm_mm;
 
@@ -178,7 +177,7 @@ static int nommu_vma_show(struct seq_fil
 	if (file) {
 		seq_pad(m, ' ');
 		seq_file_path(m, file, "");
-	} else if (mm && is_stack(priv, vma)) {
+	} else if (mm && is_stack(vma)) {
 		seq_pad(m, ' ');
 		seq_printf(m, "[stack]");
 	}
_
