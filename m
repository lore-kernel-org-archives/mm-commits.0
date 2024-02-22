Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A254A18
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560066; cv=none; b=W8ntSdSCJsoQX859twM3JLzVhwAKEy5p4/Wkwz9hqyw3EAWV7PhX0Cu2Zfq/6QQtH6ILMa+NBYifBsUCXpUkegBRBHurcDaZ+pAb6m2SMfalIwb3/rkdxC2D+KL+h2xXN3+Too2ZL1Zf4eb2Cm01PNAIS6uKJ6SCT6RhgazjEDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560066; c=relaxed/simple;
	bh=exho+WhLTmsqHawwEz14kr7VJXLPNtxs1/QePM368wI=;
	h=Date:To:From:Subject:Message-Id; b=Pg7pBnAoxkW2qhENYUvZLpEy4Tj9PCqsMlJzftZ5UUbHiWTKMQ6z/r0862yKlRsG5k1q/X+/JuxstciIdmrOqHznVqD3BjLntpB/ilSvPNmZ+d5iALCX9uq7Kczqv3p3mjLhXL+pexJW/q0H9j+KcsFdIDuHfcy449Eu8CSrgoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hCfdseQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hCfdseQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67675C43399;
	Thu, 22 Feb 2024 00:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560065;
	bh=exho+WhLTmsqHawwEz14kr7VJXLPNtxs1/QePM368wI=;
	h=Date:To:From:Subject:From;
	b=hCfdseQH81ZKVUYYiiX0bQjSFNZQdV2FiomERhYPBSm84GUU5KFwKlhemceXJY6E4
	 kB6EMmydEbsP7aDb0xA+K6fXlQlWMb+wXg4lfCn7ho5z1VFvaIYXezA1JGJ6rWyXNm
	 ZA4zro1GlFny5deojHtvPHarOhDkM+cVVPsLXmvs=
Date: Wed, 21 Feb 2024 16:01:04 -0800
To: mm-commits@vger.kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-simplify-vma-link-and-unlink.patch removed from -mm tree
Message-Id: <20240222000105.67675C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: simplify vma link and unlink
has been removed from the -mm tree.  Its filename was
     mm-mmap-simplify-vma-link-and-unlink.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: simplify vma link and unlink
Date: Wed, 10 Jan 2024 16:46:22 +0800

The file parameter in the __remove_shared_vm_struct is no longer used,
remove it.

These functions vma_link() and mmap_region() have some of the same code,
introduce vma_link_file() helper function to simplify the code.

Link: https://lkml.kernel.org/r/20240110084622.2425927-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/mm/mmap.c~mm-mmap-simplify-vma-link-and-unlink
+++ a/mm/mmap.c
@@ -105,7 +105,7 @@ void vma_set_page_prot(struct vm_area_st
  * Requires inode->i_mapping->i_mmap_rwsem
  */
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
-		struct file *file, struct address_space *mapping)
+				      struct address_space *mapping)
 {
 	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
@@ -126,7 +126,7 @@ void unlink_file_vma(struct vm_area_stru
 	if (file) {
 		struct address_space *mapping = file->f_mapping;
 		i_mmap_lock_write(mapping);
-		__remove_shared_vm_struct(vma, file, mapping);
+		__remove_shared_vm_struct(vma, mapping);
 		i_mmap_unlock_write(mapping);
 	}
 }
@@ -392,26 +392,30 @@ static void __vma_link_file(struct vm_ar
 	flush_dcache_mmap_unlock(mapping);
 }
 
+static void vma_link_file(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct address_space *mapping;
+
+	if (file) {
+		mapping = file->f_mapping;
+		i_mmap_lock_write(mapping);
+		__vma_link_file(vma, mapping);
+		i_mmap_unlock_write(mapping);
+	}
+}
+
 static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	VMA_ITERATOR(vmi, mm, 0);
-	struct address_space *mapping = NULL;
 
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
 	vma_start_write(vma);
-
 	vma_iter_store(&vmi, vma);
-
-	if (vma->vm_file) {
-		mapping = vma->vm_file->f_mapping;
-		i_mmap_lock_write(mapping);
-		__vma_link_file(vma, mapping);
-		i_mmap_unlock_write(mapping);
-	}
-
+	vma_link_file(vma);
 	mm->map_count++;
 	validate_mm(mm);
 	return 0;
@@ -519,10 +523,9 @@ static inline void vma_complete(struct v
 	}
 
 	if (vp->remove && vp->file) {
-		__remove_shared_vm_struct(vp->remove, vp->file, vp->mapping);
+		__remove_shared_vm_struct(vp->remove, vp->mapping);
 		if (vp->remove2)
-			__remove_shared_vm_struct(vp->remove2, vp->file,
-						  vp->mapping);
+			__remove_shared_vm_struct(vp->remove2, vp->mapping);
 	} else if (vp->insert) {
 		/*
 		 * split_vma has split insert from vma, and needs
@@ -2891,16 +2894,7 @@ cannot_expand:
 	vma_start_write(vma);
 	vma_iter_store(&vmi, vma);
 	mm->map_count++;
-	if (vma->vm_file) {
-		i_mmap_lock_write(vma->vm_file->f_mapping);
-		if (vma_is_shared_maywrite(vma))
-			mapping_allow_writable(vma->vm_file->f_mapping);
-
-		flush_dcache_mmap_lock(vma->vm_file->f_mapping);
-		vma_interval_tree_insert(vma, &vma->vm_file->f_mapping->i_mmap);
-		flush_dcache_mmap_unlock(vma->vm_file->f_mapping);
-		i_mmap_unlock_write(vma->vm_file->f_mapping);
-	}
+	vma_link_file(vma);
 
 	/*
 	 * vma_merge() calls khugepaged_enter_vma() either, the below
_

Patches currently in -mm which might be from yajun.deng@linux.dev are


