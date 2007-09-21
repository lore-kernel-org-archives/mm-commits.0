From: akpm@linux-foundation.org
Subject: + fix-mspec-handle-shrinking-virtual-memory-areas.patch added to -mm tree
Date: Thu, 20 Sep 2007 17:24:07 -0700
Message-ID: <200709210024.l8L0O7xT010206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261AbXIUAYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 20:24:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpw@sgi.com, jes@sgi.com


The patch titled
     fix "mspec: handle shrinking virtual memory areas"
has been added to the -mm tree.  Its filename is
     fix-mspec-handle-shrinking-virtual-memory-areas.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix "mspec: handle shrinking virtual memory areas"
From: cpw@sgi.com (Cliff Wickman)

The vma_data structure may be shared by vma's from multiple tasks, with no
way of knowing which areas are shared or not shared, so release/clear pages
only when the refcount (of vma's) goes to zero.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Jes Sorensen <jes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mspec.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff -puN drivers/char/mspec.c~fix-mspec-handle-shrinking-virtual-memory-areas drivers/char/mspec.c
--- a/drivers/char/mspec.c~fix-mspec-handle-shrinking-virtual-memory-areas
+++ a/drivers/char/mspec.c
@@ -155,23 +155,22 @@ mspec_open(struct vm_area_struct *vma)
  * mspec_close
  *
  * Called when unmapping a device mapping. Frees all mspec pages
- * belonging to the vma.
+ * belonging to all the vma's sharing this vma_data structure.
  */
 static void
 mspec_close(struct vm_area_struct *vma)
 {
 	struct vma_data *vdata;
-	int index, last_index, result;
+	int index, last_index;
 	unsigned long my_page;
 
 	vdata = vma->vm_private_data;
 
-	BUG_ON(vma->vm_start < vdata->vm_start || vma->vm_end > vdata->vm_end);
+	if (!atomic_dec_and_test(&vdata->refcnt))
+		return;
 
-	spin_lock(&vdata->lock);
-	index = (vma->vm_start - vdata->vm_start) >> PAGE_SHIFT;
-	last_index = (vma->vm_end - vdata->vm_start) >> PAGE_SHIFT;
-	for (; index < last_index; index++) {
+	last_index = (vdata->vm_end - vdata->vm_start) >> PAGE_SHIFT;
+	for (index = 0; index < last_index; index++) {
 		if (vdata->maddr[index] == 0)
 			continue;
 		/*
@@ -180,20 +179,12 @@ mspec_close(struct vm_area_struct *vma)
 		 */
 		my_page = vdata->maddr[index];
 		vdata->maddr[index] = 0;
-		spin_unlock(&vdata->lock);
-		result = mspec_zero_block(my_page, PAGE_SIZE);
-		if (!result)
+		if (!mspec_zero_block(my_page, PAGE_SIZE))
 			uncached_free_page(my_page);
 		else
 			printk(KERN_WARNING "mspec_close(): "
-			       "failed to zero page %i\n",
-			       result);
-		spin_lock(&vdata->lock);
+			       "failed to zero page %ld\n", my_page);
 	}
-	spin_unlock(&vdata->lock);
-
-	if (!atomic_dec_and_test(&vdata->refcnt))
-		return;
 
 	if (vdata->flags & VMD_VMALLOCED)
 		vfree(vdata);
@@ -201,7 +192,6 @@ mspec_close(struct vm_area_struct *vma)
 		kfree(vdata);
 }
 
-
 /*
  * mspec_nopfn
  *
_

Patches currently in -mm which might be from cpw@sgi.com are

fix-mspec-handle-shrinking-virtual-memory-areas.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
