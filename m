Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699F6204083
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409658; cv=none; b=i8OM2i6HfXdY9FTEhhTi+ewO7wSfOtQ5G8ugxZvsDb0vYVWaPsnh5/zMSD9ByrbeMog3Spbp5VqECupkErkqJezuoh1gpKjFVktb+3T9FRuWF+FdXN6/y7Ic5DE3fqVLnG2PU4VGjtaR/FjL2fIsxfVVsNKdv3WN24sZLSCc61c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409658; c=relaxed/simple;
	bh=VA6nafuu/uWg9gFGHThT5aLrtxetUEPl0HVXW2b4XiM=;
	h=Date:To:From:Subject:Message-Id; b=fvyuzXsNDLIg8ilR1Tamde54GM4f2Z/tNml5X3NPKQzc4mr4Y8t+briby9BSowVARkA8CDh/DzdBEQ1zOCLcxLkvAk4dNXSukZwyeqab0pyn/xf2hcEZsw6KsH3p5P1qOfehbjMPHwP/03drsB5qvAYFgL+O7wekzaYlXFhuftc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SOxAqnVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SOxAqnVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35C5C4CEED;
	Fri, 25 Jul 2025 02:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409658;
	bh=VA6nafuu/uWg9gFGHThT5aLrtxetUEPl0HVXW2b4XiM=;
	h=Date:To:From:Subject:From;
	b=SOxAqnViizTSQ+Ck2+esuK9RjiTqWe+40L+ZOuYeEd53jQRtt2GKvAaKdIz9Ehb0u
	 Z20L7y7b9wj4wODOCcPqNsDszyAUYtmRTycD1659Kqzn3OyGVIU6g8bk8n7hwJMhL2
	 Ncqa3Q7SyrO2ucOFjPltIkF3tY9UsyLc7oNUHRYE=
Date: Thu, 24 Jul 2025 19:14:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch removed from -mm tree
Message-Id: <20250725021417.F35C5C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: refactor vma_modify_flags_name() to vma_modify_name()
has been removed from the -mm tree.  Its filename was
     mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: refactor vma_modify_flags_name() to vma_modify_name()
Date: Mon, 14 Jul 2025 14:58:39 +0100

The single instance in which we use this function doesn't actually need to
change VMA flags, so remove this parameter and update the caller
accordingly.

[lorenzo.stoakes@oracle.com: correct comment]
  Link: https://lkml.kernel.org/r/77f45b2e-a748-4635-9381-a5051091087f@lucifer.local
Link: https://lkml.kernel.org/r/20250714135839.178032-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    8 ++++----
 mm/vma.c     |    4 +---
 mm/vma.h     |   15 +++++++--------
 3 files changed, 12 insertions(+), 15 deletions(-)

--- a/mm/madvise.c~mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name
+++ a/mm/madvise.c
@@ -144,8 +144,8 @@ static int replace_anon_vma_name(struct
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 /*
- * Update the vm_flags and/or anon_name on region of a vma, splitting it or
- * merging it as necessary. Must be called with mmap_lock held for writing.
+ * Update the vm_flags or anon_name on region of a vma, splitting it or merging
+ * it as necessary. Must be called with mmap_lock held for writing.
  */
 static int madvise_update_vma(vm_flags_t new_flags,
 		struct madvise_behavior *madv_behavior)
@@ -161,8 +161,8 @@ static int madvise_update_vma(vm_flags_t
 		return 0;
 
 	if (set_new_anon_name)
-		vma = vma_modify_flags_name(&vmi, madv_behavior->prev, vma,
-			range->start, range->end, new_flags, anon_name);
+		vma = vma_modify_name(&vmi, madv_behavior->prev, vma,
+			range->start, range->end, anon_name);
 	else
 		vma = vma_modify_flags(&vmi, madv_behavior->prev, vma,
 			range->start, range->end, new_flags);
--- a/mm/vma.c~mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name
+++ a/mm/vma.c
@@ -1650,17 +1650,15 @@ struct vm_area_struct *vma_modify_flags(
 }
 
 struct vm_area_struct
-*vma_modify_flags_name(struct vma_iterator *vmi,
+*vma_modify_name(struct vma_iterator *vmi,
 		       struct vm_area_struct *prev,
 		       struct vm_area_struct *vma,
 		       unsigned long start,
 		       unsigned long end,
-		       vm_flags_t vm_flags,
 		       struct anon_vma_name *new_name)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
-	vmg.vm_flags = vm_flags;
 	vmg.anon_name = new_name;
 
 	return vma_modify(&vmg);
--- a/mm/vma.h~mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name
+++ a/mm/vma.h
@@ -290,15 +290,14 @@ __must_check struct vm_area_struct
 		unsigned long start, unsigned long end,
 		vm_flags_t vm_flags);
 
-/* We are about to modify the VMA's flags and/or anon_name. */
+/* We are about to modify the VMA's anon_name. */
 __must_check struct vm_area_struct
-*vma_modify_flags_name(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start,
-		       unsigned long end,
-		       vm_flags_t vm_flags,
-		       struct anon_vma_name *new_name);
+*vma_modify_name(struct vma_iterator *vmi,
+		 struct vm_area_struct *prev,
+		 struct vm_area_struct *vma,
+		 unsigned long start,
+		 unsigned long end,
+		 struct anon_vma_name *new_name);
 
 /* We are about to modify the VMA's memory policy. */
 __must_check struct vm_area_struct
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch

