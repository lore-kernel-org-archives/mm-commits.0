From: akpm@linux-foundation.org
Subject: [merged] fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:34:32 -0700
Message-ID: <53960c48.+Hj5c5TiOat+i5h7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaFITec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:34:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, fabf@skynet.be

Subject: [merged] fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch removed from -mm tree
To: fabf@skynet.be,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:34:32 -0700


The patch titled
     Subject: fs/proc/task_mmu.c: replace seq_printf by seq_puts
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/proc/task_mmu.c: replace seq_printf by seq_puts

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-replace-seq_printf-by-seq_puts fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-replace-seq_printf-by-seq_puts
+++ a/fs/proc/task_mmu.c
@@ -1418,10 +1418,10 @@ static int show_numa_map(struct seq_file
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
 	if (file) {
-		seq_printf(m, " file=");
+		seq_puts(m, " file=");
 		seq_path(m, &file->f_path, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
-		seq_printf(m, " heap");
+		seq_puts(m, " heap");
 	} else {
 		pid_t tid = vm_is_stack(task, vma, is_pid);
 		if (tid != 0) {
@@ -1431,14 +1431,14 @@ static int show_numa_map(struct seq_file
 			 */
 			if (!is_pid || (vma->vm_start <= mm->start_stack &&
 			    vma->vm_end >= mm->start_stack))
-				seq_printf(m, " stack");
+				seq_puts(m, " stack");
 			else
 				seq_printf(m, " stack:%d", tid);
 		}
 	}
 
 	if (is_vm_hugetlb_page(vma))
-		seq_printf(m, " huge");
+		seq_puts(m, " huge");
 
 	walk_page_range(vma->vm_start, vma->vm_end, &walk);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

