Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE796AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423560; cv=none; b=DPtNDDFjv+sGDMGEmYH1HYe95SCcYeotgxzD11MnWkxFV1EBcGdCIPlLdhf//El0k7IuXo0KSsZchKYQ5w5KO6BhDzbPk1Rv2VVlW4LQbwlQCDRped82j68l18zVREMV4iAUv/9f7JarwN9/PjkOGQhQNYkyPDAK1hkS2Utx/KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423560; c=relaxed/simple;
	bh=xgQxFYIRR3PsLUmHIEK7MBqiQ/3Bgck1wCst4xyyqNM=;
	h=Date:To:From:Subject:Message-Id; b=ediUo3Zr5FG3gD6NGpia5OsOoJc8GY7T5vr2j0S+9AKJmoUq6j+eBUE8ijGk69HgNRWw2NFyY0QpTGSiuhhBIRpR85iLIpqvNGc39NWvPxpi0ml6YtFAIpsfgxBOcRvcexlGLhn1tnLI/GqF8HaLYlq+wAadGn5gmSkxKtRX2eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d30G/Vg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d30G/Vg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1729EC4CEC2;
	Wed,  4 Sep 2024 04:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423560;
	bh=xgQxFYIRR3PsLUmHIEK7MBqiQ/3Bgck1wCst4xyyqNM=;
	h=Date:To:From:Subject:From;
	b=d30G/Vg2TCFV1MrcD5foSWDi9/VHPpFP0FpSwscxX1Qg4yG+1TUIC6A+NE0tAXVdy
	 Y3p77R5SVXuAgKtQToO0ugQCjzRH5GrEhhnMhby7hRu+2ldNMI0X99gfMlObAa5F1B
	 qPo8/G3hWDpL3YSTvl11Dtk9jcvNV5jIB+cTHjII=
Date: Tue, 03 Sep 2024 21:19:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-expand-mmap_region-munmap-call.patch removed from -mm tree
Message-Id: <20240904041920.1729EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: expand mmap_region() munmap call
has been removed from the -mm tree.  Its filename was
     mm-vma-expand-mmap_region-munmap-call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: expand mmap_region() munmap call
Date: Fri, 30 Aug 2024 00:00:49 -0400

Open code the do_vmi_align_munmap() call so that it can be broken up later
in the series.

This requires exposing a few more vma operations.

Link: https://lkml.kernel.org/r/20240830040101.822209-10-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   26 ++++++++++++++++++++++----
 mm/vma.c  |   31 ++-----------------------------
 mm/vma.h  |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 33 deletions(-)

--- a/mm/mmap.c~mm-vma-expand-mmap_region-munmap-call
+++ a/mm/mmap.c
@@ -1366,6 +1366,9 @@ unsigned long mmap_region(struct file *f
 	struct vm_area_struct *next, *prev, *merge;
 	pgoff_t pglen = len >> PAGE_SHIFT;
 	unsigned long charged = 0;
+	struct vma_munmap_struct vms;
+	struct ma_state mas_detach;
+	struct maple_tree mt_detach;
 	unsigned long end = addr + len;
 	unsigned long merge_start = addr, merge_end = end;
 	bool writable_file_mapping = false;
@@ -1391,11 +1394,28 @@ unsigned long mmap_region(struct file *f
 	/* Find the first overlapping VMA */
 	vma = vma_find(&vmi, end);
 	if (vma) {
-		/* Unmap any existing mapping in the area */
-		error = do_vmi_align_munmap(&vmi, vma, mm, addr, end, uf, false);
+		mt_init_flags(&mt_detach, vmi.mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
+		mt_on_stack(mt_detach);
+		mas_init(&mas_detach, &mt_detach, /* addr = */ 0);
+		init_vma_munmap(&vms, &vmi, vma, addr, end, uf, /* unlock = */ false);
+		/* Prepare to unmap any existing mapping in the area */
+		error = vms_gather_munmap_vmas(&vms, &mas_detach);
 		if (error)
 			return error;
+
+		/* Remove any existing mappings from the vma tree */
+		if (vma_iter_clear_gfp(&vmi, addr, end, GFP_KERNEL))
+			return -ENOMEM;
+
+		/* Unmap any existing mapping in the area */
+		vms_complete_munmap_vmas(&vms, &mas_detach);
+		next = vms.next;
+		prev = vms.prev;
+		vma_prev(&vmi);
 		vma = NULL;
+	} else {
+		next = vma_next(&vmi);
+		prev = vma_prev(&vmi);
 	}
 
 	/*
@@ -1408,8 +1428,6 @@ unsigned long mmap_region(struct file *f
 		vm_flags |= VM_ACCOUNT;
 	}
 
-	next = vma_next(&vmi);
-	prev = vma_prev(&vmi);
 	if (vm_flags & VM_SPECIAL) {
 		if (prev)
 			vma_iter_next_range(&vmi);
--- a/mm/vma.c~mm-vma-expand-mmap_region-munmap-call
+++ a/mm/vma.c
@@ -81,33 +81,6 @@ static void init_multi_vma_prep(struct v
 }
 
 /*
- * init_vma_munmap() - Initializer wrapper for vma_munmap_struct
- * @vms: The vma munmap struct
- * @vmi: The vma iterator
- * @vma: The first vm_area_struct to munmap
- * @start: The aligned start address to munmap
- * @end: The aligned end address to munmap
- * @uf: The userfaultfd list_head
- * @unlock: Unlock after the operation.  Only unlocked on success
- */
-static inline void init_vma_munmap(struct vma_munmap_struct *vms,
-		struct vma_iterator *vmi, struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, struct list_head *uf,
-		bool unlock)
-{
-	vms->vmi = vmi;
-	vms->vma = vma;
-	vms->mm = vma->vm_mm;
-	vms->start = start;
-	vms->end = end;
-	vms->unlock = unlock;
-	vms->uf = uf;
-	vms->vma_count = 0;
-	vms->nr_pages = vms->locked_vm = vms->nr_accounted = 0;
-	vms->exec_vm = vms->stack_vm = vms->data_vm = 0;
-}
-
-/*
  * Return true if we can merge this (vm_flags,anon_vma,file,vm_pgoff)
  * in front of (at a lower virtual address and file offset than) the vma.
  *
@@ -698,7 +671,7 @@ static inline void abort_munmap_vmas(str
  * used for the munmap() and may downgrade the lock - if requested.  Everything
  * needed to be done once the vma maple tree is updated.
  */
-static void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
+void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
 		struct ma_state *mas_detach)
 {
 	struct vm_area_struct *vma;
@@ -752,7 +725,7 @@ static void vms_complete_munmap_vmas(str
  *
  * Return: 0 on success, -EPERM on mseal vmas, -ENOMEM otherwise
  */
-static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
+int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		struct ma_state *mas_detach)
 {
 	struct vm_area_struct *next = NULL;
--- a/mm/vma.h~mm-vma-expand-mmap_region-munmap-call
+++ a/mm/vma.h
@@ -78,6 +78,39 @@ int vma_expand(struct vma_iterator *vmi,
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff);
 
+/*
+ * init_vma_munmap() - Initializer wrapper for vma_munmap_struct
+ * @vms: The vma munmap struct
+ * @vmi: The vma iterator
+ * @vma: The first vm_area_struct to munmap
+ * @start: The aligned start address to munmap
+ * @end: The aligned end address to munmap
+ * @uf: The userfaultfd list_head
+ * @unlock: Unlock after the operation.  Only unlocked on success
+ */
+static inline void init_vma_munmap(struct vma_munmap_struct *vms,
+		struct vma_iterator *vmi, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, struct list_head *uf,
+		bool unlock)
+{
+	vms->vmi = vmi;
+	vms->vma = vma;
+	vms->mm = vma->vm_mm;
+	vms->start = start;
+	vms->end = end;
+	vms->unlock = unlock;
+	vms->uf = uf;
+	vms->vma_count = 0;
+	vms->nr_pages = vms->locked_vm = vms->nr_accounted = 0;
+	vms->exec_vm = vms->stack_vm = vms->data_vm = 0;
+}
+
+int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
+		struct ma_state *mas_detach);
+
+void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
+		struct ma_state *mas_detach);
+
 int
 do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		    struct mm_struct *mm, unsigned long start,
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


