From: akpm@linux-foundation.org
Subject: [merged] clear_refs-introduce-private-struct-for-mm_walk.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:51 -0700
Message-ID: <51db11c7.BH1hoDkcbt55Pz7N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3GHTXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com, mpm@selenic.com, kosaki.motohiro@gmail.com, glommer@parallels.com, xemul@parallels.com

Subject: [merged] clear_refs-introduce-private-struct-for-mm_walk.patch removed from -mm tree
To: xemul@parallels.com,glommer@parallels.com,kosaki.motohiro@gmail.com,mpm@selenic.com,mtosatti@redhat.com,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:51 -0700


The patch titled
     Subject: clear_refs: introduce private struct for mm_walk
has been removed from the -mm tree.  Its filename was
     clear_refs-introduce-private-struct-for-mm_walk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

