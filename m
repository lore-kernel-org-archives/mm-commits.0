Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F4223A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836976; cv=none; b=LdKCPJwQFGR6cJPpOY1cWfurRjZ13Co53KMZntAASjmem95z1RNdogDDicbtrcV9JzH8OVcpU9XOvN6od5yebYDaDrZ7tF1v1DMHsMY7aT82R3vmua7756nYd6ehJ1MFLtwhUXFPVFubMiM3Eg2igC032Pv4+mpGB6L8RIrPn70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836976; c=relaxed/simple;
	bh=LQs5t3Rt0i+Ksgu40penEoS+I9UG4guQyXxvkdrPQTg=;
	h=Date:To:From:Subject:Message-Id; b=fYaguRNUe9v09yCLhJ+OVEY2PSirB3qDP8H4Sf83WZbScIrWov7euvDhaiePxlGCJZ/mGuyYGMQ6y3lfZziTUqcC7v9Zl9VoErUfe9Hwj9ERKbwelOEDak4b/6jEwKEl48osRNKuTZdFClBA265nG4LBSECGvNsKN/lfWnemojw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hKz1TBR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hKz1TBR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227C7C4CEDD;
	Tue, 14 Jan 2025 06:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836976;
	bh=LQs5t3Rt0i+Ksgu40penEoS+I9UG4guQyXxvkdrPQTg=;
	h=Date:To:From:Subject:From;
	b=hKz1TBR+KkvBefrBRt6fOwSFnq3N9IF2hEmge3KoGWt75qT0rtVurZXrLlNJ5vpQg
	 SO4YkIUDmtrqiyhMXyW8CM+b+r1eYNGLJkqcevFguXNe+oQRCqNPG5UynmHx3ZlL1f
	 KkjUKYzkVIeZ39YgzxK+3FgxJZ3lL40bKRcMmn38=
Date: Mon, 13 Jan 2025 22:42:55 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,Liam.Howlett@Oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,ebiederm@xmission.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-move-unmapped_area-internals-to-mm-vmac.patch removed from -mm tree
Message-Id: <20250114064256.227C7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: move unmapped_area() internals to mm/vma.c
has been removed from the -mm tree.  Its filename was
     mm-vma-move-unmapped_area-internals-to-mm-vmac.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: move unmapped_area() internals to mm/vma.c
Date: Tue, 3 Dec 2024 18:05:09 +0000

We want to be able to unit test the unmapped area logic, so move it to
mm/vma.c.  The wrappers which invoke this remain in place in mm/mmap.c.

In addition, naturally, update the existing test code to enable this to be
compiled in userland.

Link: https://lkml.kernel.org/r/53a57a52a64ea54e9d129d2e2abca3a538022379.1733248985.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c                        |  109 -----------------------------
 mm/vma.c                         |  109 +++++++++++++++++++++++++++++
 mm/vma.h                         |    3 
 tools/testing/vma/vma.c          |    6 +
 tools/testing/vma/vma_internal.h |   59 +++++++++++++++
 5 files changed, 177 insertions(+), 109 deletions(-)

--- a/mm/mmap.c~mm-vma-move-unmapped_area-internals-to-mm-vmac
+++ a/mm/mmap.c
@@ -580,115 +580,6 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
 }
 #endif /* __ARCH_WANT_SYS_OLD_MMAP */
 
-/**
- * unmapped_area() - Find an area between the low_limit and the high_limit with
- * the correct alignment and offset, all from @info. Note: current->mm is used
- * for the search.
- *
- * @info: The unmapped area information including the range [low_limit -
- * high_limit), the alignment offset and mask.
- *
- * Return: A memory address or -ENOMEM.
- */
-static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
-{
-	unsigned long length, gap;
-	unsigned long low_limit, high_limit;
-	struct vm_area_struct *tmp;
-	VMA_ITERATOR(vmi, current->mm, 0);
-
-	/* Adjust search length to account for worst case alignment overhead */
-	length = info->length + info->align_mask + info->start_gap;
-	if (length < info->length)
-		return -ENOMEM;
-
-	low_limit = info->low_limit;
-	if (low_limit < mmap_min_addr)
-		low_limit = mmap_min_addr;
-	high_limit = info->high_limit;
-retry:
-	if (vma_iter_area_lowest(&vmi, low_limit, high_limit, length))
-		return -ENOMEM;
-
-	/*
-	 * Adjust for the gap first so it doesn't interfere with the
-	 * later alignment. The first step is the minimum needed to
-	 * fulill the start gap, the next steps is the minimum to align
-	 * that. It is the minimum needed to fulill both.
-	 */
-	gap = vma_iter_addr(&vmi) + info->start_gap;
-	gap += (info->align_offset - gap) & info->align_mask;
-	tmp = vma_next(&vmi);
-	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
-		if (vm_start_gap(tmp) < gap + length - 1) {
-			low_limit = tmp->vm_end;
-			vma_iter_reset(&vmi);
-			goto retry;
-		}
-	} else {
-		tmp = vma_prev(&vmi);
-		if (tmp && vm_end_gap(tmp) > gap) {
-			low_limit = vm_end_gap(tmp);
-			vma_iter_reset(&vmi);
-			goto retry;
-		}
-	}
-
-	return gap;
-}
-
-/**
- * unmapped_area_topdown() - Find an area between the low_limit and the
- * high_limit with the correct alignment and offset at the highest available
- * address, all from @info. Note: current->mm is used for the search.
- *
- * @info: The unmapped area information including the range [low_limit -
- * high_limit), the alignment offset and mask.
- *
- * Return: A memory address or -ENOMEM.
- */
-static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
-{
-	unsigned long length, gap, gap_end;
-	unsigned long low_limit, high_limit;
-	struct vm_area_struct *tmp;
-	VMA_ITERATOR(vmi, current->mm, 0);
-
-	/* Adjust search length to account for worst case alignment overhead */
-	length = info->length + info->align_mask + info->start_gap;
-	if (length < info->length)
-		return -ENOMEM;
-
-	low_limit = info->low_limit;
-	if (low_limit < mmap_min_addr)
-		low_limit = mmap_min_addr;
-	high_limit = info->high_limit;
-retry:
-	if (vma_iter_area_highest(&vmi, low_limit, high_limit, length))
-		return -ENOMEM;
-
-	gap = vma_iter_end(&vmi) - info->length;
-	gap -= (gap - info->align_offset) & info->align_mask;
-	gap_end = vma_iter_end(&vmi);
-	tmp = vma_next(&vmi);
-	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
-		if (vm_start_gap(tmp) < gap_end) {
-			high_limit = vm_start_gap(tmp);
-			vma_iter_reset(&vmi);
-			goto retry;
-		}
-	} else {
-		tmp = vma_prev(&vmi);
-		if (tmp && vm_end_gap(tmp) > gap) {
-			high_limit = tmp->vm_start;
-			vma_iter_reset(&vmi);
-			goto retry;
-		}
-	}
-
-	return gap;
-}
-
 /*
  * Determine if the allocation needs to ensure that there is no
  * existing mapping within it's guard gaps, for use as start_gap.
--- a/mm/vma.c~mm-vma-move-unmapped_area-internals-to-mm-vmac
+++ a/mm/vma.c
@@ -2563,3 +2563,112 @@ unacct_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
 	return -ENOMEM;
 }
+
+/**
+ * unmapped_area() - Find an area between the low_limit and the high_limit with
+ * the correct alignment and offset, all from @info. Note: current->mm is used
+ * for the search.
+ *
+ * @info: The unmapped area information including the range [low_limit -
+ * high_limit), the alignment offset and mask.
+ *
+ * Return: A memory address or -ENOMEM.
+ */
+unsigned long unmapped_area(struct vm_unmapped_area_info *info)
+{
+	unsigned long length, gap;
+	unsigned long low_limit, high_limit;
+	struct vm_area_struct *tmp;
+	VMA_ITERATOR(vmi, current->mm, 0);
+
+	/* Adjust search length to account for worst case alignment overhead */
+	length = info->length + info->align_mask + info->start_gap;
+	if (length < info->length)
+		return -ENOMEM;
+
+	low_limit = info->low_limit;
+	if (low_limit < mmap_min_addr)
+		low_limit = mmap_min_addr;
+	high_limit = info->high_limit;
+retry:
+	if (vma_iter_area_lowest(&vmi, low_limit, high_limit, length))
+		return -ENOMEM;
+
+	/*
+	 * Adjust for the gap first so it doesn't interfere with the
+	 * later alignment. The first step is the minimum needed to
+	 * fulill the start gap, the next steps is the minimum to align
+	 * that. It is the minimum needed to fulill both.
+	 */
+	gap = vma_iter_addr(&vmi) + info->start_gap;
+	gap += (info->align_offset - gap) & info->align_mask;
+	tmp = vma_next(&vmi);
+	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
+		if (vm_start_gap(tmp) < gap + length - 1) {
+			low_limit = tmp->vm_end;
+			vma_iter_reset(&vmi);
+			goto retry;
+		}
+	} else {
+		tmp = vma_prev(&vmi);
+		if (tmp && vm_end_gap(tmp) > gap) {
+			low_limit = vm_end_gap(tmp);
+			vma_iter_reset(&vmi);
+			goto retry;
+		}
+	}
+
+	return gap;
+}
+
+/**
+ * unmapped_area_topdown() - Find an area between the low_limit and the
+ * high_limit with the correct alignment and offset at the highest available
+ * address, all from @info. Note: current->mm is used for the search.
+ *
+ * @info: The unmapped area information including the range [low_limit -
+ * high_limit), the alignment offset and mask.
+ *
+ * Return: A memory address or -ENOMEM.
+ */
+unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
+{
+	unsigned long length, gap, gap_end;
+	unsigned long low_limit, high_limit;
+	struct vm_area_struct *tmp;
+	VMA_ITERATOR(vmi, current->mm, 0);
+
+	/* Adjust search length to account for worst case alignment overhead */
+	length = info->length + info->align_mask + info->start_gap;
+	if (length < info->length)
+		return -ENOMEM;
+
+	low_limit = info->low_limit;
+	if (low_limit < mmap_min_addr)
+		low_limit = mmap_min_addr;
+	high_limit = info->high_limit;
+retry:
+	if (vma_iter_area_highest(&vmi, low_limit, high_limit, length))
+		return -ENOMEM;
+
+	gap = vma_iter_end(&vmi) - info->length;
+	gap -= (gap - info->align_offset) & info->align_mask;
+	gap_end = vma_iter_end(&vmi);
+	tmp = vma_next(&vmi);
+	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
+		if (vm_start_gap(tmp) < gap_end) {
+			high_limit = vm_start_gap(tmp);
+			vma_iter_reset(&vmi);
+			goto retry;
+		}
+	} else {
+		tmp = vma_prev(&vmi);
+		if (tmp && vm_end_gap(tmp) > gap) {
+			high_limit = tmp->vm_start;
+			vma_iter_reset(&vmi);
+			goto retry;
+		}
+	}
+
+	return gap;
+}
--- a/mm/vma.h~mm-vma-move-unmapped_area-internals-to-mm-vmac
+++ a/mm/vma.h
@@ -250,6 +250,9 @@ unsigned long __mmap_region(struct file
 int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
 		 unsigned long addr, unsigned long request, unsigned long flags);
 
+unsigned long unmapped_area(struct vm_unmapped_area_info *info);
+unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info);
+
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
 	/*
--- a/tools/testing/vma/vma.c~mm-vma-move-unmapped_area-internals-to-mm-vmac
+++ a/tools/testing/vma/vma.c
@@ -18,6 +18,12 @@ static bool fail_prealloc;
 #define vma_iter_prealloc(vmi, vma)					\
 	(fail_prealloc ? -ENOMEM : mas_preallocate(&(vmi)->mas, (vma), GFP_KERNEL))
 
+#define CONFIG_DEFAULT_MMAP_MIN_ADDR 65536
+
+unsigned long mmap_min_addr = CONFIG_DEFAULT_MMAP_MIN_ADDR;
+unsigned long dac_mmap_min_addr = CONFIG_DEFAULT_MMAP_MIN_ADDR;
+unsigned long stack_guard_gap = 256UL<<PAGE_SHIFT;
+
 /*
  * Directly import the VMA implementation here. Our vma_internal.h wrapper
  * provides userland-equivalent functionality for everything vma.c uses.
--- a/tools/testing/vma/vma_internal.h~mm-vma-move-unmapped_area-internals-to-mm-vmac
+++ a/tools/testing/vma/vma_internal.h
@@ -27,6 +27,15 @@
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 
+extern unsigned long stack_guard_gap;
+#ifdef CONFIG_MMU
+extern unsigned long mmap_min_addr;
+extern unsigned long dac_mmap_min_addr;
+#else
+#define mmap_min_addr		0UL
+#define dac_mmap_min_addr	0UL
+#endif
+
 #define VM_WARN_ON(_expr) (WARN_ON(_expr))
 #define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
@@ -52,6 +61,8 @@
 #define VM_STACK	VM_GROWSDOWN
 #define VM_SHADOW_STACK	VM_NONE
 #define VM_SOFTDIRTY	0
+#define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
+#define VM_GROWSUP	VM_NONE
 
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
@@ -66,6 +77,8 @@
 
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
+#define VM_STARTGAP_FLAGS (VM_GROWSDOWN | VM_SHADOW_STACK)
+
 #ifdef CONFIG_64BIT
 /* VM is sealed, in vm_flags */
 #define VM_SEALED	_BITUL(63)
@@ -395,6 +408,17 @@ struct vm_operations_struct {
 					  unsigned long addr);
 };
 
+struct vm_unmapped_area_info {
+#define VM_UNMAPPED_AREA_TOPDOWN 1
+	unsigned long flags;
+	unsigned long length;
+	unsigned long low_limit;
+	unsigned long high_limit;
+	unsigned long align_mask;
+	unsigned long align_offset;
+	unsigned long start_gap;
+};
+
 static inline void vma_iter_invalidate(struct vma_iterator *vmi)
 {
 	mas_pause(&vmi->mas);
@@ -1055,4 +1079,39 @@ static inline int mmap_file(struct file
 	return 0;
 }
 
+static inline unsigned long stack_guard_start_gap(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_GROWSDOWN)
+		return stack_guard_gap;
+
+	/* See reasoning around the VM_SHADOW_STACK definition */
+	if (vma->vm_flags & VM_SHADOW_STACK)
+		return PAGE_SIZE;
+
+	return 0;
+}
+
+static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
+{
+	unsigned long gap = stack_guard_start_gap(vma);
+	unsigned long vm_start = vma->vm_start;
+
+	vm_start -= gap;
+	if (vm_start > vma->vm_start)
+		vm_start = 0;
+	return vm_start;
+}
+
+static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
+{
+	unsigned long vm_end = vma->vm_end;
+
+	if (vma->vm_flags & VM_GROWSUP) {
+		vm_end += stack_guard_gap;
+		if (vm_end < vma->vm_end)
+			vm_end = -PAGE_SIZE;
+	}
+	return vm_end;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

