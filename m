Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF0C7F460
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423588; cv=none; b=uuyfH7PaFcIU84oq5OXiromQXrWT3syG1LOJadGw3ulxY37YJh4Dm3VtVxoT2YlKzbjAsr1SEy8P5THqj0nliLnP6Z+HYOsPcfbhwiorOEyNktZoHSymUcjgrqapZB51xxHyvYp1wqN2LHOnw2EUBXQp+pkq4dQ/dgfh18+qij8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423588; c=relaxed/simple;
	bh=1UKK5AASZCvc9PzHgUkzfYUmGpp7fNazmXjYT5KHGkU=;
	h=Date:To:From:Subject:Message-Id; b=uJBVRUNRPOsAP9DL/EKhKpXr3Hqss6q7eN2IZfOy4NyIT2BVOu1YJKLzY8/JSI9RJ5UtZ67S2VLgbYDjSGLJinud2AShlfgfz4vrChBPeHkqZRb+saodMfT4fPOZlkn2JqweqkrG5MS5HFPUhUdFtFE+jgBF8O3kfgVZ6racIwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ilwqXKwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ilwqXKwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61684C4CEC3;
	Wed,  4 Sep 2024 04:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423588;
	bh=1UKK5AASZCvc9PzHgUkzfYUmGpp7fNazmXjYT5KHGkU=;
	h=Date:To:From:Subject:From;
	b=ilwqXKwch75skS2XRbl1EWGN0kvvJx2aD3YWt2S/20P14/C2LqFAvXzC869GffbdY
	 D0HuW6rDyTWXDG6ABlasXrN4LKRWfopokU5/UMPslaT+cZ/UBofQFBLXv06WUVxa9m
	 yeOXLBLVTxWo7DarGfyVqSocdpg+Uz6FvwAMvmyc=
Date: Tue, 03 Sep 2024 21:19:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch removed from -mm tree
Message-Id: <20240904041948.61684C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make vma_prepare() and friends static and internal to vma.c
has been removed from the -mm tree.  Its filename was
     mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: make vma_prepare() and friends static and internal to vma.c
Date: Fri, 30 Aug 2024 19:10:19 +0100

Now we have abstracted merge behaviour for new VMA ranges, we are able to
render vma_prepare(), init_vma_prep(), vma_complete(),
can_vma_merge_before() and can_vma_merge_after() static and internal to
vma.c.

These are internal implementation details of kernel VMA manipulation and
merging mechanisms and thus should not be exposed.  This also renders the
functions userland testable.

Link: https://lkml.kernel.org/r/7f7f1c34ce10405a6aab2714c505af3cf41b7851.1725040657.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |  318 ++++++++++++++++++++++++++---------------------------
 mm/vma.h |   25 ----
 2 files changed, 158 insertions(+), 185 deletions(-)

--- a/mm/vma.c~mm-make-vma_prepare-and-friends-static-and-internal-to-vmac
+++ a/mm/vma.c
@@ -104,8 +104,7 @@ static void init_multi_vma_prep(struct v
  *
  * We assume the vma may be removed as part of the merge.
  */
-bool
-can_vma_merge_before(struct vma_merge_struct *vmg)
+static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 {
 	pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
 
@@ -127,7 +126,7 @@ can_vma_merge_before(struct vma_merge_st
  *
  * We assume that vma is not removed as part of the merge.
  */
-bool can_vma_merge_after(struct vma_merge_struct *vmg)
+static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 {
 	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
 	    is_mergeable_anon_vma(vmg->anon_vma, vmg->prev->anon_vma, vmg->prev)) {
@@ -137,6 +136,162 @@ bool can_vma_merge_after(struct vma_merg
 	return false;
 }
 
+static void __vma_link_file(struct vm_area_struct *vma,
+			    struct address_space *mapping)
+{
+	if (vma_is_shared_maywrite(vma))
+		mapping_allow_writable(mapping);
+
+	flush_dcache_mmap_lock(mapping);
+	vma_interval_tree_insert(vma, &mapping->i_mmap);
+	flush_dcache_mmap_unlock(mapping);
+}
+
+/*
+ * Requires inode->i_mapping->i_mmap_rwsem
+ */
+static void __remove_shared_vm_struct(struct vm_area_struct *vma,
+				      struct address_space *mapping)
+{
+	if (vma_is_shared_maywrite(vma))
+		mapping_unmap_writable(mapping);
+
+	flush_dcache_mmap_lock(mapping);
+	vma_interval_tree_remove(vma, &mapping->i_mmap);
+	flush_dcache_mmap_unlock(mapping);
+}
+
+/*
+ * vma_prepare() - Helper function for handling locking VMAs prior to altering
+ * @vp: The initialized vma_prepare struct
+ */
+static void vma_prepare(struct vma_prepare *vp)
+{
+	if (vp->file) {
+		uprobe_munmap(vp->vma, vp->vma->vm_start, vp->vma->vm_end);
+
+		if (vp->adj_next)
+			uprobe_munmap(vp->adj_next, vp->adj_next->vm_start,
+				      vp->adj_next->vm_end);
+
+		i_mmap_lock_write(vp->mapping);
+		if (vp->insert && vp->insert->vm_file) {
+			/*
+			 * Put into interval tree now, so instantiated pages
+			 * are visible to arm/parisc __flush_dcache_page
+			 * throughout; but we cannot insert into address
+			 * space until vma start or end is updated.
+			 */
+			__vma_link_file(vp->insert,
+					vp->insert->vm_file->f_mapping);
+		}
+	}
+
+	if (vp->anon_vma) {
+		anon_vma_lock_write(vp->anon_vma);
+		anon_vma_interval_tree_pre_update_vma(vp->vma);
+		if (vp->adj_next)
+			anon_vma_interval_tree_pre_update_vma(vp->adj_next);
+	}
+
+	if (vp->file) {
+		flush_dcache_mmap_lock(vp->mapping);
+		vma_interval_tree_remove(vp->vma, &vp->mapping->i_mmap);
+		if (vp->adj_next)
+			vma_interval_tree_remove(vp->adj_next,
+						 &vp->mapping->i_mmap);
+	}
+
+}
+
+/*
+ * vma_complete- Helper function for handling the unlocking after altering VMAs,
+ * or for inserting a VMA.
+ *
+ * @vp: The vma_prepare struct
+ * @vmi: The vma iterator
+ * @mm: The mm_struct
+ */
+static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
+			 struct mm_struct *mm)
+{
+	if (vp->file) {
+		if (vp->adj_next)
+			vma_interval_tree_insert(vp->adj_next,
+						 &vp->mapping->i_mmap);
+		vma_interval_tree_insert(vp->vma, &vp->mapping->i_mmap);
+		flush_dcache_mmap_unlock(vp->mapping);
+	}
+
+	if (vp->remove && vp->file) {
+		__remove_shared_vm_struct(vp->remove, vp->mapping);
+		if (vp->remove2)
+			__remove_shared_vm_struct(vp->remove2, vp->mapping);
+	} else if (vp->insert) {
+		/*
+		 * split_vma has split insert from vma, and needs
+		 * us to insert it before dropping the locks
+		 * (it may either follow vma or precede it).
+		 */
+		vma_iter_store(vmi, vp->insert);
+		mm->map_count++;
+	}
+
+	if (vp->anon_vma) {
+		anon_vma_interval_tree_post_update_vma(vp->vma);
+		if (vp->adj_next)
+			anon_vma_interval_tree_post_update_vma(vp->adj_next);
+		anon_vma_unlock_write(vp->anon_vma);
+	}
+
+	if (vp->file) {
+		i_mmap_unlock_write(vp->mapping);
+		uprobe_mmap(vp->vma);
+
+		if (vp->adj_next)
+			uprobe_mmap(vp->adj_next);
+	}
+
+	if (vp->remove) {
+again:
+		vma_mark_detached(vp->remove, true);
+		if (vp->file) {
+			uprobe_munmap(vp->remove, vp->remove->vm_start,
+				      vp->remove->vm_end);
+			fput(vp->file);
+		}
+		if (vp->remove->anon_vma)
+			anon_vma_merge(vp->vma, vp->remove);
+		mm->map_count--;
+		mpol_put(vma_policy(vp->remove));
+		if (!vp->remove2)
+			WARN_ON_ONCE(vp->vma->vm_end < vp->remove->vm_end);
+		vm_area_free(vp->remove);
+
+		/*
+		 * In mprotect's case 6 (see comments on vma_merge),
+		 * we are removing both mid and next vmas
+		 */
+		if (vp->remove2) {
+			vp->remove = vp->remove2;
+			vp->remove2 = NULL;
+			goto again;
+		}
+	}
+	if (vp->insert && vp->file)
+		uprobe_mmap(vp->insert);
+}
+
+/*
+ * init_vma_prep() - Initializer wrapper for vma_prepare struct
+ * @vp: The vma_prepare struct
+ * @vma: The vma that will be altered once locked
+ */
+static void init_vma_prep(struct vma_prepare *vp, struct vm_area_struct *vma)
+{
+	init_multi_vma_prep(vp, vma, NULL, NULL, NULL);
+}
+
 /*
  * Can the proposed VMA be merged with the left (previous) VMA taking into
  * account the start position of the proposed range.
@@ -316,31 +471,6 @@ static int split_vma(struct vma_iterator
 }
 
 /*
- * init_vma_prep() - Initializer wrapper for vma_prepare struct
- * @vp: The vma_prepare struct
- * @vma: The vma that will be altered once locked
- */
-void init_vma_prep(struct vma_prepare *vp,
-		   struct vm_area_struct *vma)
-{
-	init_multi_vma_prep(vp, vma, NULL, NULL, NULL);
-}
-
-/*
- * Requires inode->i_mapping->i_mmap_rwsem
- */
-static void __remove_shared_vm_struct(struct vm_area_struct *vma,
-				      struct address_space *mapping)
-{
-	if (vma_is_shared_maywrite(vma))
-		mapping_unmap_writable(mapping);
-
-	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_remove(vma, &mapping->i_mmap);
-	flush_dcache_mmap_unlock(mapping);
-}
-
-/*
  * vma has some anon_vma assigned, and is already inserted on that
  * anon_vma's interval trees.
  *
@@ -372,60 +502,6 @@ anon_vma_interval_tree_post_update_vma(s
 		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
 }
 
-static void __vma_link_file(struct vm_area_struct *vma,
-			    struct address_space *mapping)
-{
-	if (vma_is_shared_maywrite(vma))
-		mapping_allow_writable(mapping);
-
-	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_insert(vma, &mapping->i_mmap);
-	flush_dcache_mmap_unlock(mapping);
-}
-
-/*
- * vma_prepare() - Helper function for handling locking VMAs prior to altering
- * @vp: The initialized vma_prepare struct
- */
-void vma_prepare(struct vma_prepare *vp)
-{
-	if (vp->file) {
-		uprobe_munmap(vp->vma, vp->vma->vm_start, vp->vma->vm_end);
-
-		if (vp->adj_next)
-			uprobe_munmap(vp->adj_next, vp->adj_next->vm_start,
-				      vp->adj_next->vm_end);
-
-		i_mmap_lock_write(vp->mapping);
-		if (vp->insert && vp->insert->vm_file) {
-			/*
-			 * Put into interval tree now, so instantiated pages
-			 * are visible to arm/parisc __flush_dcache_page
-			 * throughout; but we cannot insert into address
-			 * space until vma start or end is updated.
-			 */
-			__vma_link_file(vp->insert,
-					vp->insert->vm_file->f_mapping);
-		}
-	}
-
-	if (vp->anon_vma) {
-		anon_vma_lock_write(vp->anon_vma);
-		anon_vma_interval_tree_pre_update_vma(vp->vma);
-		if (vp->adj_next)
-			anon_vma_interval_tree_pre_update_vma(vp->adj_next);
-	}
-
-	if (vp->file) {
-		flush_dcache_mmap_lock(vp->mapping);
-		vma_interval_tree_remove(vp->vma, &vp->mapping->i_mmap);
-		if (vp->adj_next)
-			vma_interval_tree_remove(vp->adj_next,
-						 &vp->mapping->i_mmap);
-	}
-
-}
-
 /*
  * dup_anon_vma() - Helper function to duplicate anon_vma
  * @dst: The destination VMA
@@ -715,84 +791,6 @@ int vma_shrink(struct vma_iterator *vmi,
 	return 0;
 }
 
-/*
- * vma_complete- Helper function for handling the unlocking after altering VMAs,
- * or for inserting a VMA.
- *
- * @vp: The vma_prepare struct
- * @vmi: The vma iterator
- * @mm: The mm_struct
- */
-void vma_complete(struct vma_prepare *vp,
-		  struct vma_iterator *vmi, struct mm_struct *mm)
-{
-	if (vp->file) {
-		if (vp->adj_next)
-			vma_interval_tree_insert(vp->adj_next,
-						 &vp->mapping->i_mmap);
-		vma_interval_tree_insert(vp->vma, &vp->mapping->i_mmap);
-		flush_dcache_mmap_unlock(vp->mapping);
-	}
-
-	if (vp->remove && vp->file) {
-		__remove_shared_vm_struct(vp->remove, vp->mapping);
-		if (vp->remove2)
-			__remove_shared_vm_struct(vp->remove2, vp->mapping);
-	} else if (vp->insert) {
-		/*
-		 * split_vma has split insert from vma, and needs
-		 * us to insert it before dropping the locks
-		 * (it may either follow vma or precede it).
-		 */
-		vma_iter_store(vmi, vp->insert);
-		mm->map_count++;
-	}
-
-	if (vp->anon_vma) {
-		anon_vma_interval_tree_post_update_vma(vp->vma);
-		if (vp->adj_next)
-			anon_vma_interval_tree_post_update_vma(vp->adj_next);
-		anon_vma_unlock_write(vp->anon_vma);
-	}
-
-	if (vp->file) {
-		i_mmap_unlock_write(vp->mapping);
-		uprobe_mmap(vp->vma);
-
-		if (vp->adj_next)
-			uprobe_mmap(vp->adj_next);
-	}
-
-	if (vp->remove) {
-again:
-		vma_mark_detached(vp->remove, true);
-		if (vp->file) {
-			uprobe_munmap(vp->remove, vp->remove->vm_start,
-				      vp->remove->vm_end);
-			fput(vp->file);
-		}
-		if (vp->remove->anon_vma)
-			anon_vma_merge(vp->vma, vp->remove);
-		mm->map_count--;
-		mpol_put(vma_policy(vp->remove));
-		if (!vp->remove2)
-			WARN_ON_ONCE(vp->vma->vm_end < vp->remove->vm_end);
-		vm_area_free(vp->remove);
-
-		/*
-		 * In mprotect's case 6 (see comments on vma_merge),
-		 * we are removing both mid and next vmas
-		 */
-		if (vp->remove2) {
-			vp->remove = vp->remove2;
-			vp->remove2 = NULL;
-			goto again;
-		}
-	}
-	if (vp->insert && vp->file)
-		uprobe_mmap(vp->insert);
-}
-
 static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 		    struct ma_state *mas_detach, bool mm_wr_locked)
 {
--- a/mm/vma.h~mm-make-vma_prepare-and-friends-static-and-internal-to-vmac
+++ a/mm/vma.h
@@ -132,17 +132,6 @@ void anon_vma_interval_tree_pre_update_v
 /* Required for expand_downwards(). */
 void anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma);
 
-/* Required for do_brk_flags(). */
-void vma_prepare(struct vma_prepare *vp);
-
-/* Required for do_brk_flags(). */
-void init_vma_prep(struct vma_prepare *vp,
-		   struct vm_area_struct *vma);
-
-/* Required for do_brk_flags(). */
-void vma_complete(struct vma_prepare *vp,
-		  struct vma_iterator *vmi, struct mm_struct *mm);
-
 int vma_expand(struct vma_merge_struct *vmg);
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff);
@@ -277,20 +266,6 @@ void remove_vma(struct vm_area_struct *v
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
-/*
- * Can we merge the VMA described by vmg into the following VMA vmg->next?
- *
- * Required by mmap_region().
- */
-bool can_vma_merge_before(struct vma_merge_struct *vmg);
-
-/*
- * Can we merge the VMA described by vmg into the preceding VMA vmg->prev?
- *
- * Required by mmap_region() and do_brk_flags().
- */
-bool can_vma_merge_after(struct vma_merge_struct *vmg);
-
 /* We are about to modify the VMA's flags. */
 struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
 		struct vm_area_struct *prev, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


