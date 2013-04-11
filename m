From: akpm@linux-foundation.org
Subject: + clear_refs-introduce-private-struct-for-mm_walk.patch added to -mm tree
Date: Thu, 11 Apr 2013 14:24:33 -0700
Message-ID: <20130411212433.DA45F31C15F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38689 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935615Ab3DKVYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 17:24:35 -0400
Received: by mail-vb0-f73.google.com with SMTP id q12so188402vbe.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 14:24:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@parallels.com, glommer@parallels.com, kosaki.motohiro@gmail.com, mpm@selenic.com, mtosatti@redhat.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: clear_refs: introduce private struct for mm_walk
has been added to the -mm tree.  Its filename is
     clear_refs-introduce-private-struct-for-mm_walk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: clear_refs: introduce private struct for mm_walk

In the next patch the clear-refs-type will be required in
clear_refs_pte_range funciton, so prepare the walk->private to carry this
info.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~clear_refs-introduce-private-struct-for-mm_walk fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~clear_refs-introduce-private-struct-for-mm_walk
+++ a/fs/proc/task_mmu.c
@@ -695,10 +695,15 @@ enum clear_refs_types {
 	CLEAR_REFS_LAST,
 };
 
+struct clear_refs_private {
+	struct vm_area_struct *vma;
+};
+
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->private;
+	struct clear_refs_private *cp = walk->private;
+	struct vm_area_struct *vma = cp->vma;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -753,13 +758,16 @@ static ssize_t clear_refs_write(struct f
 		return -ESRCH;
 	mm = get_task_mm(task);
 	if (mm) {
+		struct clear_refs_private cp = {
+		};
 		struct mm_walk clear_refs_walk = {
 			.pmd_entry = clear_refs_pte_range,
 			.mm = mm,
+			.private = &cp,
 		};
 		down_read(&mm->mmap_sem);
 		for (vma = mm->mmap; vma; vma = vma->vm_next) {
-			clear_refs_walk.private = vma;
+			cp.vma = vma;
 			if (is_vm_hugetlb_page(vma))
 				continue;
 			/*
_

Patches currently in -mm which might be from xemul@parallels.com are

linux-next.patch
clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
pagemap-introduce-the-proc-pid-pagemap2-file.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
kernel-sysc-make-prctlpr_set_mm-generally-available.patch

