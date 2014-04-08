From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:48:11 -0700
Message-ID: <5344608b.b2Xce1WnaxxDBFFE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHUsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:48:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yong@gnoy.org

Subject: [merged] mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch removed from -mm tree
To: yong@gnoy.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:48:11 -0700


The patch titled
     Subject: mm: fix 'ERROR: do not initialise globals to 0 or NULL' and coding style
has been removed from the -mm tree.  Its filename was
     mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Choi Gi-yong <yong@gnoy.org>
Subject: mm: fix 'ERROR: do not initialise globals to 0 or NULL' and coding style

Signed-off-by: Choi Gi-yong <yong@gnoy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 mm/nommu.c   |   16 ++++++----------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff -puN mm/hugetlb.c~mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style mm/hugetlb.c
--- a/mm/hugetlb.c~mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style
+++ a/mm/hugetlb.c
@@ -2898,8 +2898,7 @@ retry:
 	if (anon_rmap) {
 		ClearPagePrivate(page);
 		hugepage_add_new_anon_rmap(page, vma, address);
-	}
-	else
+	} else
 		page_dup_rmap(page);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
diff -puN mm/nommu.c~mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style mm/nommu.c
--- a/mm/nommu.c~mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style
+++ a/mm/nommu.c
@@ -298,7 +298,7 @@ long vwrite(char *buf, char *addr, unsig
 		count = -(unsigned long) addr;
 
 	memcpy(addr, buf, count);
-	return(count);
+	return count;
 }
 
 /*
@@ -1012,8 +1012,7 @@ static int validate_mmap_request(struct
 
 			/* we mustn't privatise shared mappings */
 			capabilities &= ~BDI_CAP_MAP_COPY;
-		}
-		else {
+		} else {
 			/* we're going to read the file into private memory we
 			 * allocate */
 			if (!(capabilities & BDI_CAP_MAP_COPY))
@@ -1044,23 +1043,20 @@ static int validate_mmap_request(struct
 		if (file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
 			if (prot & PROT_EXEC)
 				return -EPERM;
-		}
-		else if ((prot & PROT_READ) && !(prot & PROT_EXEC)) {
+		} else if ((prot & PROT_READ) && !(prot & PROT_EXEC)) {
 			/* handle implication of PROT_EXEC by PROT_READ */
 			if (current->personality & READ_IMPLIES_EXEC) {
 				if (capabilities & BDI_CAP_EXEC_MAP)
 					prot |= PROT_EXEC;
 			}
-		}
-		else if ((prot & PROT_READ) &&
+		} else if ((prot & PROT_READ) &&
 			 (prot & PROT_EXEC) &&
 			 !(capabilities & BDI_CAP_EXEC_MAP)
 			 ) {
 			/* backing file is not executable, try to copy */
 			capabilities &= ~BDI_CAP_MAP_DIRECT;
 		}
-	}
-	else {
+	} else {
 		/* anonymous mappings are always memory backed and can be
 		 * privately mapped
 		 */
@@ -1668,7 +1664,7 @@ int do_munmap(struct mm_struct *mm, unsi
 	/* find the first potentially overlapping VMA */
 	vma = find_vma(mm, start);
 	if (!vma) {
-		static int limit = 0;
+		static int limit;
 		if (limit < 5) {
 			printk(KERN_WARNING
 			       "munmap of memory not mmapped by process %d"
_

Patches currently in -mm which might be from yong@gnoy.org are

origin.patch

