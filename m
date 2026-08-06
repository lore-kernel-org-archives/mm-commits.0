Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1080F302146
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 23:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786058036; cv=none; b=VQvMTBWbJZ+XM700Xvxes4daYNnVzSU9/meYLs8ICQxDpr3f3V54hDMcWGfjeCJf1pr0hfZPSIwGnMMU5OLIgg/KnUR8WJsKrnovtduoapDL5h3ffY49XWCp2dOCxCNK1AMMiwgQPy1BD8Sm/oV5EnhGx8iGR+Rq2INz0T+tono=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786058036; c=relaxed/simple;
	bh=/LI2ukGQa9ALcKxvtxrQC6S82uQmDJ6asU8JX9Qq9Tg=;
	h=Date:To:From:Subject:Message-Id; b=KqD1+uJw1Baw3epO0EuoIvcUlfr0ILUBCxTCROqbl1xqwm5Rj40h79Mh9EEk26dJm8U++hBdBTqH5t7Ci9mz6yt/BGGfZL0q/ilMmTjpo0XtDQ7GuTwVI2B3RODQGbtApWmCIeRDjmNNLZM0KRRKtlAQ6brp1cIqcqDUVvQ1Efw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vgq9SJ9i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vgq9SJ9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D5A1F000E9;
	Thu,  6 Aug 2026 23:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786058034;
	bh=1mIQyfWPmdNSumtwuwMazMZWiL/aPxwuJGVD8NZUy5E=;
	h=Date:To:From:Subject;
	b=vgq9SJ9iVHVqfL3wjjZftxv2mG7TYhgPnvF25H2z8j8gbW+OdHSkGM8ACCnbra7gf
	 mbZr3BCXff1N9/hQSCRQXsz7tfyuUuCVfprSwlAI87vFItMQL+WKIRDquITCmUxMrc
	 C2YSexz3jd0Cm/2GHW2Ynw2tSC2Gv/xrztOy0TXw=
Date: Thu, 06 Aug 2026 16:13:53 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch removed from -mm tree
Message-Id: <20260806231354.65D5A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: introduce VMA virtual page offset field and add helpers
has been removed from the -mm tree.  Its filename was
     mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: introduce VMA virtual page offset field and add helpers
Date: Mon, 20 Jul 2026 15:38:27 +0100

Patch series "mm/rmap: index MAP_PRIVATE file-backed folios by virt
pgoff", v2.

In memory management we've managed to manufacture a great deal of
confusion around the concept of anonymous memory.  We have:

1. 'Pure anon' memory - anonymous VMAs whose folios are anonymous and
   swap-backed (thus for reclaim purposes, treated as anonymous). These are
   simple enough.

2. shmem - file-backed VMAs, file-backed folios (from rmap perspective) so
   present in the page cache and mapped by an address_space object, but
   whose folios are also swap-backed (thus treated as anonymous for reclaim
   purposes).

3. MAP_PRIVATE-mapped /dev/zero - a strange beast whose VMAs have
   vma->vm_file set, but whose mmap_prepare callback clears vma->vm_ops to
   satisfy vma_is_anonymous(), which results in VMAs that were mmap()'d
   referencing a file, but are in every other sense anonymous, including the
   folios.

4. Other MAP_PRIVATE-file backed mappings - These possess file-backed VMAs
   and have file-backed folios until CoW'd, at which point those CoW'd
   folios are anonymous.

This series fixes issues 3 and 4.

In order for us to traverse VMAs using the reverse mapping, we require two
fields - folio->mapping and folio->index.  The first tells the rmap code
where to look for VMAs, and the second tells it at which offset the folio
starts within the referenced object.

For anonymous folios, folio->mapping points at an anon_vma object.  For
file-backed folios, it points at an address_space.  And:

* For file-backed folios folio->index is simply the page offset of the start
  of the folio within the file.

* For anonymous folios belonging to pure anon mappings, folio->index is
  equal to the virtual page offset of the folio.

* For anonymous folios belonging to file-backed mappings (i.e. CoW'd folios
  of a MAP_PRIVATE file-backed mapping), folio->index is equal to the file
  page offset.

This series establishes a new virtual page offset property of VMAs to
allow us to map anonymous folios at their virtual page offset, consistent
with pure anon.

The purpose of doing so is to lay the foundations for the scalable CoW
work.  This is necessary because scalable CoW looks in the maple tree for
the VMA located at folio->index << PAGE_SHIFT, before falling back to
looking up tracked remaps if necessary.

The MAP_PRIVATE file-backed case means that folio indices will very often
conflict with one another and this remap tracking becomes substantially
more contended, and of course the fast path can never be used.

This also makes it possible, in future, to unshare anonymously mapped
folios with deep fork hierarchies on remap, eliminating the need for remap
tracking in the vast majority of cases.

Similar to page offset of pure anonymous VMAs, we update the virtual page
offset of unfaulted file-backed VMAs on remap, but do not once CoW'd (i.e.
vma->anon_vma is non-NULL).

Overall, there is little impact on mergeability - for shared file-backed
mappings, we treat the anonymous page offset as equal to the file-backed
one (via vma_start_anon_pgoff()), so merge behaviour remains the same
there.

The only impact is on MAP_PRIVATE-mapped file-backed mappings, which must
now match on virtual page offset as well as file page offset to be merged.

To fail to merge like this would require CoW'ing the mapping, then finding
another VMA with identical file and compatible page offset to remap next
to.  This is therefore very much an edge case that should have very little
impact (and which scalable CoW may very well address in any case).

We also address the outlier case of MAP_PRIVATE-/dev/zero mappings which
have file page offset but satisfy vma_is_anonymous() by making them truly
anonymous.

This is low-risk as for anything meaningful these mappings behave
anonymously, but it is very beneficial to do so as we eliminate an odd
corner case, and those are notorious for attracting subtle bugs.


This patch (of 15):

This patch establishes fields within the vm_area_struct type to store the
virtual page offset of VMAs.

The virtual page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT
if they are unfaulted or were not remapped, otherwise it is equal to this
value at the point of first fault.

Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
file-backed VMAs are tracked by their file offset.  By adding virtual
offset as a property of VMAs, we can now track them by their virtual page
offset instead.

By tracking this, we provide the means by which to eliminate this
inconsistency, and more importantly lay the foundations for future work
for the scalable CoW anonymous rmap rework.

This patch simply adds the fields and some simple helpers.  Subsequent
patches will update mm code to make use of these fields correctly.

The fields chosen are packed in the VMA such that, for 64-bit kernel
builds, no additional space is taken up.

The first field is present on cacheline 0 containing key VMA fields, and
the second on cacheline 3, which contains file-backed reverse mapping
fields.

Given the relative time spent accessing reverse mapping fields as well as
updating them, there shouldn't be any performance impact here from false
sharing.

Update the VMA userland tests to account for this change.

No callsites are updated yet, so no functional change intended.

Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org
Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-1-2d549757a76f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h              |   59 ++++++++++++++++++++++++++++++
 include/linux/mm_types.h        |   12 ++++++
 mm/vma.h                        |   14 +++++++
 mm/vma_init.c                   |    1 
 tools/testing/vma/include/dup.h |   26 +++++++++++++
 5 files changed, 112 insertions(+)

--- a/include/linux/mm.h~mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers
+++ a/include/linux/mm.h
@@ -4393,6 +4393,65 @@ static inline pgoff_t vma_last_pgoff(con
 	return vma_end_pgoff(vma) - 1;
 }
 
+/**
+ * vma_start_virt_pgoff() - Get the virtual page offset of the start of @vma
+ * @vma: The VMA whose virtual page offset is required.
+ *
+ * If unfaulted, then this is vma->vm_start >> PAGE_SHIFT, if faulted then the
+ * virtual page offset at the time of first fault.
+ *
+ * If the VMA is anonymous, this returns the same value as vma_start_pgoff().
+ *
+ * This value is used for tracking MAP_PRIVATE file-backed mappings by their
+ * virtual page offset.
+ *
+ * Returns: The virtual page offset of the start of @vma.
+ */
+static inline pgoff_t vma_start_virt_pgoff(const struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = 0;
+
+#ifdef CONFIG_64BIT
+	pgoff += vma->__vm_virt_pgoff_hi;
+	pgoff <<= 32;
+#endif
+	pgoff += vma->__vm_virt_pgoff_lo;
+	return pgoff;
+}
+
+/**
+ * vma_end_virt_pgoff() - Get the virtual page offset of the exclusive end of
+ * @vma.
+ * @vma: The VMA whose end virtual page offset is required.
+ *
+ * This returns the virtual exclusive end page offset of @vma, which is useful
+ * for expressing page offset ranges.
+ *
+ * See the description of vma_start_virt_pgoff() for a description of VMA
+ * virtual page offsets.
+ *
+ * Returns: The exclusive end virtual page offset of @vma.
+ */
+static inline pgoff_t vma_end_virt_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_virt_pgoff(vma) + vma_pages(vma);
+}
+
+/**
+ * vma_last_virt_pgoff() - Get the virtual page offset of the last page in
+ * @vma.
+ * @vma: The VMA whose last virtual page offset is required.
+ *
+ * See the description of vma_start_virt_pgoff() for a description of VMA
+ * virtual page offsets.
+ *
+ * Returns: The last virtual page offset of @vma.
+ */
+static inline pgoff_t vma_last_virt_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_end_virt_pgoff(vma) - 1;
+}
+
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
 {
 	return desc->end - desc->start;
--- a/include/linux/mm_types.h~mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers
+++ a/include/linux/mm_types.h
@@ -968,6 +968,11 @@ struct vm_area_struct {
 	unsigned int vm_lock_seq;
 #endif
 	/*
+	 * Low 32-bits of virtual page offset.
+	 * See vma_start_virt_pgoff() comment for details.
+	 */
+	unsigned int __vm_virt_pgoff_lo;
+	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
 	 * list, after a COW of one of the file pages.	A MAP_SHARED vma
 	 * can only be in the i_mmap tree.  An anonymous MAP_PRIVATE, stack
@@ -1042,6 +1047,13 @@ struct vm_area_struct {
 	struct lockdep_map vmlock_dep_map;
 #endif
 #endif
+#ifdef CONFIG_64BIT
+	/*
+	 * High 32-bits of virtual page offset.
+	 * See vma_start_virt_pgoff() comment for details.
+	 */
+	unsigned int __vm_virt_pgoff_hi;
+#endif
 	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
--- a/mm/vma.h~mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers
+++ a/mm/vma.h
@@ -283,6 +283,20 @@ static inline void vma_set_pgoff(struct
 	vma->vm_pgoff = pgoff;
 }
 
+static inline void __vma_set_virt_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+#ifdef CONFIG_64BIT
+	vma->__vm_virt_pgoff_hi = pgoff >> 32;
+#endif
+	vma->__vm_virt_pgoff_lo = pgoff & GENMASK(31, 0);
+}
+
+static inline void vma_set_virt_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+	vma_assert_can_modify(vma);
+	__vma_set_virt_pgoff(vma, pgoff);
+}
+
 static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
--- a/mm/vma_init.c~mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers
+++ a/mm/vma_init.c
@@ -51,6 +51,7 @@ static void vm_area_init_from(const stru
 	dest->vm_end = src->vm_end;
 	dest->anon_vma = src->anon_vma;
 	dest->vm_pgoff = vma_start_pgoff(src);
+	__vma_set_virt_pgoff(dest, vma_start_virt_pgoff(src));
 	dest->vm_file = src->vm_file;
 	dest->vm_private_data = src->vm_private_data;
 	vm_flags_init(dest, src->vm_flags);
--- a/tools/testing/vma/include/dup.h~mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers
+++ a/tools/testing/vma/include/dup.h
@@ -577,6 +577,7 @@ struct vm_area_struct {
 	 */
 	unsigned int vm_lock_seq;
 #endif
+	unsigned int __vm_virt_pgoff_lo;
 
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
@@ -613,6 +614,9 @@ struct vm_area_struct {
 	/* Unstable RCU readers are allowed to read this. */
 	refcount_t vm_refcnt;
 #endif
+#ifdef CONFIG_64BIT
+	unsigned int __vm_virt_pgoff_hi;
+#endif
 	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
@@ -1320,6 +1324,28 @@ static inline pgoff_t vma_end_pgoff(cons
 	return vma_start_pgoff(vma) + vma_pages(vma);
 }
 
+static inline pgoff_t vma_start_virt_pgoff(const struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = 0;
+
+#ifdef CONFIG_64BIT
+	pgoff += vma->__vm_virt_pgoff_hi;
+	pgoff <<= 32;
+#endif
+	pgoff += vma->__vm_virt_pgoff_lo;
+	return pgoff;
+}
+
+static inline pgoff_t vma_end_virt_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_virt_pgoff(vma) + vma_pages(vma);
+}
+
+static inline pgoff_t vma_last_virt_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_end_virt_pgoff(vma) - 1;
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

