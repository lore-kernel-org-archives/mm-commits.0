From: akpm@linux-foundation.org
Subject: + ksm-cleanup-introduce-ksm_check_mm.patch added to -mm tree
Date: Thu, 01 Mar 2012 12:51:34 -0800
Message-ID: <20120301205135.12DF2A01F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42104 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab2CAUvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 15:51:37 -0500
Received: by wejx9 with SMTP id x9so40269wej.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 12:51:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, hughd@google.com, kamezawa.hiroyuki@gmail.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     Subject: ksm: cleanup: introduce ksm_check_mm()
has been added to the -mm tree.  Its filename is
     ksm-cleanup-introduce-ksm_check_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: ksm: cleanup: introduce ksm_check_mm()

There are multiple places which do the same check.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN mm/ksm.c~ksm-cleanup-introduce-ksm_check_mm mm/ksm.c
--- a/mm/ksm.c~ksm-cleanup-introduce-ksm_check_mm
+++ a/mm/ksm.c
@@ -375,11 +375,24 @@ static int break_ksm(struct vm_area_stru
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
@@ -388,15 +401,8 @@ static void break_cow(struct rmap_item *
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
 
@@ -418,16 +424,11 @@ static struct page *get_mergeable_page(s
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
Subject: Subject: ksm: cleanup: introduce ksm_check_mm()

Patches currently in -mm which might be from lliubbo@gmail.com are

linux-next.patch
ksm-clean-up-page_trans_compound_anon_split.patch
ksm-cleanup-introduce-ksm_check_mm.patch
ksm-cleanup-introduce-ksm_check_mm-fix.patch

