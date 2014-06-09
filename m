From: akpm@linux-foundation.org
Subject: [merged]
 blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:39:58 -0700
Message-ID: <53960d8e.abjb0hy5HH3SFL1V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaFITj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, realmz6@gmail.com, davidlohr@hp.com

Subject: [merged] blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch removed from -mm tree
To: davidlohr@hp.com,realmz6@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:39:58 -0700


The patch titled
     Subject: blackfin/ptrace: call find_vma with the mmap_sem held
has been removed from the -mm tree.  Its filename was
     blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: blackfin/ptrace: call find_vma with the mmap_sem held

Performing vma lookups without taking the mm->mmap_sem is asking for
trouble.  While doing the search, the vma in question can be modified or
even removed before returning to the caller.  Take the lock (shared) in
order to avoid races while iterating through the vmacache and/or rbtree.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/ptrace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/blackfin/kernel/ptrace.c~blackfin-ptrace-call-find_vma-with-the-mmap_sem-held arch/blackfin/kernel/ptrace.c
--- a/arch/blackfin/kernel/ptrace.c~blackfin-ptrace-call-find_vma-with-the-mmap_sem-held
+++ a/arch/blackfin/kernel/ptrace.c
@@ -117,6 +117,7 @@ put_reg(struct task_struct *task, unsign
 int
 is_user_addr_valid(struct task_struct *child, unsigned long start, unsigned long len)
 {
+	bool valid;
 	struct vm_area_struct *vma;
 	struct sram_list_struct *sraml;
 
@@ -124,9 +125,12 @@ is_user_addr_valid(struct task_struct *c
 	if (start + len < start)
 		return -EIO;
 
+	down_read(&child->mm->mmap_sem);
 	vma = find_vma(child->mm, start);
-	if (vma && start >= vma->vm_start && start + len <= vma->vm_end)
-			return 0;
+	valid = vma && start >= vma->vm_start && start + len <= vma->vm_end;
+	up_read(&child->mm->mmap_sem);
+	if (valid)
+		return 0;
 
 	for (sraml = child->mm->context.sram_list; sraml; sraml = sraml->next)
 		if (start >= (unsigned long)sraml->addr
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
linux-next.patch

