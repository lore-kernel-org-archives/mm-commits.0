Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD2B1DED5B
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597465; cv=none; b=ed7OUxpvf/EysRneif1nQphZfgh5v37Aj238rxeB1Jam2pBfdtSPk/9A+p/WvikPTfFn8Ybihbao83PT5veFPhLQKrxGssAgQJXNBK7oHy1DkGL73tnUmaoHUNlBup5iyJkzVFakH86eg6KUdD0vfy9Fg3k+LL5cmB4pi2i/2XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597465; c=relaxed/simple;
	bh=b4763uGxzi7VMyYrpnq74VBKefRu6VSzjqQL9RpAGvA=;
	h=Date:To:From:Subject:Message-Id; b=ZDvo4FK/QLLFZDRkkkK6jZOvaKOQVeLCTx6IU1FfUgriOl/Jegbs9Cfu3g3Mt2T52S2QbABZ9L889tbTQoK9USl31x71hQoUb6MMnvoMg8rI3beZRExjJtWsL0O0vs7HJAC7jRQza1yU6s3uVtagAF4bu/rvuPOp2mhDh86wmkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FC+/c1QF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FC+/c1QF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBD3C4CEF0;
	Tue, 23 Sep 2025 03:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597464;
	bh=b4763uGxzi7VMyYrpnq74VBKefRu6VSzjqQL9RpAGvA=;
	h=Date:To:From:Subject:From;
	b=FC+/c1QF+jhHKkVCsskbaUJ1tVdsXwa1tWLNX5cQaumkPMpnHNL/lLrpjy4YTumAb
	 RgYc8s4kwZ/OLohECc4/AaAyeWN7qusepuEhHLraiCw94o/xSmHjlkuqzRdAzJSSa3
	 XfCPm7cbNSkIsmfJwt24hGtPnX+BfQhs2eyzmtoE=
Date: Mon, 22 Sep 2025 20:17:44 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch removed from -mm tree
Message-Id: <20250923031744.BBBD3C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: specify separate file and vm_file params in vm_area_desc
has been removed from the -mm tree.  Its filename was
     mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: specify separate file and vm_file params in vm_area_desc
Date: Wed, 3 Sep 2025 18:48:41 +0100

Patch series "mm: do not assume file == vma->vm_file in
compat_vma_mmap_prepare()", v2.

As part of the efforts to eliminate the problematic f_op->mmap callback, a
new callback - f_op->mmap_prepare was provided.

While we are converting these callbacks, we must deal with 'stacked'
filesystems and drivers - those which in their own f_op->mmap callback
invoke an inner f_op->mmap callback.

To accomodate for this, a compatibility layer is provided that, via
vfs_mmap(), detects if f_op->mmap_prepare is provided and if so, generates
a vm_area_desc containing the VMA's metadata and invokes the call.

So far, we have provided desc->file equal to vma->vm_file.  However this
is not necessarily valid, especially in the case of stacked drivers which
wish to assign a new file after the inner hook is invoked.

To account for this, we adjust vm_area_desc to have both file and vm_file
fields.  The .vm_file field is strictly set to vma->vm_file (or in the
case of a new mapping, what will become vma->vm_file).

However, .file is set to whichever file vfs_mmap() is invoked with when
using the compatibilty layer.

Therefore, if the VMA's file needs to be updated in .mmap_prepare,
desc->vm_file should be assigned, whilst desc->file should be read.

No current f_op->mmap_prepare users assign desc->file so this is safe to
do.

This makes the .mmap_prepare callback in the context of a stacked
filesystem or driver completely consistent with the existing .mmap
implementations.

While we're here, we do a few small cleanups, and ensure that we const-ify
things correctly in the vm_area_desc struct to avoid hooks accidentally
trying to assign fields they should not.


This patch (of 2):

Stacked filesystems and drivers may invoke mmap hooks with a struct file
pointer that differs from the overlying file.  We will make this
functionality possible in a subsequent patch.

In order to prepare for this, let's update vm_area_struct to separately
provide desc->file and desc->vm_file parameters.

The desc->file parameter is the file that the hook is expected to operate
upon, and is not assignable (though the hok may wish to e.g.  update the
file's accessed time for instance).

The desc->vm_file defaults to what will become vma->vm_file and is what
the hook must reassign should it wish to change the VMA"s vma->vm_file.

For now we keep desc->file, vm_file the same to remain consistent.

No f_op->mmap_prepare() callback sets a new vma->vm_file currently, so
this is safe to change.

While we're here, make the mm_struct desc->mm pointers at immutable as
well as the desc->mm field itself.

As part of this change, also update the single hook which this would
otherwise break - mlock_future_ok(), invoked by secretmem_mmap_prepare()).

We additionally update set_vma_from_desc() to compare fields in a more
logical fashion, checking the (possibly) user-modified fields as the first
operand against the existing value as the second one.

Additionally, update VMA tests to accommodate changes.

Link: https://lkml.kernel.org/r/cover.1756920635.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/3fa15a861bb7419f033d22970598aa61850ea267.1756920635.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h         |    5 +++--
 mm/internal.h                    |    4 ++--
 mm/mmap.c                        |    2 +-
 mm/util.c                        |   14 ++++++++++++--
 mm/vma.c                         |    5 +++--
 mm/vma.h                         |   28 ++++------------------------
 tools/testing/vma/vma_internal.h |   28 ++++++++++++++++++----------
 7 files changed, 43 insertions(+), 43 deletions(-)

--- a/include/linux/mm_types.h~mm-specify-separate-file-and-vm_file-params-in-vm_area_desc
+++ a/include/linux/mm_types.h
@@ -777,13 +777,14 @@ struct pfnmap_track_ctx {
  */
 struct vm_area_desc {
 	/* Immutable state. */
-	struct mm_struct *mm;
+	const struct mm_struct *const mm;
+	struct file *const file; /* May vary from vm_file in stacked callers. */
 	unsigned long start;
 	unsigned long end;
 
 	/* Mutable fields. Populated with initial state. */
 	pgoff_t pgoff;
-	struct file *file;
+	struct file *vm_file;
 	vm_flags_t vm_flags;
 	pgprot_t page_prot;
 
--- a/mm/internal.h~mm-specify-separate-file-and-vm_file-params-in-vm_area_desc
+++ a/mm/internal.h
@@ -962,8 +962,8 @@ extern long populate_vma_page_range(stru
 		unsigned long start, unsigned long end, int *locked);
 extern long faultin_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, bool write, int *locked);
-extern bool mlock_future_ok(struct mm_struct *mm, vm_flags_t vm_flags,
-			       unsigned long bytes);
+bool mlock_future_ok(const struct mm_struct *mm, vm_flags_t vm_flags,
+		unsigned long bytes);
 
 /*
  * NOTE: This function can't tell whether the folio is "fully mapped" in the
--- a/mm/mmap.c~mm-specify-separate-file-and-vm_file-params-in-vm_area_desc
+++ a/mm/mmap.c
@@ -225,7 +225,7 @@ static inline unsigned long round_hint_t
 	return hint;
 }
 
-bool mlock_future_ok(struct mm_struct *mm, vm_flags_t vm_flags,
+bool mlock_future_ok(const struct mm_struct *mm, vm_flags_t vm_flags,
 			unsigned long bytes)
 {
 	unsigned long locked_pages, limit_pages;
--- a/mm/util.c~mm-specify-separate-file-and-vm_file-params-in-vm_area_desc
+++ a/mm/util.c
@@ -1161,10 +1161,20 @@ EXPORT_SYMBOL(flush_dcache_folio);
  */
 int compat_vma_mmap_prepare(struct file *file, struct vm_area_struct *vma)
 {
-	struct vm_area_desc desc;
+	struct vm_area_desc desc = {
+		.mm = vma->vm_mm,
+		.file = vma->vm_file,
+		.start = vma->vm_start,
+		.end = vma->vm_end,
+
+		.pgoff = vma->vm_pgoff,
+		.vm_file = vma->vm_file,
+		.vm_flags = vma->vm_flags,
+		.page_prot = vma->vm_page_prot,
+	};
 	int err;
 
-	err = file->f_op->mmap_prepare(vma_to_desc(vma, &desc));
+	err = file->f_op->mmap_prepare(&desc);
 	if (err)
 		return err;
 	set_vma_from_desc(vma, &desc);
--- a/mm/vma.c~mm-specify-separate-file-and-vm_file-params-in-vm_area_desc
+++ a/mm/vma.c
@@ -2572,11 +2572,12 @@ static int call_mmap_prepare(struct mmap
 	int err;
 	struct vm_area_desc desc = {
 		.mm = map->mm,
+		.file = map->file,
 		.start = map->addr,
 		.end = map->end,
 
 		.pgoff = map->pgoff,
-		.file = map->file,
+		.vm_file = map->file,
 		.vm_flags = map->vm_flags,
 		.page_prot = map->page_prot,
 	};
@@ -2588,7 +2589,7 @@ static int call_mmap_prepare(struct mmap
 
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc.pgoff;
-	map->file = desc.file;
+	map->file = desc.vm_file;
 	map->vm_flags = desc.vm_flags;
 	map->page_prot = desc.page_prot;
 	/* User-defined fields. */
--- a/mm/vma.h~mm-specify-separate-file-and-vm_file-params-in-vm_area_desc
+++ a/mm/vma.h
@@ -222,31 +222,11 @@ static inline int vma_iter_store_gfp(str
 	return 0;
 }
 
-
 /*
- * Temporary helper functions for file systems which wrap an invocation of
+ * Temporary helper function for stacked mmap handlers which specify
  * f_op->mmap() but which might have an underlying file system which implements
  * f_op->mmap_prepare().
  */
-
-static inline struct vm_area_desc *vma_to_desc(struct vm_area_struct *vma,
-		struct vm_area_desc *desc)
-{
-	desc->mm = vma->vm_mm;
-	desc->start = vma->vm_start;
-	desc->end = vma->vm_end;
-
-	desc->pgoff = vma->vm_pgoff;
-	desc->file = vma->vm_file;
-	desc->vm_flags = vma->vm_flags;
-	desc->page_prot = vma->vm_page_prot;
-
-	desc->vm_ops = NULL;
-	desc->private_data = NULL;
-
-	return desc;
-}
-
 static inline void set_vma_from_desc(struct vm_area_struct *vma,
 		struct vm_area_desc *desc)
 {
@@ -258,9 +238,9 @@ static inline void set_vma_from_desc(str
 
 	/* Mutable fields. Populated with initial state. */
 	vma->vm_pgoff = desc->pgoff;
-	if (vma->vm_file != desc->file)
-		vma_set_file(vma, desc->file);
-	if (vma->vm_flags != desc->vm_flags)
+	if (desc->vm_file != vma->vm_file)
+		vma_set_file(vma, desc->vm_file);
+	if (desc->vm_flags != vma->vm_flags)
 		vm_flags_set(vma, desc->vm_flags);
 	vma->vm_page_prot = desc->page_prot;
 
--- a/tools/testing/vma/vma_internal.h~mm-specify-separate-file-and-vm_file-params-in-vm_area_desc
+++ a/tools/testing/vma/vma_internal.h
@@ -283,13 +283,14 @@ struct vm_area_struct;
  */
 struct vm_area_desc {
 	/* Immutable state. */
-	struct mm_struct *mm;
+	const struct mm_struct *const mm;
+	struct file *const file; /* May vary from vm_file in stacked callers. */
 	unsigned long start;
 	unsigned long end;
 
 	/* Mutable fields. Populated with initial state. */
 	pgoff_t pgoff;
-	struct file *file;
+	struct file *vm_file;
 	vm_flags_t vm_flags;
 	pgprot_t page_prot;
 
@@ -1299,8 +1300,8 @@ static inline bool capable(int cap)
 	return true;
 }
 
-static inline bool mlock_future_ok(struct mm_struct *mm, vm_flags_t vm_flags,
-			unsigned long bytes)
+static inline bool mlock_future_ok(const struct mm_struct *mm,
+		vm_flags_t vm_flags, unsigned long bytes)
 {
 	unsigned long locked_pages, limit_pages;
 
@@ -1465,16 +1466,23 @@ static inline void free_anon_vma_name(st
 static inline void set_vma_from_desc(struct vm_area_struct *vma,
 		struct vm_area_desc *desc);
 
-static inline struct vm_area_desc *vma_to_desc(struct vm_area_struct *vma,
-		struct vm_area_desc *desc);
-
-static int compat_vma_mmap_prepare(struct file *file,
+static inline int compat_vma_mmap_prepare(struct file *file,
 		struct vm_area_struct *vma)
 {
-	struct vm_area_desc desc;
+	struct vm_area_desc desc = {
+		.mm = vma->vm_mm,
+		.file = vma->vm_file,
+		.start = vma->vm_start,
+		.end = vma->vm_end,
+
+		.pgoff = vma->vm_pgoff,
+		.vm_file = vma->vm_file,
+		.vm_flags = vma->vm_flags,
+		.page_prot = vma->vm_page_prot,
+	};
 	int err;
 
-	err = file->f_op->mmap_prepare(vma_to_desc(vma, &desc));
+	err = file->f_op->mmap_prepare(&desc);
 	if (err)
 		return err;
 	set_vma_from_desc(vma, &desc);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


