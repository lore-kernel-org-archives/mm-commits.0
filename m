From: akpm@linux-foundation.org
Subject: + ksm-cleanup-introduce-find_mergeable_vma.patch added to -mm tree
Date: Wed, 07 Mar 2012 15:43:35 -0800
Message-ID: <20120307234335.B0459A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:49335 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068Ab2CGXng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Mar 2012 18:43:36 -0500
Received: by yhgm50 with SMTP id m50so877924yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Mar 2012 15:43:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, aarcange@redhat.com, hughd@google.com


The patch titled
     Subject: ksm: cleanup: introduce find_mergeable_vma()
has been added to the -mm tree.  Its filename is
     ksm-cleanup-introduce-find_mergeable_vma.patch

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
Subject: ksm: cleanup: introduce find_mergeable_vma()

There are multiple places which perform the same check.  Add a new
find_mergeable_vma() to handle this.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
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
Subject: Subject: ksm: cleanup: introduce find_mergeable_vma()

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
linux-next.patch
ksm-cleanup-introduce-find_mergeable_vma.patch

