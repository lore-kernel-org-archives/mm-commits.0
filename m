From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-cleanup-introduce-ksm_check_mm.patch removed from -mm tree
Date: Tue, 06 Mar 2012 15:47:00 -0800
Message-ID: <20120306234700.627F7A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:54297 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2CFXrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 18:47:02 -0500
Received: by bkcjm19 with SMTP id jm19so210573bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 15:47:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: cleanup: introduce ksm_check_mm()
has been removed from the -mm tree.  Its filename was
     ksm-cleanup-introduce-ksm_check_mm.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: ksm: cleanup: introduce ksm_check_mm()

There are multiple places which do the same check.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>				
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN mm/ksm.c~ksm-cleanup-introduce-ksm_check_mm mm/ksm.c
--- a/mm/ksm.c~ksm-cleanup-introduce-ksm_check_mm
+++ a/mm/ksm.c
@@ -374,11 +374,24 @@ static int break_ksm(struct vm_area_stru
 	return (ret & VM_FAULT_OOM) ? -ENOMEM : 0;
 }
 
+static int ksm_check_mm(struct mm_struct *mm, struct vm_area_struct *vma,
+		unsigned long addr)
+{
+	if (ksm_test_exit(mm))
+		return 0;
+	vma = find_vma(mm, addr);
+	if (!vma || vma->vm_start > addr)
+		return 0;
+	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+		return 0;
+	return 1;
+}
+
 static void break_cow(struct rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
 	unsigned long addr = rmap_item->address;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = NULL;
 
 	/*
 	 * It is not an accident that whenever we want to break COW
@@ -387,15 +400,8 @@ static void break_cow(struct rmap_item *
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
+	if (ksm_check_mm(mm, vma, addr))
+		break_ksm(vma, addr);
 	up_read(&mm->mmap_sem);
 }
 
@@ -417,16 +423,11 @@ static struct page *get_mergeable_page(s
 {
 	struct mm_struct *mm = rmap_item->mm;
 	unsigned long addr = rmap_item->address;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = NULL;
 	struct page *page;
 
 	down_read(&mm->mmap_sem);
-	if (ksm_test_exit(mm))
-		goto out;
-	vma = find_vma(mm, addr);
-	if (!vma || vma->vm_start > addr)
-		goto out;
-	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+	if (!ksm_check_mm(mm, vma, addr))
 		goto out;
 
 	page = follow_page(vma, addr, FOLL_GET);
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
linux-next.patch
ksm-cleanup-introduce-ksm_check_mm-fix.patch

