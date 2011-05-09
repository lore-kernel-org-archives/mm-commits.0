From: akpm@linux-foundation.org
Subject: [to-be-updated] proc-allocate-storage-for-numa_maps-statistics-once.patch removed from -mm tree
Date: Mon, 09 May 2011 13:07:50 -0700
Message-ID: <201105092007.p49K7oVr014944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316Ab1EIUH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 16:07:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     proc: allocate storage for numa_maps statistics once
has been removed from the -mm tree.  Its filename was
     proc-allocate-storage-for-numa_maps-statistics-once.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: allocate storage for numa_maps statistics once
From: Stephen Wilson <wilsons@start.ca>

In show_numa_map() we collect statistics into a numa_maps structure. 
Since the number of NUMA nodes can be very large, this structure is not a
candidate for stack allocation.

Instead of going thru a kmalloc()+kfree() cycle each time show_numa_map()
is invoked, perform the allocation just once when /proc/pid/numa_maps is
opened.

Performing the allocation when numa_maps is opened, and thus before a
reference to the target tasks mm is taken, eliminates a potential
stalemate condition in the oom-killer as originally described by Hugh
Dickins:

  ... imagine what happens if the system is out of memory, and the mm
  we're looking at is selected for killing by the OOM killer: while
  we wait in __get_free_page for more memory, no memory is freed
  from the selected mm because it cannot reach exit_mmap while we hold
  that reference.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-allocate-storage-for-numa_maps-statistics-once fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-allocate-storage-for-numa_maps-statistics-once
+++ a/fs/proc/task_mmu.c
@@ -868,6 +868,11 @@ struct numa_maps {
 	unsigned long node[MAX_NUMNODES];
 };
 
+struct numa_maps_private {
+	struct proc_maps_private proc_maps;
+	struct numa_maps md;
+};
+
 static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty)
 {
 	int count = page_mapcount(page);
@@ -949,9 +954,10 @@ static int gather_hugetbl_stats(pte_t *p
  */
 static int show_numa_map(struct seq_file *m, void *v)
 {
-	struct proc_maps_private *priv = m->private;
+	struct numa_maps_private *numa_priv = m->private;
+	struct proc_maps_private *proc_priv = &numa_priv->proc_maps;
 	struct vm_area_struct *vma = v;
-	struct numa_maps *md;
+	struct numa_maps *md = &numa_priv->md;
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
 	struct mm_walk walk = {};
@@ -962,16 +968,15 @@ static int show_numa_map(struct seq_file
 	if (!mm)
 		return 0;
 
-	md = kzalloc(sizeof(struct numa_maps), GFP_KERNEL);
-	if (!md)
-		return 0;
+	/* Ensure we start with an empty set of numa_maps statistics. */
+	memset(md, 0, sizeof(*md));
 
 	walk.hugetlb_entry = gather_hugetbl_stats;
 	walk.pte_entry = gather_pte_stats;
 	walk.private = md;
 	walk.mm = mm;
 
-	pol = get_vma_policy(priv->task, vma, vma->vm_start);
+	pol = get_vma_policy(proc_priv->task, vma, vma->vm_start);
 	mpol_to_str(buffer, sizeof(buffer), pol, 0);
 	mpol_cond_put(pol);
 
@@ -1018,12 +1023,12 @@ static int show_numa_map(struct seq_file
 			seq_printf(m, " N%d=%lu", n, md->node[n]);
 out:
 	seq_putc(m, '\n');
-	kfree(md);
 
 	if (m->count < m->size)
-		m->version = (vma != priv->tail_vma) ? vma->vm_start : 0;
+		m->version = (vma != proc_priv->tail_vma) ? vma->vm_start : 0;
 	return 0;
 }
+
 static const struct seq_operations proc_pid_numa_maps_op = {
         .start  = m_start,
         .next   = m_next,
@@ -1033,7 +1038,20 @@ static const struct seq_operations proc_
 
 static int numa_maps_open(struct inode *inode, struct file *file)
 {
-	return do_maps_open(inode, file, &proc_pid_numa_maps_op);
+	struct numa_maps_private *priv;
+	int ret = -ENOMEM;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv) {
+		priv->proc_maps.pid = proc_pid(inode);
+		ret = seq_open(file, &proc_pid_numa_maps_op);
+		if (!ret) {
+			struct seq_file *m = file->private_data;
+			m->private = priv;
+		} else {
+			kfree(priv);
+		}
+	}
+	return ret;
 }
 
 const struct file_operations proc_numa_maps_operations = {
_

Patches currently in -mm which might be from wilsons@start.ca are

proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch

