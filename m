Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE312E7BC9
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 20:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756933030; cv=none; b=WPmaVey+4YPgkVmQ9EH6VakLetTjaiO1k8ZA0d/ayXjDm6QtGK3p2ptIn1syyZCwA41VKDOP3Wmvbq1NmE9/9aJwxWQ40sGxJXWfFyvagUTh6TXdS/8rTX2Sbh4YRfGHRvTvbVKnUmedXr2WrH3J1bq80Dluzl/684kkuS4PcQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756933030; c=relaxed/simple;
	bh=3NLUb4XsXhvFL6P8JnE5LxSNfN4BXaNYWh12nFcUo2c=;
	h=Date:To:From:Subject:Message-Id; b=IyyDFBkw+a6BpSQthZZVlpcfaDhOsZbui6MYGV60CslTR4KwEVdRwc85/cQ1tYpcnYFqbLQ3F3TKELvk5O2g4FwHWAqWwTI94kmSCHbNakj+lyQhK+Y2UUHyhapItuyt9kE59U07btxHF3srVbHst+V4C2aj+NrBVP7lrYM9l8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IU24HYaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IU24HYaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0043C4CEE7;
	Wed,  3 Sep 2025 20:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756933029;
	bh=3NLUb4XsXhvFL6P8JnE5LxSNfN4BXaNYWh12nFcUo2c=;
	h=Date:To:From:Subject:From;
	b=IU24HYaWopT0HaelZ4b/qLfGLBMXffHjBFZdHioKUy8aYRRLqAcpc51DdHE+WPnFW
	 pG4MDry0sJ3oDGpVbv9QyD1qv/bN3BvTopgcLmzPD4Ykg+uZ53Gx6B+ZNe/YigsPa4
	 lX27RnrxzFkwO5EWD0sUxBcTNbrtLCnyOwcBYu9k=
Date: Wed, 03 Sep 2025 13:57:09 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch added to mm-new branch
Message-Id: <20250903205709.A0043C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: do not assume file == vma->vm_file in compat_vma_mmap_prepare()
has been added to the -mm mm-new branch.  Its filename is
     mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: do not assume file == vma->vm_file in compat_vma_mmap_prepare()
Date: Wed, 3 Sep 2025 18:48:42 +0100

In commit bb666b7c2707 ("mm: add mmap_prepare() compatibility layer for
nested file systems") we introduced the ability for stacked drivers and
file systems to correctly invoke the f_op->mmap_prepare() handler from an
f_op->mmap() handler via a compatibility layer implemented in
compat_vma_mmap_prepare().

This populates vm_area_desc fields according to those found in the (not
yet fully initialised) VMA passed to f_op->mmap().

However this function implicitly assumes that the struct file which we are
operating upon is equal to vma->vm_file.  This is not a safe assumption in
all cases.

The only really sane situation in which this matters would be something
like e.g.  i915_gem_dmabuf_mmap() which invokes vfs_mmap() against
obj->base.filp:

	ret = vfs_mmap(obj->base.filp, vma);
	if (ret)
		return ret;

And then sets the VMA's file to this, should the mmap operation succeed:

	vma_set_file(vma, obj->base.filp);

That is - it is the file that is intended to back the VMA mapping.

This is not an issue currently, as so far we have only implemented
f_op->mmap_prepare() handlers for some file systems and internal mm uses,
and the only stacked f_op->mmap() operations that can be performed upon
these are those in backing_file_mmap() and coda_file_mmap(), both of which
use vma->vm_file.

However, moving forward, as we convert drivers to using
f_op->mmap_prepare(), this will become a problem.

Resolve this issue by explicitly setting desc->file to the provided file
parameter and update callers accordingly.

Callers are expected to read desc->file and update desc->vm_file - the
former will be the file provided by the caller (if stacked, this may
differ from vma->vm_file).

If the caller needs to differentiate between the two they therefore now
can.

While we are here, also provide a variant of compat_vma_mmap_prepare()
that operates against a pointer to any file_operations struct and does not
assume that the file_operations struct we are interested in is file->f_op.

This function is __compat_vma_mmap_prepare() and we invoke it from
compat_vma_mmap_prepare() so that we share code between the two functions.

This is important, because some drivers provide hooks in a separate
struct, for instance struct drm_device provides an fops field for this
purpose.

Also update the VMA selftests accordingly.

Link: https://lkml.kernel.org/r/dd0c72df8a33e8ffaa243eeb9b01010b670610e9.1756920635.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h               |    2 
 mm/util.c                        |   62 ++++++++++++++++++-----------
 tools/testing/vma/vma_internal.h |   12 ++++-
 3 files changed, 50 insertions(+), 26 deletions(-)

--- a/include/linux/fs.h~mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare
+++ a/include/linux/fs.h
@@ -2279,6 +2279,8 @@ static inline bool can_mmap_file(struct
 	return true;
 }
 
+int __compat_vma_mmap_prepare(const struct file_operations *f_op,
+		struct file *file, struct vm_area_struct *vma);
 int compat_vma_mmap_prepare(struct file *file, struct vm_area_struct *vma);
 
 static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
--- a/mm/util.c~mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare
+++ a/mm/util.c
@@ -1134,16 +1134,50 @@ EXPORT_SYMBOL(flush_dcache_folio);
 #endif
 
 /**
+ * __compat_vma_mmap_prepare() - See description for compat_vma_mmap_prepare()
+ * for details. This is the same operation, only with a specific file operations
+ * struct which may or may not be the same as vma->vm_file->f_op.
+ * @f_op: The file operations whose .mmap_prepare() hook is specified.
+ * @file: The file which backs or will back the mapping.
+ * @vma: The VMA to apply the .mmap_prepare() hook to.
+ * Returns: 0 on success or error.
+ */
+int __compat_vma_mmap_prepare(const struct file_operations *f_op,
+		struct file *file, struct vm_area_struct *vma)
+{
+	struct vm_area_desc desc = {
+		.mm = vma->vm_mm,
+		.file = file,
+		.start = vma->vm_start,
+		.end = vma->vm_end,
+
+		.pgoff = vma->vm_pgoff,
+		.vm_file = vma->vm_file,
+		.vm_flags = vma->vm_flags,
+		.page_prot = vma->vm_page_prot,
+	};
+	int err;
+
+	err = f_op->mmap_prepare(&desc);
+	if (err)
+		return err;
+	set_vma_from_desc(vma, &desc);
+
+	return 0;
+}
+EXPORT_SYMBOL(__compat_vma_mmap_prepare);
+
+/**
  * compat_vma_mmap_prepare() - Apply the file's .mmap_prepare() hook to an
- * existing VMA
- * @file: The file which possesss an f_op->mmap_prepare() hook
+ * existing VMA.
+ * @file: The file which possesss an f_op->mmap_prepare() hook.
  * @vma: The VMA to apply the .mmap_prepare() hook to.
  *
  * Ordinarily, .mmap_prepare() is invoked directly upon mmap(). However, certain
- * 'wrapper' file systems invoke a nested mmap hook of an underlying file.
+ * stacked filesystems invoke a nested mmap hook of an underlying file.
  *
  * Until all filesystems are converted to use .mmap_prepare(), we must be
- * conservative and continue to invoke these 'wrapper' filesystems using the
+ * conservative and continue to invoke these stacked filesystems using the
  * deprecated .mmap() hook.
  *
  * However we have a problem if the underlying file system possesses an
@@ -1161,25 +1195,7 @@ EXPORT_SYMBOL(flush_dcache_folio);
  */
 int compat_vma_mmap_prepare(struct file *file, struct vm_area_struct *vma)
 {
-	struct vm_area_desc desc = {
-		.mm = vma->vm_mm,
-		.file = vma->vm_file,
-		.start = vma->vm_start,
-		.end = vma->vm_end,
-
-		.pgoff = vma->vm_pgoff,
-		.vm_file = vma->vm_file,
-		.vm_flags = vma->vm_flags,
-		.page_prot = vma->vm_page_prot,
-	};
-	int err;
-
-	err = file->f_op->mmap_prepare(&desc);
-	if (err)
-		return err;
-	set_vma_from_desc(vma, &desc);
-
-	return 0;
+	return __compat_vma_mmap_prepare(file->f_op, file, vma);
 }
 EXPORT_SYMBOL(compat_vma_mmap_prepare);
 
--- a/tools/testing/vma/vma_internal.h~mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare
+++ a/tools/testing/vma/vma_internal.h
@@ -1414,8 +1414,8 @@ static inline void free_anon_vma_name(st
 static inline void set_vma_from_desc(struct vm_area_struct *vma,
 		struct vm_area_desc *desc);
 
-static inline int compat_vma_mmap_prepare(struct file *file,
-		struct vm_area_struct *vma)
+static inline int __compat_vma_mmap_prepare(const struct file_operations *f_op,
+		struct file *file, struct vm_area_struct *vma)
 {
 	struct vm_area_desc desc = {
 		.mm = vma->vm_mm,
@@ -1430,7 +1430,7 @@ static inline int compat_vma_mmap_prepar
 	};
 	int err;
 
-	err = file->f_op->mmap_prepare(&desc);
+	err = f_op->mmap_prepare(&desc);
 	if (err)
 		return err;
 	set_vma_from_desc(vma, &desc);
@@ -1438,6 +1438,12 @@ static inline int compat_vma_mmap_prepar
 	return 0;
 }
 
+static inline int compat_vma_mmap_prepare(struct file *file,
+		struct vm_area_struct *vma)
+{
+	return __compat_vma_mmap_prepare(file->f_op, file, vma);
+}
+
 /* Did the driver provide valid mmap hook configuration? */
 static inline bool can_mmap_file(struct file *file)
 {
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch
tools-testing-vma-clean-up-stubs-in-vma_internalh.patch
mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch

