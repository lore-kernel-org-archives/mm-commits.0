Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007422D839C
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917810; cv=none; b=sy6f4wdq61RZbCrhiCcZVxRrBNIFJJlk28H12rQN5fzBeOS6oD4jHmVzsmz6RMfWlpWFWLvBOM/US6jD0cTlJpaGCd44pMg1JOPVyXvpGKiINt+dYluBv9lgsWS6IqAMGTWxeH2b2ly6FLmq+7Kj6jJG53JhPUZpsNIuUU4inKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917810; c=relaxed/simple;
	bh=kh1B5ad6oUS8L0MMuaOX6t8d9v1G4FutTW6Awc//fJQ=;
	h=Date:To:From:Subject:Message-Id; b=Tb/IqvJoxmN0oZuowJ9wCTvFxWAf8ZmQ66rpEQs6UoJvDgYbdr3sxOJdhDyf759kk+dS23u/CXmfgt8PNcMBlyfOsf5MWjV5FQ/I8ar6Ykvn7Ld1JGdikE3UHlD1YSV20Y0O1+IJhilwdPVCKYNPhzuoUDw0D2EtegvN57SRLcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NkNe9fbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NkNe9fbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B5EC4CEF7;
	Tue, 31 Mar 2026 00:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917809;
	bh=kh1B5ad6oUS8L0MMuaOX6t8d9v1G4FutTW6Awc//fJQ=;
	h=Date:To:From:Subject:From;
	b=NkNe9fbMuacfUciFefHc6Yf7V3T+vWqICp6uv98piOI8GdT1I7ltTCrUaVOGNPfUr
	 +J+2+2F6PyDOxqaRN4zTBwcgF6Msp2GeupWgUd+21kOxqo1i86IdhNGy3v4TA3f+lK
	 3bn1HsJpkYgm5VmWDZIR8QGV21EENeq8lCbX3dZo=
Date: Mon, 30 Mar 2026 17:43:29 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,viro@zeniv.linux.org.uk,vigneshr@ti.com,vbabka@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,miquel.raynal@bootlin.com,mhocko@suse.com,mcoquelin.stm32@gmail.com,martin.petersen@oracle.com,marc.dionne@auristor.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jannh@google.com,jack@suse.cz,haiyangz@microsoft.com,gregkh@linuxfoundation.org,dhowells@redhat.com,decui@microsoft.com,david@kernel.org,corbet@lwn.net,clemens@ladisch.de,brauner@kernel.org,bostroesser@gmail.com,arnd@arndb.de,alexandre.torgue@foss.st.com,alexander.shishkin@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers.patch removed from -mm tree
Message-Id: <20260331004329.C5B5EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow handling of stacked mmap_prepare hooks in more drivers
has been removed from the -mm tree.  Its filename was
     mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: allow handling of stacked mmap_prepare hooks in more drivers
Date: Fri, 20 Mar 2026 22:39:43 +0000

While the conversion of mmap hooks to mmap_prepare is underway, we will
encounter situations where mmap hooks need to invoke nested mmap_prepare
hooks.

The nesting of mmap hooks is termed 'stacking'.  In order to flexibly
facilitate the conversion of custom mmap hooks in drivers which stack, we
must split up the existing __compat_vma_mmap() function into two separate
functions:

* compat_set_desc_from_vma() - This allows the setting of a vm_area_desc
  object's fields to the relevant fields of a VMA.

* __compat_vma_mmap() - Once an mmap_prepare hook has been executed upon a
  vm_area_desc object, this function performs any mmap actions specified by
  the mmap_prepare hook and then invokes its vm_ops->mapped() hook if any
  were specified.

In ordinary cases, where a file's f_op->mmap_prepare() hook simply needs
to be invoked in a stacked mmap() hook, compat_vma_mmap() can be used.

However some drivers define their own nested hooks, which are invoked in
turn by another hook.

A concrete example is vmbus_channel->mmap_ring_buffer(), which is invoked
in turn by bin_attribute->mmap():

vmbus_channel->mmap_ring_buffer() has a signature of:

int (*mmap_ring_buffer)(struct vmbus_channel *channel,
			struct vm_area_struct *vma);

And bin_attribute->mmap() has a signature of:

	int (*mmap)(struct file *, struct kobject *,
		    const struct bin_attribute *attr,
		    struct vm_area_struct *vma);

And so compat_vma_mmap() cannot be used here for incremental conversion of
hooks from mmap() to mmap_prepare().

There are many such instances like this, where conversion to mmap_prepare
would otherwise cascade to a huge change set due to nesting of this kind.

The changes in this patch mean we could now instead convert
vmbus_channel->mmap_ring_buffer() to
vmbus_channel->mmap_prepare_ring_buffer(), and implement something like:

	struct vm_area_desc desc;
	int err;

	compat_set_desc_from_vma(&desc, file, vma);
	err = channel->mmap_prepare_ring_buffer(channel, &desc);
	if (err)
		return err;

	return __compat_vma_mmap(&desc, vma);

Allowing us to incrementally update this logic, and other logic like it.

Unfortunately, as part of this change, we need to be able to flexibly
assign to the VMA descriptor, so have to remove some of the const
declarations within the structure.

Also update the VMA tests to reflect the changes.

Link: https://lkml.kernel.org/r/24aac3019dd34740e788d169fccbe3c62781e648.1774045440.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bodo Stroesser <bostroesser@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h              |    3 
 include/linux/mm_types.h        |    4 -
 mm/util.c                       |  117 +++++++++++++++++++++---------
 mm/vma.h                        |    2 
 tools/testing/vma/include/dup.h |   68 +++++++++++------
 5 files changed, 135 insertions(+), 59 deletions(-)

--- a/include/linux/fs.h~mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers
+++ a/include/linux/fs.h
@@ -2058,6 +2058,9 @@ static inline bool can_mmap_file(struct
 	return true;
 }
 
+void compat_set_desc_from_vma(struct vm_area_desc *desc, const struct file *file,
+			      const struct vm_area_struct *vma);
+int __compat_vma_mmap(struct vm_area_desc *desc, struct vm_area_struct *vma);
 int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
 int __vma_check_mmap_hook(struct vm_area_struct *vma);
 
--- a/include/linux/mm_types.h~mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers
+++ a/include/linux/mm_types.h
@@ -891,8 +891,8 @@ static __always_inline bool vma_flags_em
  */
 struct vm_area_desc {
 	/* Immutable state. */
-	const struct mm_struct *const mm;
-	struct file *const file; /* May vary from vm_file in stacked callers. */
+	struct mm_struct *mm;
+	struct file *file; /* May vary from vm_file in stacked callers. */
 	unsigned long start;
 	unsigned long end;
 
--- a/mm/util.c~mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers
+++ a/mm/util.c
@@ -1163,38 +1163,78 @@ void flush_dcache_folio(struct folio *fo
 EXPORT_SYMBOL(flush_dcache_folio);
 #endif
 
-static int __compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
+/**
+ * compat_set_desc_from_vma() - assigns VMA descriptor @desc fields from a VMA.
+ * @desc: A VMA descriptor whose fields need to be set.
+ * @file: The file object describing the file being mmap()'d.
+ * @vma: The VMA whose fields we wish to assign to @desc.
+ *
+ * This is a compatibility function to allow an mmap() hook to call
+ * mmap_prepare() hooks when drivers nest these. This function specifically
+ * allows the construction of a vm_area_desc value, @desc, from a VMA @vma for
+ * the purposes of doing this.
+ *
+ * Once the conversion of drivers is complete this function will no longer be
+ * required and will be removed.
+ */
+void compat_set_desc_from_vma(struct vm_area_desc *desc,
+			      const struct file *file,
+			      const struct vm_area_struct *vma)
 {
-	struct vm_area_desc desc = {
-		.mm = vma->vm_mm,
-		.file = file,
-		.start = vma->vm_start,
-		.end = vma->vm_end,
-
-		.pgoff = vma->vm_pgoff,
-		.vm_file = vma->vm_file,
-		.vma_flags = vma->flags,
-		.page_prot = vma->vm_page_prot,
-
-		.action.type = MMAP_NOTHING, /* Default */
-	};
-	struct mmap_action *action = &desc.action;
-	int err;
+	memset(desc, 0, sizeof(*desc));
 
-	err = vfs_mmap_prepare(file, &desc);
-	if (err)
-		return err;
+	desc->mm = vma->vm_mm;
+	desc->file = (struct file *)file;
+	desc->start = vma->vm_start;
+	desc->end = vma->vm_end;
+
+	desc->pgoff = vma->vm_pgoff;
+	desc->vm_file = vma->vm_file;
+	desc->vma_flags = vma->flags;
+	desc->page_prot = vma->vm_page_prot;
 
-	err = mmap_action_prepare(&desc);
-	if (err)
-		return err;
+	/* Default. */
+	desc->action.type = MMAP_NOTHING;
+}
+EXPORT_SYMBOL(compat_set_desc_from_vma);
 
-	/* being invoked from .mmap means we don't have to enforce this. */
-	action->hide_from_rmap_until_complete = false;
+/**
+ * __compat_vma_mmap() - Similar to compat_vma_mmap(), only it allows
+ * flexibility as to how the mmap_prepare callback is invoked, which is useful
+ * for drivers which invoke nested mmap_prepare callbacks in an mmap() hook.
+ * @desc: A VMA descriptor upon which an mmap_prepare() hook has already been
+ * executed.
+ * @vma: The VMA to which @desc should be applied.
+ *
+ * The function assumes that you have obtained a VMA descriptor @desc from
+ * compat_set_desc_from_vma(), and already executed the mmap_prepare() hook upon
+ * it.
+ *
+ * It then performs any specified mmap actions, and invokes the vm_ops->mapped()
+ * hook if one is present.
+ *
+ * See the description of compat_vma_mmap() for more details.
+ *
+ * Once the conversion of drivers is complete this function will no longer be
+ * required and will be removed.
+ *
+ * Returns: 0 on success or error.
+ */
+int __compat_vma_mmap(struct vm_area_desc *desc,
+		      struct vm_area_struct *vma)
+{
+	int err;
 
-	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, action);
+	/* Perform any preparatory tasks for mmap action. */
+	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
+	/* Update the VMA from the descriptor. */
+	compat_set_vma_from_desc(vma, desc);
+	/* Complete any specified mmap actions. */
+	return mmap_action_complete(vma, &desc->action);
 }
+EXPORT_SYMBOL(__compat_vma_mmap);
 
 /**
  * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
@@ -1203,10 +1243,10 @@ static int __compat_vma_mmap(struct file
  * @vma: The VMA to apply the .mmap_prepare() hook to.
  *
  * Ordinarily, .mmap_prepare() is invoked directly upon mmap(). However, certain
- * stacked filesystems invoke a nested mmap hook of an underlying file.
+ * stacked drivers invoke a nested mmap hook of an underlying file.
  *
- * Until all filesystems are converted to use .mmap_prepare(), we must be
- * conservative and continue to invoke these stacked filesystems using the
+ * Until all drivers are converted to use .mmap_prepare(), we must be
+ * conservative and continue to invoke these stacked drivers using the
  * deprecated .mmap() hook.
  *
  * However we have a problem if the underlying file system possesses an
@@ -1217,14 +1257,27 @@ static int __compat_vma_mmap(struct file
  * establishes a struct vm_area_desc descriptor, passes to the underlying
  * .mmap_prepare() hook and applies any changes performed by it.
  *
- * Once the conversion of filesystems is complete this function will no longer
- * be required and will be removed.
+ * Once the conversion of drivers is complete this function will no longer be
+ * required and will be removed.
  *
  * Returns: 0 on success or error.
  */
 int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return __compat_vma_mmap(file, vma);
+	struct vm_area_desc desc;
+	struct mmap_action *action;
+	int err;
+
+	compat_set_desc_from_vma(&desc, file, vma);
+	err = vfs_mmap_prepare(file, &desc);
+	if (err)
+		return err;
+	action = &desc.action;
+
+	/* being invoked from .mmmap means we don't have to enforce this. */
+	action->hide_from_rmap_until_complete = false;
+
+	return __compat_vma_mmap(&desc, vma);
 }
 EXPORT_SYMBOL(compat_vma_mmap);
 
--- a/mm/vma.h~mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers
+++ a/mm/vma.h
@@ -300,7 +300,7 @@ static inline int vma_iter_store_gfp(str
  * f_op->mmap() but which might have an underlying file system which implements
  * f_op->mmap_prepare().
  */
-static inline void set_vma_from_desc(struct vm_area_struct *vma,
+static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
 		struct vm_area_desc *desc)
 {
 	/*
--- a/tools/testing/vma/include/dup.h~mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers
+++ a/tools/testing/vma/include/dup.h
@@ -519,8 +519,8 @@ enum vma_operation {
  */
 struct vm_area_desc {
 	/* Immutable state. */
-	const struct mm_struct *const mm;
-	struct file *const file; /* May vary from vm_file in stacked callers. */
+	struct mm_struct *mm;
+	struct file *file; /* May vary from vm_file in stacked callers. */
 	unsigned long start;
 	unsigned long end;
 
@@ -1278,50 +1278,70 @@ static inline void vma_set_anonymous(str
 }
 
 /* Declared in vma.h. */
-static inline void set_vma_from_desc(struct vm_area_struct *vma,
+static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
 		struct vm_area_desc *desc);
 
-static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
+static inline void compat_set_desc_from_vma(struct vm_area_desc *desc,
+			      const struct file *file,
+			      const struct vm_area_struct *vma)
 {
-	return file->f_op->mmap_prepare(desc);
+	memset(desc, 0, sizeof(*desc));
+
+	desc->mm = vma->vm_mm;
+	desc->file = (struct file *)file;
+	desc->start = vma->vm_start;
+	desc->end = vma->vm_end;
+
+	desc->pgoff = vma->vm_pgoff;
+	desc->vm_file = vma->vm_file;
+	desc->vma_flags = vma->flags;
+	desc->page_prot = vma->vm_page_prot;
+
+	/* Default. */
+	desc->action.type = MMAP_NOTHING;
 }
 
-static inline unsigned long vma_pages(struct vm_area_struct *vma)
+static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 {
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
-static inline int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
+static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
-	struct vm_area_desc desc = {
-		.mm = vma->vm_mm,
-		.file = file,
-		.start = vma->vm_start,
-		.end = vma->vm_end,
-
-		.pgoff = vma->vm_pgoff,
-		.vm_file = vma->vm_file,
-		.vma_flags = vma->flags,
-		.page_prot = vma->vm_page_prot,
+	return file->f_op->mmap_prepare(desc);
+}
 
-		.action.type = MMAP_NOTHING, /* Default */
-	};
-	struct mmap_action *action = &desc.action;
+static inline int __compat_vma_mmap(struct vm_area_desc *desc,
+		struct vm_area_struct *vma)
+{
 	int err;
 
-	err = vfs_mmap_prepare(file, &desc);
+	/* Perform any preparatory tasks for mmap action. */
+	err = mmap_action_prepare(desc);
 	if (err)
 		return err;
+	/* Update the VMA from the descriptor. */
+	compat_set_vma_from_desc(vma, desc);
+	/* Complete any specified mmap actions. */
+	return mmap_action_complete(vma, &desc->action);
+}
 
-	err = mmap_action_prepare(&desc);
+static inline int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct vm_area_desc desc;
+	struct mmap_action *action;
+	int err;
+
+	compat_set_desc_from_vma(&desc, file, vma);
+	err = vfs_mmap_prepare(file, &desc);
 	if (err)
 		return err;
+	action = &desc.action;
 
 	/* being invoked from .mmmap means we don't have to enforce this. */
 	action->hide_from_rmap_until_complete = false;
 
-	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, action);
+	return __compat_vma_mmap(&desc, vma);
 }
 
 static inline void vma_iter_init(struct vma_iterator *vmi,
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

