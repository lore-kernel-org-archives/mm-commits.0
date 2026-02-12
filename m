Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026CA2E1C63
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939852; cv=none; b=IhiqH1tAdz4EhrLai8ZicVasT3b0XdxFNYhb2qCXBpC5swSLt+00/yKSkbNf9o24zXsfMS0U020EghNZxRerwQJNBlJe9vO1wNFtHdLP4WEAjlHGkgoJTqDcqjXbAVcgEwx4iHLzH7q2orBHBT+7uXSWoSNu+3N6YY1Avcp+zpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939852; c=relaxed/simple;
	bh=4jxZ8YNhtV2FT9o0LE48ZvuA6Ul7vb3A4oyAedwxap8=;
	h=Date:To:From:Subject:Message-Id; b=n2YyEGGOte/Ib2AIsetkf5w9RZSs4vhPTXIrDQOHTRcvJk5QUnPQa/tAjd+Vv1V/ZUlY+BTvX3EWWt4/11Wg719KZV50wM+pBGGa456OgFe6WG0EaSEDV4Z+HeHQVUAXZY1QzAPLAIkcePf1iolB0pNqzUWRp1aVmA3WWeDnq4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N6U7PsZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N6U7PsZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC4FC4CEF7;
	Thu, 12 Feb 2026 23:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939851;
	bh=4jxZ8YNhtV2FT9o0LE48ZvuA6Ul7vb3A4oyAedwxap8=;
	h=Date:To:From:Subject:From;
	b=N6U7PsZ+Jy4jmOMQGsmRXw23n61jlznFE0E+8eEkfFNIbTjGcxqvC9YATHqb5sLR9
	 AURToxBWviz6OWoEyXDfpRqXawvuzciTtPjk2DlYGJqIJIQKpFVy6iyVdu8Nk0NYnA
	 devSh9FeUsHCSW9O7Xsloj/imdpm60TI2CXZBOSQ=
Date: Thu, 12 Feb 2026 15:44:11 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ynorov@nvidia.com,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,Liam.Howlett@oracle.com,jgg@nvidia.com,jarkko@kernel.org,dlemoal@kernel.org,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,clm@fb.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-vm_area_desc-utilise-vma_flags_t-only.patch removed from -mm tree
Message-Id: <20260212234411.CEC4FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make vm_area_desc utilise vma_flags_t only
has been removed from the -mm tree.  Its filename was
     mm-make-vm_area_desc-utilise-vma_flags_t-only.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: make vm_area_desc utilise vma_flags_t only
Date: Thu, 22 Jan 2026 16:06:19 +0000

Now we have eliminated all uses of vm_area_desc->vm_flags, eliminate this
field, and have mmap_prepare users utilise the vma_flags_t
vm_area_desc->vma_flags field only.

As part of this change we alter is_shared_maywrite() to accept a
vma_flags_t parameter, and introduce is_shared_maywrite_vm_flags() for use
with legacy vm_flags_t flags.

We also update struct mmap_state to add a union between vma_flags and
vm_flags temporarily until the mmap logic is also converted to using
vma_flags_t.

Also update the VMA userland tests to reflect this change.

Link: https://lkml.kernel.org/r/fd2a2938b246b4505321954062b1caba7acfc77a.1769097829.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    9 +++++++--
 include/linux/mm_types.h         |    5 +----
 mm/filemap.c                     |    2 +-
 mm/util.c                        |    2 +-
 mm/vma.c                         |   11 +++++++----
 mm/vma.h                         |    3 +--
 tools/testing/vma/vma_internal.h |    9 +++++++--
 7 files changed, 25 insertions(+), 16 deletions(-)

--- a/include/linux/mm.h~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/include/linux/mm.h
@@ -1290,15 +1290,20 @@ static inline bool vma_is_accessible(con
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
-static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+static inline bool is_shared_maywrite_vm_flags(vm_flags_t vm_flags)
 {
 	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
 		(VM_SHARED | VM_MAYWRITE);
 }
 
+static inline bool is_shared_maywrite(const vma_flags_t *flags)
+{
+	return vma_flags_test_all(flags, VMA_SHARED_BIT, VMA_MAYWRITE_BIT);
+}
+
 static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 {
-	return is_shared_maywrite(vma->vm_flags);
+	return is_shared_maywrite(&vma->flags);
 }
 
 static inline
--- a/include/linux/mm_types.h~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/include/linux/mm_types.h
@@ -887,10 +887,7 @@ struct vm_area_desc {
 	/* Mutable fields. Populated with initial state. */
 	pgoff_t pgoff;
 	struct file *vm_file;
-	union {
-		vm_flags_t vm_flags;
-		vma_flags_t vma_flags;
-	};
+	vma_flags_t vma_flags;
 	pgprot_t page_prot;
 
 	/* Write-only fields. */
--- a/mm/filemap.c~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/mm/filemap.c
@@ -4012,7 +4012,7 @@ int generic_file_readonly_mmap(struct fi
 
 int generic_file_readonly_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (is_shared_maywrite(desc->vm_flags))
+	if (is_shared_maywrite(&desc->vma_flags))
 		return -EINVAL;
 	return generic_file_mmap_prepare(desc);
 }
--- a/mm/util.c~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/mm/util.c
@@ -1154,7 +1154,7 @@ int __compat_vma_mmap(const struct file_
 
 		.pgoff = vma->vm_pgoff,
 		.vm_file = vma->vm_file,
-		.vm_flags = vma->vm_flags,
+		.vma_flags = vma->flags,
 		.page_prot = vma->vm_page_prot,
 
 		.action.type = MMAP_NOTHING, /* Default */
--- a/mm/vma.c~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/mm/vma.c
@@ -15,7 +15,10 @@ struct mmap_state {
 	unsigned long end;
 	pgoff_t pgoff;
 	unsigned long pglen;
-	vm_flags_t vm_flags;
+	union {
+		vm_flags_t vm_flags;
+		vma_flags_t vma_flags;
+	};
 	struct file *file;
 	pgprot_t page_prot;
 
@@ -2369,7 +2372,7 @@ static void set_desc_from_map(struct vm_
 
 	desc->pgoff = map->pgoff;
 	desc->vm_file = map->file;
-	desc->vm_flags = map->vm_flags;
+	desc->vma_flags = map->vma_flags;
 	desc->page_prot = map->page_prot;
 }
 
@@ -2650,7 +2653,7 @@ static int call_mmap_prepare(struct mmap
 		map->file_doesnt_need_get = true;
 		map->file = desc->vm_file;
 	}
-	map->vm_flags = desc->vm_flags;
+	map->vma_flags = desc->vma_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
 	map->vm_ops = desc->vm_ops;
@@ -2823,7 +2826,7 @@ unsigned long mmap_region(struct file *f
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && is_shared_maywrite(vm_flags)) {
+	if (file && is_shared_maywrite_vm_flags(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)
--- a/mm/vma.h~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/mm/vma.h
@@ -309,8 +309,7 @@ static inline void set_vma_from_desc(str
 	vma->vm_pgoff = desc->pgoff;
 	if (desc->vm_file != vma->vm_file)
 		vma_set_file(vma, desc->vm_file);
-	if (desc->vm_flags != vma->vm_flags)
-		vm_flags_set(vma, desc->vm_flags);
+	vma->flags = desc->vma_flags;
 	vma->vm_page_prot = desc->page_prot;
 
 	/* User-defined fields. */
--- a/tools/testing/vma/vma_internal.h~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/tools/testing/vma/vma_internal.h
@@ -1009,15 +1009,20 @@ static inline void vma_desc_clear_flags_
 #define vma_desc_clear_flags(desc, ...) \
 	vma_desc_clear_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
 
-static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+static inline bool is_shared_maywrite_vm_flags(vm_flags_t vm_flags)
 {
 	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
 		(VM_SHARED | VM_MAYWRITE);
 }
 
+static inline bool is_shared_maywrite(const vma_flags_t *flags)
+{
+	return vma_flags_test_all(flags, VMA_SHARED_BIT, VMA_MAYWRITE_BIT);
+}
+
 static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
 {
-	return is_shared_maywrite(vma->vm_flags);
+	return is_shared_maywrite(&vma->flags);
 }
 
 static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


