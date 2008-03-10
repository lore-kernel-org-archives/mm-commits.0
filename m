From: akpm@linux-foundation.org
Subject: + pagemap-proper-read-error-handling.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:51:36 -0700
Message-ID: <200803101951.m2AJpakF002555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbYCJTwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcelo@kvack.org, mpm@selenic.com, mtosatti@redhat.com


The patch titled
     pagemap: proper read error handling
has been added to the -mm tree.  Its filename is
     pagemap-proper-read-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pagemap-proper-read-error-handling.patch
git-kvm.patch

