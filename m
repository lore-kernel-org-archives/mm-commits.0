From: akpm@linux-foundation.org
Subject: - mspec-handle-shrinking-virtual-memory-areas.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:30 -0700
Message-ID: <200709202115.l8KLFURG002913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbXITVQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cpw@sgi.com, jes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mspec: handle shrinking virtual memory areas
has been removed from the -mm tree.  Its filename was
     mspec-handle-shrinking-virtual-memory-areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mspec: handle shrinking virtual memory areas
From: Cliff Wickman <cpw@sgi.com>

The shrinking of a virtual memory area that is mmap(2)'d to a memory
special file (device drivers/char/mspec.c) can cause a panic.

If the mapped size of the vma (vm_area_struct) is very large, mspec allocates
a large vma_data structure with vmalloc(). But such a vma can be shrunk by
an munmap(2).  The current driver uses the current size of each vma to
deduce whether its vma_data structure was allocated by kmalloc() or vmalloc().
So if the vma was shrunk it appears to have been allocated by kmalloc(),
and mspec attempts to free it with kfree().  This results in a panic.

This patch avoids the panic (by preserving the type of the allocation) and
also makes mspec work correctly as the vma is split into pieces by the
munmap(2)'s.

All vma's derived from such a split vma share the same vma_data structure that
represents all the pages mapped into this set of vma's.  The mpec driver
must be made capable of using the right portion of the structure for each
member vma.  In other words, it must index into the array of page addresses
using the portion of the array that represents the current vma. This is
enabled by storing the vma group's vm_start in the vma_data structure.

The shared vma_data's are not protected by mm->mmap_sem in the fork() case
so the reference count is left as atomic_t.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mspec.c |   69 ++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 21 deletions(-)

diff -puN drivers/char/mspec.c~mspec-handle-shrinking-virtual-memory-areas drivers/char/mspec.c
--- a/drivers/char/mspec.c~mspec-handle-shrinking-virtual-memory-areas
+++ a/drivers/char/mspec.c
@@ -67,7 +67,7 @@
 /*
  * Page types allocated by the device.
  */
-enum {
+enum mspec_page_type {
 	MSPEC_FETCHOP = 1,
 	MSPEC_CACHED,
 	MSPEC_UNCACHED
@@ -83,15 +83,25 @@ static int is_sn2;
  * One of these structures is allocated when an mspec region is mmaped. The
  * structure is pointed to by the vma->vm_private_data field in the vma struct.
  * This structure is used to record the addresses of the mspec pages.
+ * This structure is shared by all vma's that are split off from the
+ * original vma when split_vma()'s are done.
+ *
+ * The refcnt is incremented atomically because mm->mmap_sem does not
+ * protect in fork case where multiple tasks share the vma_data.
  */
 struct vma_data {
 	atomic_t refcnt;	/* Number of vmas sharing the data. */
-	spinlock_t lock;	/* Serialize access to the vma. */
+	spinlock_t lock;	/* Serialize access to this structure. */
 	int count;		/* Number of pages allocated. */
-	int type;		/* Type of pages allocated. */
+	enum mspec_page_type type; /* Type of pages allocated. */
+	int flags;		/* See VMD_xxx below. */
+	unsigned long vm_start;	/* Original (unsplit) base. */
+	unsigned long vm_end;	/* Original (unsplit) end. */
 	unsigned long maddr[0];	/* Array of MSPEC addresses. */
 };
 
+#define VMD_VMALLOCED 0x1	/* vmalloc'd rather than kmalloc'd */
+
 /* used on shub2 to clear FOP cache in the HUB */
 static unsigned long scratch_page[MAX_NUMNODES];
 #define SH2_AMO_CACHE_ENTRIES	4
@@ -129,8 +139,8 @@ mspec_zero_block(unsigned long addr, int
  * mspec_open
  *
  * Called when a device mapping is created by a means other than mmap
- * (via fork, etc.).  Increments the reference count on the underlying
- * mspec data so it is not freed prematurely.
+ * (via fork, munmap, etc.).  Increments the reference count on the
+ * underlying mspec data so it is not freed prematurely.
  */
 static void
 mspec_open(struct vm_area_struct *vma)
@@ -151,34 +161,44 @@ static void
 mspec_close(struct vm_area_struct *vma)
 {
 	struct vma_data *vdata;
-	int i, pages, result, vdata_size;
+	int index, last_index, result;
+	unsigned long my_page;
 
 	vdata = vma->vm_private_data;
-	if (!atomic_dec_and_test(&vdata->refcnt))
-		return;
 
-	pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-	vdata_size = sizeof(struct vma_data) + pages * sizeof(long);
-	for (i = 0; i < pages; i++) {
-		if (vdata->maddr[i] == 0)
+	BUG_ON(vma->vm_start < vdata->vm_start || vma->vm_end > vdata->vm_end);
+
+	spin_lock(&vdata->lock);
+	index = (vma->vm_start - vdata->vm_start) >> PAGE_SHIFT;
+	last_index = (vma->vm_end - vdata->vm_start) >> PAGE_SHIFT;
+	for (; index < last_index; index++) {
+		if (vdata->maddr[index] == 0)
 			continue;
 		/*
 		 * Clear the page before sticking it back
 		 * into the pool.
 		 */
-		result = mspec_zero_block(vdata->maddr[i], PAGE_SIZE);
+		my_page = vdata->maddr[index];
+		vdata->maddr[index] = 0;
+		spin_unlock(&vdata->lock);
+		result = mspec_zero_block(my_page, PAGE_SIZE);
 		if (!result)
-			uncached_free_page(vdata->maddr[i]);
+			uncached_free_page(my_page);
 		else
 			printk(KERN_WARNING "mspec_close(): "
 			       "failed to zero page %i\n",
 			       result);
+		spin_lock(&vdata->lock);
 	}
+	spin_unlock(&vdata->lock);
 
-	if (vdata_size <= PAGE_SIZE)
-		kfree(vdata);
-	else
+	if (!atomic_dec_and_test(&vdata->refcnt))
+		return;
+
+	if (vdata->flags & VMD_VMALLOCED)
 		vfree(vdata);
+	else
+		kfree(vdata);
 }
 
 
@@ -195,7 +215,8 @@ mspec_nopfn(struct vm_area_struct *vma, 
 	int index;
 	struct vma_data *vdata = vma->vm_private_data;
 
-	index = (address - vma->vm_start) >> PAGE_SHIFT;
+	BUG_ON(address < vdata->vm_start || address >= vdata->vm_end);
+	index = (address - vdata->vm_start) >> PAGE_SHIFT;
 	maddr = (volatile unsigned long) vdata->maddr[index];
 	if (maddr == 0) {
 		maddr = uncached_alloc_page(numa_node_id());
@@ -237,10 +258,11 @@ static struct vm_operations_struct mspec
  * underlying pages.
  */
 static int
-mspec_mmap(struct file *file, struct vm_area_struct *vma, int type)
+mspec_mmap(struct file *file, struct vm_area_struct *vma,
+					enum mspec_page_type type)
 {
 	struct vma_data *vdata;
-	int pages, vdata_size;
+	int pages, vdata_size, flags = 0;
 
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
@@ -255,12 +277,17 @@ mspec_mmap(struct file *file, struct vm_
 	vdata_size = sizeof(struct vma_data) + pages * sizeof(long);
 	if (vdata_size <= PAGE_SIZE)
 		vdata = kmalloc(vdata_size, GFP_KERNEL);
-	else
+	else {
 		vdata = vmalloc(vdata_size);
+		flags = VMD_VMALLOCED;
+	}
 	if (!vdata)
 		return -ENOMEM;
 	memset(vdata, 0, vdata_size);
 
+	vdata->vm_start = vma->vm_start;
+	vdata->vm_end = vma->vm_end;
+	vdata->flags = flags;
 	vdata->type = type;
 	spin_lock_init(&vdata->lock);
 	vdata->refcnt = ATOMIC_INIT(1);
_

Patches currently in -mm which might be from cpw@sgi.com are

do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
