Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F050C223DD5
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115488; cv=none; b=RN6WSw0WAQD0INrff/hhPDRNSo8+AcC15auBOhFVobtPf6pPsNthACx4Ehv8x8oW8A9on8Lwt7qwHoRmY3Y9E7EDu8cvU2P/gWTgqpFj3vn51g3i6WTnXkmC4TjLhl6WvUcOeKh9h8hE7tsDtsBPXMj5sSn1xhwJEDzP4gpDjsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115488; c=relaxed/simple;
	bh=eWsX0YJfMzFSoMJXDBXRnyM6kyxIVJ3Qu7+6FvGzIVw=;
	h=Date:To:From:Subject:Message-Id; b=e5vE0SeuQaOpawBI2Q6ILcY1LH6YT8M0THppdliFs40YOfUi3GkTG3/oEfeesSAI7lC03XRVneT+BX/c7RCkE/jdlQlxmpjLrptSevy1NMxRz5e74KGY2+HufV52UwhSnqvszTnk2YvqEwtzAWjTz0VgBCpSZwXN+/ycGHZKC58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rQFbDJ12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rQFbDJ12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1E9C4CEEA;
	Mon, 16 Jun 2025 23:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115487;
	bh=eWsX0YJfMzFSoMJXDBXRnyM6kyxIVJ3Qu7+6FvGzIVw=;
	h=Date:To:From:Subject:From;
	b=rQFbDJ12Ir1uvSxiNAoppMDndiYIOvabm+oAv1u6nIz5AlAxoYZgiQYlX03AJQM61
	 cVnUfSHkMZbyjPl0/k+wKYxlYtdY0FQePwc2QeRJEuI9CZoLiAl2HzPNrZ+nordiLq
	 fryeT/IhJI6rhtGohI76hhnoqm7Mv1ID91p5w/T8=
Date: Mon, 16 Jun 2025 16:11:26 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare.patch added to mm-new branch
Message-Id: <20250616231127.7A1E9C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename call_mmap/mmap_prepare to vfs_mmap/mmap_prepare
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare.patch

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
Subject: mm: rename call_mmap/mmap_prepare to vfs_mmap/mmap_prepare
Date: Mon, 16 Jun 2025 20:33:20 +0100

Patch series "convert the majority of file systems to mmap_prepare".

In commit c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file
callback"), a new hook for mmap was introduced - f_op->mmap_prepare().

This is preferred to the existing f_op->mmap() hook as it does require a
VMA to be established yet, thus allowing the mmap logic to invoke this
hook far, far earlier, prior to inserting a VMA into the virtual address
space, or performing any other heavy handed operations.

This allows for much simpler unwinding on error, and for there to be a
single attempt at merging a VMA rather than having to possibly reattempt a
merge based on potentially altered VMA state.

Far more importantly, it prevents inappropriate manipulation of
incompletely initialised VMA state, which is something that has been the
cause of bugs and complexity in the past.

The intent is to gradually deprecate f_op->mmap, and in that vein this
series coverts the majority of file systems to using f_op->mmap_prepare.

Prerequisite steps are taken - firstly ensuring all checks for mmap
capabilities use the file_has_valid_mmap_hooks() helper rather than
directly checking for f_op->mmap (which is now not a valid check) and
secondly updating daxdev_mapping_supported() to not require a VMA
parameter to allow ext4 and xfs to be converted.

Commit bb666b7c2707 ("mm: add mmap_prepare() compatibility layer for
nested file systems") handles the nasty edge-case of nested file systems
like overlayfs, which introduces a compatibility shim to allow
f_op->mmap_prepare() to be invoked from an f_op->mmap() callback.

This allows for nested filesystems to continue to function correctly with
all file systems regardless of which callback is used.  Once we finally
convert all file systems, this shim can be removed.

As a result, ecryptfs, fuse, and overlayfs remain unaltered so they can
nest all other file systems.

We additionally do not update resctl - as this requires an update to
remap_pfn_range() (or an alternative to it) which we defer to a later
series, equally we do not update cramfs which needs a mixed mapping
insertion with the same issue, nor do we update procfs, hugetlbfs, syfs or
kernfs all of which require VMAs for internal state and hooks.  We shall
return to all of these later.


This patch (of 10):

call_mmap() violates the existing convention in include/linux/fs.h whereby
invocations of virtual file system hooks is performed by functions
prefixed with vfs_xxx().

Correct this by renaming call_mmap() to vfs_mmap().  This also avoids
confusion as to the fact that f_op->mmap_prepare may be invoked here.

Also rename __call_mmap_prepare() function to vfs_mmap_prepare() and
adjust to accept a file parameter, this is useful later for nested file
systems.

Finally, fix up the VMA userland tests and ensure the mmap_prepare -> mmap
shim is implemented there.

Link: https://lkml.kernel.org/r/cover.1750099179.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/8d389f4994fa736aa8f9172bef8533c10a9e9011.1750099179.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c |    2 -
 fs/backing-file.c                          |    2 -
 fs/coda/file.c                             |    4 +-
 include/linux/fs.h                         |    5 +-
 ipc/shm.c                                  |    2 -
 mm/internal.h                              |    2 -
 mm/vma.c                                   |    2 -
 tools/testing/vma/vma_internal.h           |   32 +++++++++++++++----
 8 files changed, 35 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c~mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare
+++ a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -105,7 +105,7 @@ static int i915_gem_dmabuf_mmap(struct d
 	if (!obj->base.filp)
 		return -ENODEV;
 
-	ret = call_mmap(obj->base.filp, vma);
+	ret = vfs_mmap(obj->base.filp, vma);
 	if (ret)
 		return ret;
 
--- a/fs/backing-file.c~mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare
+++ a/fs/backing-file.c
@@ -339,7 +339,7 @@ int backing_file_mmap(struct file *file,
 	vma_set_file(vma, file);
 
 	old_cred = override_creds(ctx->cred);
-	ret = call_mmap(vma->vm_file, vma);
+	ret = vfs_mmap(vma->vm_file, vma);
 	revert_creds(old_cred);
 
 	if (ctx->accessed)
--- a/fs/coda/file.c~mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare
+++ a/fs/coda/file.c
@@ -199,10 +199,10 @@ coda_file_mmap(struct file *coda_file, s
 	spin_unlock(&cii->c_lock);
 
 	vma->vm_file = get_file(host_file);
-	ret = call_mmap(vma->vm_file, vma);
+	ret = vfs_mmap(vma->vm_file, vma);
 
 	if (ret) {
-		/* if call_mmap fails, our caller will put host_file so we
+		/* if vfs_mmap fails, our caller will put host_file so we
 		 * should drop the reference to the coda_file that we got.
 		 */
 		fput(coda_file);
--- a/include/linux/fs.h~mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare
+++ a/include/linux/fs.h
@@ -2278,7 +2278,7 @@ static inline bool file_has_valid_mmap_h
 
 int compat_vma_mmap_prepare(struct file *file, struct vm_area_struct *vma);
 
-static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
+static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	if (file->f_op->mmap_prepare)
 		return compat_vma_mmap_prepare(file, vma);
@@ -2286,8 +2286,7 @@ static inline int call_mmap(struct file
 	return file->f_op->mmap(file, vma);
 }
 
-static inline int __call_mmap_prepare(struct file *file,
-		struct vm_area_desc *desc)
+static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);
 }
--- a/ipc/shm.c~mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare
+++ a/ipc/shm.c
@@ -602,7 +602,7 @@ static int shm_mmap(struct file *file, s
 	if (ret)
 		return ret;
 
-	ret = call_mmap(sfd->file, vma);
+	ret = vfs_mmap(sfd->file, vma);
 	if (ret) {
 		__shm_close(sfd);
 		return ret;
--- a/mm/internal.h~mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare
+++ a/mm/internal.h
@@ -165,7 +165,7 @@ static inline void *folio_raw_mapping(co
  */
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
-	int err = call_mmap(file, vma);
+	int err = vfs_mmap(file, vma);
 
 	if (likely(!err))
 		return 0;
--- a/mm/vma.c~mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare
+++ a/mm/vma.c
@@ -2582,7 +2582,7 @@ static int call_mmap_prepare(struct mmap
 	};
 
 	/* Invoke the hook. */
-	err = __call_mmap_prepare(map->file, &desc);
+	err = vfs_mmap_prepare(map->file, &desc);
 	if (err)
 		return err;
 
--- a/tools/testing/vma/vma_internal.h~mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare
+++ a/tools/testing/vma/vma_internal.h
@@ -1458,6 +1458,27 @@ static inline void free_anon_vma_name(st
 	(void)vma;
 }
 
+/* Declared in vma.h. */
+static inline void set_vma_from_desc(struct vm_area_struct *vma,
+		struct vm_area_desc *desc);
+
+static inline struct vm_area_desc *vma_to_desc(struct vm_area_struct *vma,
+		struct vm_area_desc *desc);
+
+static int compat_vma_mmap_prepare(struct file *file,
+		struct vm_area_struct *vma)
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
+
 /* Did the driver provide valid mmap hook configuration? */
 static inline bool file_has_valid_mmap_hooks(struct file *file)
 {
@@ -1467,22 +1488,21 @@ static inline bool file_has_valid_mmap_h
 	/* Hooks are mutually exclusive. */
 	if (WARN_ON_ONCE(has_mmap && has_mmap_prepare))
 		return false;
-	if (WARN_ON_ONCE(!has_mmap && !has_mmap_prepare))
+	if (!has_mmap && !has_mmap_prepare)
 		return false;
 
 	return true;
 }
 
-static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
+static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if (WARN_ON_ONCE(file->f_op->mmap_prepare))
-		return -EINVAL;
+	if (file->f_op->mmap_prepare)
+		return compat_vma_mmap_prepare(file, vma);
 
 	return file->f_op->mmap(file, vma);
 }
 
-static inline int __call_mmap_prepare(struct file *file,
-		struct vm_area_desc *desc)
+static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
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
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare.patch
mm-nommu-use-file_has_valid_mmap_hooks-helper.patch
fs-consistently-use-file_has_valid_mmap_hooks-helper.patch
fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma.patch
fs-ext4-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch
fs-xfs-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch
mm-filemap-introduce-generic_file__mmap_prepare-helpers.patch
fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare.patch
fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare.patch
fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings.patch

