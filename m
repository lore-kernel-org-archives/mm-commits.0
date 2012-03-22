From: akpm@linux-foundation.org
Subject: [merged] ksm-cleanup-introduce-find_mergeable_vma.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:57 -0700
Message-ID: <20120322201857.72269A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:56636 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454Ab2CVUS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:58 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so401558ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: cleanup: introduce find_mergeable_vma()
has been removed from the -mm tree.  Its filename was
     ksm-cleanup-introduce-find_mergeable_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: ksm: cleanup: introduce find_mergeable_vma()

There are multiple places which perform the same check.  Add a new
find_mergeable_vma() to handle this.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff -puN mm/ksm.c~ksm-cleanup-introduce-find_mergeable_vma mm/ksm.c
--- a/mm/ksm.c~ksm-cleanup-introduce-find_mergeable_vma
+++ a/mm/ksm.c
@@ -374,6 +374,20 @@ static int break_ksm(struct vm_area_stru
 	return (ret & VM_FAULT_OOM) ? -ENOMEM : 0;
 }
 
+static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
+		unsigned long addr)
+{
+	struct vm_area_struct *vma;
+	if (ksm_test_exit(mm))
+		return NULL;
+	vma = find_vma(mm, addr);
+	if (!vma || vma->vm_start > addr)
+		return NULL;
+	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+		return NULL;
+	return vma;
+}
+
 static void break_cow(struct rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
@@ -387,15 +401,9 @@ static void break_cow(struct rmap_item *
 	put_anon_vma(rmap_item->anon_vma);
 
 	down_read(&mm->mmap_sem);
-	if (ksm_test_exit(mm))
-		goto out;
-	vma = find_vma(mm, addr);
-	if (!vma || vma->vm_start > addr)
-		goto out;
-	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
-		goto out;
-	break_ksm(vma, addr);
-out:
+	vma = find_mergeable_vma(mm, addr);
+	if (vma)
+		break_ksm(vma, addr);
 	up_read(&mm->mmap_sem);
 }
 
@@ -421,12 +429,8 @@ static struct page *get_mergeable_page(s
 	struct page *page;
 
 	down_read(&mm->mmap_sem);
-	if (ksm_test_exit(mm))
-		goto out;
-	vma = find_vma(mm, addr);
-	if (!vma || vma->vm_start > addr)
-		goto out;
-	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+	vma = find_mergeable_vma(mm, addr);
+	if (!vma)
 		goto out;
 
 	page = follow_page(vma, addr, FOLL_GET);
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
linux-next.patch

