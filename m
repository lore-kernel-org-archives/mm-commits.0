Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0DF2F433F
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 04:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749789563; cv=none; b=cIn+0t5/Hi/+vZgszYzeqfFbiEyFPd+ilaruRC170FDnXjfvQUTmevWDBs5k9BjFvn94bXU3jO7Mc345jnexTEJBpK90EnTMvdffBNywkeb9tBZBiah8VqzGWKFOxftqSzFTqncrCW83VgNI9Xpvyg43W+Ea9aXjiXVHMQoPSaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749789563; c=relaxed/simple;
	bh=wEAN3u7VkomD5L1MijmGTl0yVjSmBa8P6lDlRm/1toI=;
	h=Date:To:From:Subject:Message-Id; b=mERMsHjknZPRbDc2f1EQ6VJbiJWiVCp/SbysRGqMhkHP1lhaGU+WrIJVuUbohNEVv0boaX1qyfTD39iBxyRf4/RL07nFAuUsjm9j1JLI7Hiwim3+Jio32+GCswckVqzzZfB4sHKnHM5HrLMlBwtApazuXP21+j2oQ5pgw7LD6XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T4gRkoo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T4gRkoo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4882BC4CEE3;
	Fri, 13 Jun 2025 04:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749789563;
	bh=wEAN3u7VkomD5L1MijmGTl0yVjSmBa8P6lDlRm/1toI=;
	h=Date:To:From:Subject:From;
	b=T4gRkoo/cR7iW2JmP30HVPwxznxujfndRu8TJKgB2we2NPnpBO8Pu2gVx87o/kCGB
	 VvNQ8BvOP5SMmxIATAYNb0RFZ67me4z77a5M1fdZTPkhuQNrsI/DOSrx5j+lghyh4r
	 lLLYpO9FZ6bVSnksmEHSO1eoOnMLQz90ygFcypMU=
Date: Thu, 12 Jun 2025 21:39:22 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,pfalcato@suse.de,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch removed from -mm tree
Message-Id: <20250613043923.4882BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add mmap_prepare() compatibility layer for nested file systems
has been removed from the -mm tree.  Its filename was
     mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: add mmap_prepare() compatibility layer for nested file systems
Date: Mon, 9 Jun 2025 17:57:49 +0100

Nested file systems, that is those which invoke call_mmap() within their
own f_op->mmap() handlers, may encounter underlying file systems which
provide the f_op->mmap_prepare() hook introduced by commit c84bf6dd2b83
("mm: introduce new .mmap_prepare() file callback").

We have a chicken-and-egg scenario here - until all file systems are
converted to using .mmap_prepare(), we cannot convert these nested
handlers, as we can't call f_op->mmap from an .mmap_prepare() hook.

So we have to do it the other way round - invoke the .mmap_prepare() hook
from an .mmap() one.

in order to do so, we need to convert VMA state into a struct vm_area_desc
descriptor, invoking the underlying file system's f_op->mmap_prepare()
callback passing a pointer to this, and then setting VMA state accordingly
and safely.

This patch achieves this via the compat_vma_mmap_prepare() function, which
we invoke from call_mmap() if f_op->mmap_prepare() is specified in the
passed in file pointer.

We place the fundamental logic into mm/vma.h where VMA manipulation
belongs.  We also update the VMA userland tests to accommodate the
changes.

The compat_vma_mmap_prepare() function and its associated machinery is
temporary, and will be removed once the conversion of file systems is
complete.

We carefully place this code so it can be used with CONFIG_MMU and also
with cutting edge nommu silicon.

[akpm@linux-foundation.org: export compat_vma_mmap_prepare tp fix build]
[lorenzo.stoakes@oracle.com: remove unused declarations]
  Link: https://lkml.kernel.org/r/ac3ae324-4c65-432a-8c6d-2af988b18ac8@lucifer.local
Link: https://lkml.kernel.org/r/20250609165749.344976-1-lorenzo.stoakes@oracle.com
Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback").
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Closes: https://lore.kernel.org/linux-mm/CAG48ez04yOEVx1ekzOChARDDBZzAKwet8PEoPM4Ln3_rk91AzQ@mail.gmail.com/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h               |    6 ++-
 mm/util.c                        |   40 ++++++++++++++++++++++++
 mm/vma.c                         |    1 
 mm/vma.h                         |   47 +++++++++++++++++++++++++++++
 tools/testing/vma/vma_internal.h |   16 +++++++++
 5 files changed, 107 insertions(+), 3 deletions(-)

--- a/include/linux/fs.h~mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems
+++ a/include/linux/fs.h
@@ -2274,10 +2274,12 @@ static inline bool file_has_valid_mmap_h
 	return true;
 }
 
+int compat_vma_mmap_prepare(struct file *file, struct vm_area_struct *vma);
+
 static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if (WARN_ON_ONCE(file->f_op->mmap_prepare))
-		return -EINVAL;
+	if (file->f_op->mmap_prepare)
+		return compat_vma_mmap_prepare(file, vma);
 
 	return file->f_op->mmap(file, vma);
 }
--- a/mm/util.c~mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems
+++ a/mm/util.c
@@ -1131,3 +1131,43 @@ void flush_dcache_folio(struct folio *fo
 }
 EXPORT_SYMBOL(flush_dcache_folio);
 #endif
+
+/**
+ * compat_vma_mmap_prepare() - Apply the file's .mmap_prepare() hook to an
+ * existing VMA
+ * @file: The file which possesss an f_op->mmap_prepare() hook
+ * @vma: The VMA to apply the .mmap_prepare() hook to.
+ *
+ * Ordinarily, .mmap_prepare() is invoked directly upon mmap(). However, certain
+ * 'wrapper' file systems invoke a nested mmap hook of an underlying file.
+ *
+ * Until all filesystems are converted to use .mmap_prepare(), we must be
+ * conservative and continue to invoke these 'wrapper' filesystems using the
+ * deprecated .mmap() hook.
+ *
+ * However we have a problem if the underlying file system possesses an
+ * .mmap_prepare() hook, as we are in a different context when we invoke the
+ * .mmap() hook, already having a VMA to deal with.
+ *
+ * compat_vma_mmap_prepare() is a compatibility function that takes VMA state,
+ * establishes a struct vm_area_desc descriptor, passes to the underlying
+ * .mmap_prepare() hook and applies any changes performed by it.
+ *
+ * Once the conversion of filesystems is complete this function will no longer
+ * be required and will be removed.
+ *
+ * Returns: 0 on success or error.
+ */
+int compat_vma_mmap_prepare(struct file *file, struct vm_area_struct *vma)
+{
+	struct vm_area_desc desc;
+	int err;
+
+	err = file->f_op->mmap_prepare(vma_to_desc(vma, &desc));
+	if (err)
+		return err;
+	set_vma_from_desc(vma, &desc);
+
+	return 0;
+}
+EXPORT_SYMBOL(compat_vma_mmap_prepare);
--- a/mm/vma.c~mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems
+++ a/mm/vma.c
@@ -3113,7 +3113,6 @@ int __vm_munmap(unsigned long start, siz
 	return ret;
 }
 
-
 /* Insert vm structure into process list sorted by address
  * and into the inode's i_mmap tree.  If vm_file is non-NULL
  * then i_mmap_rwsem is taken here.
--- a/mm/vma.h~mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems
+++ a/mm/vma.h
@@ -222,6 +222,53 @@ static inline int vma_iter_store_gfp(str
 	return 0;
 }
 
+
+/*
+ * Temporary helper functions for file systems which wrap an invocation of
+ * f_op->mmap() but which might have an underlying file system which implements
+ * f_op->mmap_prepare().
+ */
+
+static inline struct vm_area_desc *vma_to_desc(struct vm_area_struct *vma,
+		struct vm_area_desc *desc)
+{
+	desc->mm = vma->vm_mm;
+	desc->start = vma->vm_start;
+	desc->end = vma->vm_end;
+
+	desc->pgoff = vma->vm_pgoff;
+	desc->file = vma->vm_file;
+	desc->vm_flags = vma->vm_flags;
+	desc->page_prot = vma->vm_page_prot;
+
+	desc->vm_ops = NULL;
+	desc->private_data = NULL;
+
+	return desc;
+}
+
+static inline void set_vma_from_desc(struct vm_area_struct *vma,
+		struct vm_area_desc *desc)
+{
+	/*
+	 * Since we're invoking .mmap_prepare() despite having a partially
+	 * established VMA, we must take care to handle setting fields
+	 * correctly.
+	 */
+
+	/* Mutable fields. Populated with initial state. */
+	vma->vm_pgoff = desc->pgoff;
+	if (vma->vm_file != desc->file)
+		vma_set_file(vma, desc->file);
+	if (vma->vm_flags != desc->vm_flags)
+		vm_flags_set(vma, desc->vm_flags);
+	vma->vm_page_prot = desc->page_prot;
+
+	/* User-defined fields. */
+	vma->vm_ops = desc->vm_ops;
+	vma->vm_private_data = desc->private_data;
+}
+
 int
 do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		    struct mm_struct *mm, unsigned long start,
--- a/tools/testing/vma/vma_internal.h~mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems
+++ a/tools/testing/vma/vma_internal.h
@@ -159,6 +159,14 @@ typedef __bitwise unsigned int vm_fault_
 
 #define ASSERT_EXCLUSIVE_WRITER(x)
 
+/**
+ * swap - swap values of @a and @b
+ * @a: first value
+ * @b: second value
+ */
+#define swap(a, b) \
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+
 struct kref {
 	refcount_t refcount;
 };
@@ -1468,4 +1476,12 @@ static inline void fixup_hugetlb_reserva
 	(void)vma;
 }
 
+static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
+{
+	/* Changing an anonymous vma with this is illegal */
+	get_file(file);
+	swap(vma->vm_file, file);
+	fput(file);
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch

