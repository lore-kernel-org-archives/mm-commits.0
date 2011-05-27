From: akpm@linux-foundation.org
Subject: [merged] proc-fix-pagemap_read-error-case.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:47 -0700
Message-ID: <201105271956.p4RJurA8017604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1E0UOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:14:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com, bookjovi@gmail.com, hughd@google.com, wilsons@start.ca, mm-commits@vger.kernel.org


The patch titled
     proc: fix pagemap_read() error case
has been removed from the -mm tree.  Its filename was
     proc-fix-pagemap_read-error-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: fix pagemap_read() error case
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, pagemap_read() has three error and/or corner case handling
mistake.

 (1) If ppos parameter is wrong, mm refcount will be leak.
 (2) If count parameter is 0, mm refcount will be leak too.
 (3) If the current task is sleeping in kmalloc() and the system
     is out of memory and oom-killer kill the proc associated task,
     mm_refcount prevent the task free its memory. then system may
     hang up.

<Quote Hugh's explain why we shold call kmalloc() before get_mm()>

  check_mem_permission gets a reference to the mm.  If we
  __get_free_page after check_mem_permission, imagine what happens if the
  system is out of memory, and the mm we're looking at is selected for
  killing by the OOM killer: while we wait in __get_free_page for more
  memory, no memory is freed from the selected mm because it cannot reach
  exit_mmap while we hold that reference.

This patch fixes the above three.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jovi Zhang <bookjovi@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Stephen Wilson <wilsons@start.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-fix-pagemap_read-error-case fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-fix-pagemap_read-error-case
+++ a/fs/proc/task_mmu.c
@@ -771,18 +771,12 @@ static ssize_t pagemap_read(struct file 
 	if (!task)
 		goto out;
 
-	mm = mm_for_maps(task);
-	ret = PTR_ERR(mm);
-	if (!mm || IS_ERR(mm))
-		goto out_task;
-
 	ret = -EINVAL;
 	/* file position must be aligned */
 	if ((*ppos % PM_ENTRY_BYTES) || (count % PM_ENTRY_BYTES))
 		goto out_task;
 
 	ret = 0;
-
 	if (!count)
 		goto out_task;
 
@@ -790,7 +784,12 @@ static ssize_t pagemap_read(struct file 
 	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
 	ret = -ENOMEM;
 	if (!pm.buffer)
-		goto out_mm;
+		goto out_task;
+
+	mm = mm_for_maps(task);
+	ret = PTR_ERR(mm);
+	if (!mm || IS_ERR(mm))
+		goto out_free;
 
 	pagemap_walk.pmd_entry = pagemap_pte_range;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
@@ -833,7 +832,7 @@ static ssize_t pagemap_read(struct file 
 		len = min(count, PM_ENTRY_BYTES * pm.pos);
 		if (copy_to_user(buf, pm.buffer, len)) {
 			ret = -EFAULT;
-			goto out_free;
+			goto out_mm;
 		}
 		copied += len;
 		buf += len;
@@ -843,10 +842,10 @@ static ssize_t pagemap_read(struct file 
 	if (!ret || ret == PM_END_OF_BUFFER)
 		ret = copied;
 
-out_free:
-	kfree(pm.buffer);
 out_mm:
 	mmput(mm);
+out_free:
+	kfree(pm.buffer);
 out_task:
 	put_task_struct(task);
 out:
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

