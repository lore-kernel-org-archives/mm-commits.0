Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FAE1AF0BB
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 23:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746746203; cv=none; b=NhF/u1yO/WB+rDoEEJ94RVUb/a60pnh+t4NZJ7t4sXjMAVgVMEHUd/UkatbfQQ4YtXIK9dW/RxfwYpOFECoDX7tnY7KluJQmtPxz9QfKoo2Ak71E9CvvarPTymRUkPV+6M01bad4fgFwF/PHk6rGoWyBn/OIHQ48L3mRiqo7f8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746746203; c=relaxed/simple;
	bh=UfhEShHVb7T23BBmExiNGFtQRebO6FjqwpQBlCdqWD0=;
	h=Date:To:From:Subject:Message-Id; b=a8oyAdmMutA6mQXO5efFprC/Cby58RuUZcdO0aNce/WmxlIsO1TAdnP/4jYatqSEXTeyBlWrwE5d+HJIKydFBptT1ypl+2fqKpjlpN+ghuG1YDU7XSqQq0pP7vYeOxzwC3yyDD3zS2B44WHJ4wcSTFkLiNF1LDDu5nSl5NUXAJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qmkjLB1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qmkjLB1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FCEC4CEE7;
	Thu,  8 May 2025 23:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746746202;
	bh=UfhEShHVb7T23BBmExiNGFtQRebO6FjqwpQBlCdqWD0=;
	h=Date:To:From:Subject:From;
	b=qmkjLB1NcKQBFtFMxwFgDZ6lviq7VdsT7tdxk37ja5Ov4MEyWk6C2qAzJTVxo4mHS
	 cDGIhoj41idCPaSxA8kEsfBa2I0OwnAMoD4XplBDb10qfXaCrYYi3/fVmGZeK0hVIz
	 p5iD9f7Xv2BIiCBhUMe+j6axXfTrbGRPq4k3mjmI=
Date: Thu, 08 May 2025 16:16:41 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,edumazet@google.com,akpm@linux-foundation.org,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-data-race-in-show_numa_info.patch added to mm-new branch
Message-Id: <20250508231642.55FCEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: fix data race in show_numa_info()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-fix-data-race-in-show_numa_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-data-race-in-show_numa_info.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jeongjun Park <aha310510@gmail.com>
Subject: mm/vmalloc: fix data race in show_numa_info()
Date: Fri, 9 May 2025 01:56:20 +0900

The following data-race was found in show_numa_info():

==================================================================
BUG: KCSAN: data-race in vmalloc_info_show / vmalloc_info_show

read to 0xffff88800971fe30 of 4 bytes by task 8289 on cpu 0:
 show_numa_info mm/vmalloc.c:4936 [inline]
 vmalloc_info_show+0x5a8/0x7e0 mm/vmalloc.c:5016
 seq_read_iter+0x373/0xb40 fs/seq_file.c:230
 proc_reg_read_iter+0x11e/0x170 fs/proc/inode.c:299
....

write to 0xffff88800971fe30 of 4 bytes by task 8287 on cpu 1:
 show_numa_info mm/vmalloc.c:4934 [inline]
 vmalloc_info_show+0x38f/0x7e0 mm/vmalloc.c:5016
 seq_read_iter+0x373/0xb40 fs/seq_file.c:230
 proc_reg_read_iter+0x11e/0x170 fs/proc/inode.c:299
....

value changed: 0x0000008f -> 0x00000000
==================================================================

According to this report,there is a read/write data-race because
m->private is accessible to multiple CPUs.  To fix this, instead of
allocating the heap in proc_vmalloc_init() and passing the heap address to
m->private, vmalloc_info_show() should allocate the heap.

Link: https://lkml.kernel.org/r/20250508165620.15321-1-aha310510@gmail.com
Fixes: 8e1d743f2c26 ("mm: vmalloc: support multiple nodes in vmallocinfo")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   63 +++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-data-race-in-show_numa_info
+++ a/mm/vmalloc.c
@@ -3109,7 +3109,7 @@ static void clear_vm_uninitialized_flag(
 	/*
 	 * Before removing VM_UNINITIALIZED,
 	 * we should make sure that vm has proper values.
-	 * Pair with smp_rmb() in show_numa_info().
+	 * Pair with smp_rmb() in vread_iter() and vmalloc_info_show().
 	 */
 	smp_wmb();
 	vm->flags &= ~VM_UNINITIALIZED;
@@ -4939,28 +4939,29 @@ bool vmalloc_dump_obj(void *object)
 #endif
 
 #ifdef CONFIG_PROC_FS
-static void show_numa_info(struct seq_file *m, struct vm_struct *v)
-{
-	if (IS_ENABLED(CONFIG_NUMA)) {
-		unsigned int nr, *counters = m->private;
-		unsigned int step = 1U << vm_area_page_order(v);
 
-		if (!counters)
-			return;
+/*
+ * Print number of pages allocated on each memory node.
+ *
+ * This function can only be called if CONFIG_NUMA is enabled
+ * and VM_UNINITIALIZED bit in v->flags is disabled.
+ */
+static void show_numa_info(struct seq_file *m, struct vm_struct *v,
+				 unsigned int *counters)
+{
+	unsigned int nr;
+	unsigned int step = 1U << vm_area_page_order(v);
 
-		if (v->flags & VM_UNINITIALIZED)
-			return;
-		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-		smp_rmb();
+	if (!counters)
+		return;
 
-		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
+	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-		for (nr = 0; nr < v->nr_pages; nr += step)
-			counters[page_to_nid(v->pages[nr])] += step;
-		for_each_node_state(nr, N_HIGH_MEMORY)
-			if (counters[nr])
-				seq_printf(m, " N%u=%u", nr, counters[nr]);
-	}
+	for (nr = 0; nr < v->nr_pages; nr += step)
+		counters[page_to_nid(v->pages[nr])] += step;
+	for_each_node_state(nr, N_HIGH_MEMORY)
+		if (counters[nr])
+			seq_printf(m, " N%u=%u", nr, counters[nr]);
 }
 
 static void show_purge_info(struct seq_file *m)
@@ -4984,6 +4985,10 @@ static int vmalloc_info_show(struct seq_
 	struct vmap_node *vn;
 	struct vmap_area *va;
 	struct vm_struct *v;
+	unsigned int *counters;
+
+	if (IS_ENABLED(CONFIG_NUMA))
+		counters = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
 
 	for_each_vmap_node(vn) {
 		spin_lock(&vn->busy.lock);
@@ -4998,6 +5003,11 @@ static int vmalloc_info_show(struct seq_
 			}
 
 			v = va->vm;
+			if (v->flags & VM_UNINITIALIZED)
+				continue;
+
+			/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+			smp_rmb();
 
 			seq_printf(m, "0x%pK-0x%pK %7ld",
 				v->addr, v->addr + v->size, v->size);
@@ -5032,7 +5042,9 @@ static int vmalloc_info_show(struct seq_
 			if (is_vmalloc_addr(v->pages))
 				seq_puts(m, " vpages");
 
-			show_numa_info(m, v);
+			if (IS_ENABLED(CONFIG_NUMA))
+				show_numa_info(m, v, counters);
+
 			seq_putc(m, '\n');
 		}
 		spin_unlock(&vn->busy.lock);
@@ -5042,19 +5054,14 @@ static int vmalloc_info_show(struct seq_
 	 * As a final step, dump "unpurged" areas.
 	 */
 	show_purge_info(m);
+	if (IS_ENABLED(CONFIG_NUMA))
+		kfree(counters);
 	return 0;
 }
 
 static int __init proc_vmalloc_init(void)
 {
-	void *priv_data = NULL;
-
-	if (IS_ENABLED(CONFIG_NUMA))
-		priv_data = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
-
-	proc_create_single_data("vmallocinfo",
-		0400, NULL, vmalloc_info_show, priv_data);
-
+	proc_create_single("vmallocinfo", 0400, NULL, vmalloc_info_show);
 	return 0;
 }
 module_init(proc_vmalloc_init);
_

Patches currently in -mm which might be from aha310510@gmail.com are

mm-vmalloc-fix-data-race-in-show_numa_info.patch
ipc-fix-to-protect-ipcs-lookups-using-rcu.patch

