From: akpm@linux-foundation.org
Subject: - mspec-handle-shrinking-virtual-memory-areas-3.patch removed from -mm tree
Date: Tue, 18 Sep 2007 22:02:17 -0700
Message-ID: <200709190502.l8J52Hlx007856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbXISFCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 01:02:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cpw@sgi.com, jes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mspec: handle shrinking virtual memory areas
has been removed from the -mm tree.  Its filename was
     mspec-handle-shrinking-virtual-memory-areas-3.patch

This patch was dropped because it was folded into mspec-handle-shrinking-virtual-memory-areas.patch

------------------------------------------------------
Subject: mspec: handle shrinking virtual memory areas
From: Cliff Wickman <cpw@sgi.com>

Stress testing revealed the need for more revision:

Version 3: single thread the clearing of vma_data maddr[]

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mspec.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/char/mspec.c~mspec-handle-shrinking-virtual-memory-areas-3 drivers/char/mspec.c
--- a/drivers/char/mspec.c~mspec-handle-shrinking-virtual-memory-areas-3
+++ a/drivers/char/mspec.c
@@ -91,7 +91,7 @@ static int is_sn2;
  */
 struct vma_data {
 	atomic_t refcnt;	/* Number of vmas sharing the data. */
-	spinlock_t lock;	/* Serialize access to the vma. */
+	spinlock_t lock;	/* Serialize access to this structure. */
 	int count;		/* Number of pages allocated. */
 	enum mspec_page_type type; /* Type of pages allocated. */
 	int flags;		/* See VMD_xxx below. */
@@ -162,11 +162,13 @@ mspec_close(struct vm_area_struct *vma)
 {
 	struct vma_data *vdata;
 	int index, last_index, result;
+	unsigned long my_page;
 
 	vdata = vma->vm_private_data;
 
 	BUG_ON(vma->vm_start < vdata->vm_start || vma->vm_end > vdata->vm_end);
 
+	spin_lock(&vdata->lock);
 	index = (vma->vm_start - vdata->vm_start) >> PAGE_SHIFT;
 	last_index = (vma->vm_end - vdata->vm_start) >> PAGE_SHIFT;
 	for (; index < last_index; index++) {
@@ -176,15 +178,19 @@ mspec_close(struct vm_area_struct *vma)
 		 * Clear the page before sticking it back
 		 * into the pool.
 		 */
-		result = mspec_zero_block(vdata->maddr[index], PAGE_SIZE);
+		my_page = vdata->maddr[index];
+		vdata->maddr[index] = 0;
+		spin_unlock(&vdata->lock);
+		result = mspec_zero_block(my_page, PAGE_SIZE);
 		if (!result)
-			uncached_free_page(vdata->maddr[index]);
+			uncached_free_page(my_page);
 		else
 			printk(KERN_WARNING "mspec_close(): "
 			       "failed to zero page %i\n",
 			       result);
-		vdata->maddr[index] = 0;
+		spin_lock(&vdata->lock);
 	}
+	spin_unlock(&vdata->lock);
 
 	if (!atomic_dec_and_test(&vdata->refcnt))
 		return;
_

Patches currently in -mm which might be from cpw@sgi.com are

mspec-handle-shrinking-virtual-memory-areas.patch
mspec-handle-shrinking-virtual-memory-areas-3.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
