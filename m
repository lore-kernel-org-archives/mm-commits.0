From: akpm@linux-foundation.org
Subject: - pagemap-proper-read-error-handling.patch removed from -mm tree
Date: Mon, 17 Mar 2008 13:57:21 -0700
Message-ID: <200803172057.m2HKvLTN030617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180AbYCQU6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 16:58:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcelo@kvack.org, mpm@selenic.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pagemap: proper read error handling
has been removed from the -mm tree.  Its filename was
     pagemap-proper-read-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: proper read error handling
From: Marcelo Tosatti <marcelo@kvack.org>

Fix pagemap_read() error handling by releasing acquired resources and checking
for get_user_pages() partial failure.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-proper-read-error-handling fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-proper-read-error-handling
+++ a/fs/proc/task_mmu.c
@@ -640,17 +640,17 @@ static ssize_t pagemap_read(struct file 
 
 	ret = -EACCES;
 	if (!ptrace_may_attach(task))
-		goto out;
+		goto out_task;
 
 	ret = -EINVAL;
 	/* file position must be aligned */
 	if (*ppos % PM_ENTRY_BYTES)
-		goto out;
+		goto out_task;
 
 	ret = 0;
 	mm = get_task_mm(task);
 	if (!mm)
-		goto out;
+		goto out_task;
 
 	ret = -ENOMEM;
 	uaddr = (unsigned long)buf & PAGE_MASK;
@@ -658,7 +658,7 @@ static ssize_t pagemap_read(struct file 
 	pagecount = (PAGE_ALIGN(uend) - uaddr) / PAGE_SIZE;
 	pages = kmalloc(pagecount * sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
-		goto out_task;
+		goto out_mm;
 
 	down_read(&current->mm->mmap_sem);
 	ret = get_user_pages(current, current->mm, uaddr, pagecount,
@@ -668,6 +668,12 @@ static ssize_t pagemap_read(struct file 
 	if (ret < 0)
 		goto out_free;
 
+	if (ret != pagecount) {
+		pagecount = ret;
+		ret = -EFAULT;
+		goto out_pages;
+	}
+
 	pm.out = buf;
 	pm.end = buf + count;
 
@@ -699,15 +705,17 @@ static ssize_t pagemap_read(struct file 
 			ret = pm.out - buf;
 	}
 
+out_pages:
 	for (; pagecount; pagecount--) {
 		page = pages[pagecount-1];
 		if (!PageReserved(page))
 			SetPageDirty(page);
 		page_cache_release(page);
 	}
-	mmput(mm);
 out_free:
 	kfree(pages);
+out_mm:
+	mmput(mm);
 out_task:
 	put_task_struct(task);
 out:
_

Patches currently in -mm which might be from marcelo@kvack.org are

git-kvm.patch

