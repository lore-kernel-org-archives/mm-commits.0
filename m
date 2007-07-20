From: akpm@linux-foundation.org
Subject: + mmaps2-vma-out-of-mem_size_stats.patch added to -mm tree
Date: Thu, 19 Jul 2007 18:38:11 -0700
Message-ID: <200707200138.l6K1cBXc000978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759851AbXGTBic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 21:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, mpm@selenic.com


The patch titled
     maps2: vma out of mem_size_stats
has been added to the -mm tree.  Its filename is
     mmaps2-vma-out-of-mem_size_stats.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps2: vma out of mem_size_stats
From: Rusty Russell <rusty@rustcorp.com.au>

Putting the vma inside "struct mem_size_stats" to hand it through the
pagewalker is a little gross.  Making a separate struct is more verbose, but
clearer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff -puN fs/proc/task_mmu.c~mmaps2-vma-out-of-mem_size_stats fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mmaps2-vma-out-of-mem_size_stats
+++ a/fs/proc/task_mmu.c
@@ -318,7 +318,6 @@ const struct file_operations proc_maps_o
 #ifdef CONFIG_PROC_SMAPS
 struct mem_size_stats
 {
-	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -327,11 +326,18 @@ struct mem_size_stats
 	unsigned long referenced;
 };
 
+struct smaps_arg
+{
+	struct mem_size_stats mss;
+	struct vm_area_struct *vma;
+};
+
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   void *private)
 {
-	struct mem_size_stats *mss = private;
-	struct vm_area_struct *vma = mss->vma;
+	struct smaps_arg *sarg = private;
+	struct vm_area_struct *vma = sarg->vma;
+	struct mem_size_stats *mss = &sarg->mss;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -373,14 +379,14 @@ static struct mm_walk smaps_walk = { .pm
 static int show_smap(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
-	struct mem_size_stats mss;
+	struct smaps_arg sarg;
 	int ret;
 
-	memset(&mss, 0, sizeof mss);
-	mss.vma = vma;
+	memset(&sarg.mss, 0, sizeof sarg.mss);
+	sarg.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
-				&smaps_walk, &mss);
+				&smaps_walk, &sarg);
 
 	ret = show_map(m, v);
 	if (ret)
@@ -395,12 +401,12 @@ static int show_smap(struct seq_file *m,
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
-		   mss.resident >> 10,
-		   mss.shared_clean  >> 10,
-		   mss.shared_dirty  >> 10,
-		   mss.private_clean >> 10,
-		   mss.private_dirty >> 10,
-		   mss.referenced >> 10);
+		   sarg.mss.resident >> 10,
+		   sarg.mss.shared_clean  >> 10,
+		   sarg.mss.shared_dirty  >> 10,
+		   sarg.mss.private_clean >> 10,
+		   sarg.mss.private_dirty >> 10,
+		   sarg.mss.referenced >> 10);
 
 	return ret;
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
git-kvm.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
