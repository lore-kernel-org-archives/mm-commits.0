From: akpm@linux-foundation.org
Subject: + fs-proc-remove-priv-argument-from-is_stack.patch added to -mm
 tree
Date: Fri, 28 Jul 2017 14:47:53 -0700
Message-ID: <597bb109.XAb5bl7j/eDqCvRt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55092 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752860AbdG1Vrx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2017 17:47:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, luto@amacapital.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, proc: remove priv argument from is_stack
has been added to the -mm tree.  Its filename is
     fs-proc-remove-priv-argument-from-is_stack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-remove-priv-argument-from-is_stack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-remove-priv-argument-from-is_stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: fs, proc: remove priv argument from is_stack

b18cb64ead40 ("fs/proc: Stop trying to report thread stacks") removed the
priv parameter user in is_stack so the argument is redundant.  Drop it.

Link: http://lkml.kernel.org/r/20170728075833.7241-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c   |    7 +++----
 fs/proc/task_nommu.c |    5 ++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-remove-priv-argument-from-is_stack fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-remove-priv-argument-from-is_stack
+++ a/fs/proc/task_mmu.c
@@ -266,8 +266,7 @@ static int do_maps_open(struct inode *in
  * Indicate if the VMA is a stack for the given task; for
  * /proc/PID/maps that is the stack of the main task.
  */
-static int is_stack(struct proc_maps_private *priv,
-		    struct vm_area_struct *vma)
+static int is_stack(struct vm_area_struct *vma)
 {
 	/*
 	 * We make no effort to guess what a given thread considers to be
@@ -341,7 +340,7 @@ show_map_vma(struct seq_file *m, struct
 			goto done;
 		}
 
-		if (is_stack(priv, vma))
+		if (is_stack(vma))
 			name = "[stack]";
 	}
 
@@ -1685,7 +1684,7 @@ static int show_numa_map(struct seq_file
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

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch
treewide-remove-gfp_temporary-allocation-flag.patch
fs-proc-remove-priv-argument-from-is_stack.patch

