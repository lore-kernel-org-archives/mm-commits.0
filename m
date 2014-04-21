From: akpm@linux-foundation.org
Subject: + blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch
 added to -mm tree
Date: Mon, 21 Apr 2014 14:19:10 -0700
Message-ID: <53558b4e.Gdw0sycjqaOx7Oos%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbaDUVTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 17:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, realmz6@gmail.com, davidlohr@hp.com

Subject: + blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch added to -mm tree
To: davidlohr@hp.com,realmz6@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 14:19:10 -0700


The patch titled
     Subject: blackfin/ptrace: call find_vma with the mmap_sem held
has been added to the -mm tree.  Its filename is
     blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
mips-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch
drm-exynos-call-find_vma-with-the-mmap_sem-held.patch
ipc-constify-ipc_ops.patch
linux-next.patch

