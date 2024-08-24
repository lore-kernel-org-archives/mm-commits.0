Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6F68BEE
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 01:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724464701; cv=none; b=ea84+/SHMpg2XdsQXU9jun3Q6xK9oWciL6I0IQmk22+k8/8tt6rciz7bFCEM4QW+UPEjfqI/WyAeyx+kQWKWgfHUxz5zCgsDLoQgbjRIA1gnJrKGNOQjlBhhIBsFB49R7cJ7Nudci5P5dWtKCs1WjxppOIA8L5XzFKABH+Pf+GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724464701; c=relaxed/simple;
	bh=XnTjbdl37MwmcYcZ4IwzF1576X3XsM4a/xdedtKpNgw=;
	h=Date:To:From:Subject:Message-Id; b=Erka1nopZDrOy+WSJozqRmfP7U20K9rqKmiWj07FMhUgtDZb//JMkmAcCUseBhjm/2hZv5QQT5fjZ91Ff8xH4nsKcOYuLrWNapgKIOIZC7nfgXDl6vbqmdG0Rc3OG+qSID4vbQWwYBblAka5BR+vc3aZ/Lald3rzBYTAD82Jz8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rp+DmekO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rp+DmekO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D28C32786;
	Sat, 24 Aug 2024 01:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724464701;
	bh=XnTjbdl37MwmcYcZ4IwzF1576X3XsM4a/xdedtKpNgw=;
	h=Date:To:From:Subject:From;
	b=Rp+DmekOqPxZ7AmtSRb3UJNFixmkcVhHmtLZ7uU3C0Rj0Jse631odUhPNqa2zRWrt
	 E0blMefnGEf54EiiKYhEtR+gMsJnWXK6tv6WGL/T94sz2Ve7r/A9Dqq6+V8NUWyJfE
	 pzx8uZA3A6PsBizg5bhy2VcMLHSRkioVGOPrVsPs=
Date: Fri, 23 Aug 2024 18:58:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-expand-mmap_region-munmap-call.patch added to mm-unstable branch
Message-Id: <20240824015820.E2D28C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: expand mmap_region() munmap call
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-expand-mmap_region-munmap-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-expand-mmap_region-munmap-call.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: expand mmap_region() munmap call
Date: Thu, 22 Aug 2024 15:25:31 -0400

Open code the do_vmi_align_munmap() call so that it can be broken up
later in the series.

This requires exposing a few more vma operations.

Link: https://lkml.kernel.org/r/20240822192543.3359552-10-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
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
@@ -1391,10 +1394,27 @@ unsigned long mmap_region(struct file *f
 	/* Find the first overlapping VMA */
 	vma = vma_find(&vmi, end);
 	if (vma) {
-		/* Unmap any existing mapping in the area */
-		if (do_vmi_align_munmap(&vmi, vma, mm, addr, end, uf, false))
+		mt_init_flags(&mt_detach, vmi.mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
+		mt_on_stack(mt_detach);
+		mas_init(&mas_detach, &mt_detach, /* addr = */ 0);
+		init_vma_munmap(&vms, &vmi, vma, addr, end, uf, /* unlock = */ false);
+		/* Prepare to unmap any existing mapping in the area */
+		if (vms_gather_munmap_vmas(&vms, &mas_detach))
+			return -ENOMEM;
+
+		/* Remove any existing mappings from the vma tree */
+		if (vma_iter_clear_gfp(&vmi, addr, end, GFP_KERNEL))
 			return -ENOMEM;
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
@@ -1407,8 +1427,6 @@ unsigned long mmap_region(struct file *f
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
  * Return: 0 on success
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

maple_tree-remove-rcu_read_lock-from-mt_validate.patch
mm-vma-correctly-position-vma_iterator-in-__split_vma.patch
mm-vma-introduce-abort_munmap_vmas.patch
mm-vma-introduce-vmi_complete_munmap_vmas.patch
mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas-fix.patch
mm-vma-extract-validate_mm-from-vma_complete.patch
mm-vma-inline-munmap-operation-in-mmap_region.patch
mm-vma-expand-mmap_region-munmap-call.patch
mm-vma-support-vma-==-null-in-init_vma_munmap.patch
mm-mmap-reposition-vma-iterator-in-mmap_region.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch
mm-clean-up-unmap_region-argument-list.patch
mm-mmap-avoid-zeroing-vma-tree-in-mmap_region.patch
mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch
mm-mmap-use-phys_pfn-in-mmap_region.patch
mm-mmap-use-vms-accounted-pages-in-mmap_region.patch
ipc-shm-mm-drop-do_vma_munmap.patch
mm-move-may_expand_vm-check-in-mmap_region.patch
mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch
mm-vmah-optimise-vma_munmap_struct.patch

