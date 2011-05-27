From: akpm@linux-foundation.org
Subject: [merged] proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:44 -0700
Message-ID: <201105271956.p4RJuoiM017601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757052Ab1E0T5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com, bookjovi@gmail.com, hughd@google.com, wilsons@start.ca, mm-commits@vger.kernel.org


The patch titled
     proc: put check_mem_permission after __get_free_page in mem_write
has been removed from the -mm tree.  Its filename was
     proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: put check_mem_permission after __get_free_page in mem_write
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

It whould be better if put check_mem_permission after __get_free_page in
mem_write, to be same as function mem_read.

Hugh Dickins explained the reason.

    check_mem_permission gets a reference to the mm.  If we __get_free_page
    after check_mem_permission, imagine what happens if the system is out
    of memory, and the mm we're looking at is selected for killing by the
    OOM killer: while we wait in __get_free_page for more memory, no memory
    is freed from the selected mm because it cannot reach exit_mmap while
    we hold that reference.

Reported-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Stephen Wilson <wilsons@start.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/proc/base.c~proc-put-check_mem_permission-after-__get_free_page-in-mem_write fs/proc/base.c
--- a/fs/proc/base.c~proc-put-check_mem_permission-after-__get_free_page-in-mem_write
+++ a/fs/proc/base.c
@@ -894,20 +894,20 @@ static ssize_t mem_write(struct file * f
 	if (!task)
 		goto out_no_task;
 
+	copied = -ENOMEM;
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page)
+		goto out_task;
+
 	mm = check_mem_permission(task);
 	copied = PTR_ERR(mm);
 	if (IS_ERR(mm))
-		goto out_task;
+		goto out_free;
 
 	copied = -EIO;
 	if (file->private_data != (void *)((long)current->self_exec_id))
 		goto out_mm;
 
-	copied = -ENOMEM;
-	page = (char *)__get_free_page(GFP_TEMPORARY);
-	if (!page)
-		goto out_mm;
-
 	copied = 0;
 	while (count > 0) {
 		int this_len, retval;
@@ -929,9 +929,11 @@ static ssize_t mem_write(struct file * f
 		count -= retval;			
 	}
 	*ppos = dst;
-	free_page((unsigned long) page);
+
 out_mm:
 	mmput(mm);
+out_free:
+	free_page((unsigned long) page);
 out_task:
 	put_task_struct(task);
 out_no_task:
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

