Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848713B83F9
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786643711; cv=none; b=i29SEIDYZD/EP+wnZOoHuWEa7XucwKGhodWTx3K8z0gYsJ21Pt+xY8EkSu9dn5AXH7A2LeXMXLq6tkIV3Ys9PgSIF/PU6moqBZquSr5+FmSbAlokcpfPwX0cjtw/uUTn4p6SSoejQIeP/Yjhd08nUN+1RFvc6CYncUj+JJu9M7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786643711; c=relaxed/simple;
	bh=V4yJ5XjO4qEz/+k8vwxXKgFWhen2b9zbBQohvdZ+9NA=;
	h=Date:To:From:Subject:Message-Id; b=l3yN9waq18vQbvv8qZAGHYAiB+L6p99w7p7TVCr8eCUbJgxUsIcdlH/xWBafzbn3PY7d9R1kGy6xLgcT8KPPoOA78K5AO/PVTUyzPPf368f2AKaLmneGRVuo3IwezlOP2WLtiTJO4BwSp+u5sz9VJEARYo1NB8yfeuibcd7JB48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wDr74In/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wDr74In/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570581F000E9;
	Thu, 13 Aug 2026 17:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786643700;
	bh=3iyS8fCQhEA6/zlv0guIusRfF1aqj/n3m3gtXVvLZ1I=;
	h=Date:To:From:Subject;
	b=wDr74In/1CiQ5a5ihJ/tpTLAiXYfH+/iI8/cHfvvBQ3MqH6ArJuz4cRy9tl/BJsRM
	 iHwBOhzvAkzcIkG+1aWs5mmJvlDIGbV+hw889Utqa2/bcTpyKvF4IYRA/yb95t9gz5
	 TGOy8Bp8FfyBb9xdr5sipjKezNVmciz4dUO2m4Uk=
Date: Thu, 13 Aug 2026 10:54:59 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch removed from -mm tree
Message-Id: <20260813175500.570581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: introduce VMA anon page offset field and add helpers
has been removed from the -mm tree.  Its filename was
     mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: introduce VMA anon page offset field and add helpers
Date: Thu, 06 Aug 2026 21:21:26 +0100

Patch series "mm/rmap: index MAP_PRIVATE file-backed folios by anonymous
pgoff", v4.


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
   vma->vm_file set, but which clears vma->vm_ops to satisfy
   vma_is_anonymous(), resulting in VMAs that were mmap()'d referencing a
   file, but are in every other sense anonymous, including the folios.

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
  equal to the anonymous page offset of the folio.

* For anonymous folios belonging to file-backed mappings (i.e. CoW'd folios
  of a MAP_PRIVATE file-backed mapping), folio->index is equal to the file
  page offset.

This series establishes a new anonymous page offset property of VMAs to
allow us to map anonymous folios at their anonymous page offset,
consistent with pure anon.

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

Similar to page offset of pure anonymous VMAs, we update the anonymous
page offset of unfaulted file-backed VMAs on remap, but do not once CoW'd
(i.e.  vma->anon_vma is non-NULL).

Overall, there is little impact on mergeability, which remains exactly the
same for pure anonymous and shared file-backed mappings, with the only
impact being on MAP_PRIVATE-mapped file-backed mappings, which must now
match on anonymous page offset as well as file page offset to be merged.

To fail to merge like this would require CoW'ing the mapping, then finding
another VMA with identical file and compatible page offset to remap next
to.

This is therefore very much an edge case that should have very little
impact (and which scalable CoW may very well address in any case).

We also address the outlier case of MAP_PRIVATE-/dev/zero mappings which
have file page offset but satisfy vma_is_anonymous() by making them truly
anonymous.

This is low-risk as for anything meaningful these mappings behave
anonymously, but it is very beneficial to do so as we eliminate an odd
corner case, and those are notorious for attracting subtle bugs.


This patch (of 20):

Establish fields in vm_area_struct to store the anonymous page offset of
VMAs.

Initially, the anonymous page offset of a VMA is vma->vm_start >>
PAGE_SHIFT.

When a VMA is remapped to new_address its anonymous page offset is either
updated to new_address >> PAGE_SHIFT if unfaulted or, if faulted, remains
equal to the anonymous page offset it had when first faulted.

Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
file-backed VMAs are tracked by their file offsets.  By adding anonymous
offset as a property of VMAs, we can now track them by their anonymous
page offset instead.

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

Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org
Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-1-ab318a350404@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Deucher <alexander.deucher@amd.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ray <Ray.Huang@amd.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <syzbot@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h              |   59 ++++++++++++++++++++++++++++++
 include/linux/mm_types.h        |   12 ++++++
 mm/vma.h                        |   14 +++++++
 mm/vma_init.c                   |    1 
 tools/testing/vma/include/dup.h |   26 +++++++++++++
 5 files changed, 112 insertions(+)

--- a/include/linux/mm.h~mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers
+++ a/include/linux/mm.h
@@ -4393,6 +4393,65 @@ static inline pgoff_t vma_last_pgoff(con
 	return vma_end_pgoff(vma) - 1;
 }
 
+/**
+ * vma_start_anon_pgoff() - Get the anonymous page offset of the start of @vma
+ * @vma: The VMA whose anonymous page offset is required.
+ *
+ * If unfaulted, then this is vma->vm_start >> PAGE_SHIFT, if faulted then the
+ * anonymous page offset at the time of first fault.
+ *
+ * If the VMA is anonymous, this returns the same value as vma_start_pgoff().
+ *
+ * This value is used for tracking MAP_PRIVATE file-backed mappings by their
+ * anonymous page offset.
+ *
+ * Returns: The anonymous page offset of the start of @vma.
+ */
+static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = 0;
+
+#ifdef CONFIG_64BIT
+	pgoff += vma->__vm_anon_pgoff_hi;
+	pgoff <<= 32;
+#endif
+	pgoff += vma->__vm_anon_pgoff_lo;
+	return pgoff;
+}
+
+/**
+ * vma_end_anon_pgoff() - Get the anonymous page offset of the exclusive end of
+ * @vma.
+ * @vma: The VMA whose end anonymous page offset is required.
+ *
+ * This returns the anonymous exclusive end page offset of @vma, which is useful
+ * for expressing page offset ranges.
+ *
+ * See the description of vma_start_anon_pgoff() for a description of VMA
+ * anonymous page offsets.
+ *
+ * Returns: The exclusive end anonymous page offset of @vma.
+ */
+static inline pgoff_t vma_end_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_anon_pgoff(vma) + vma_pages(vma);
+}
+
+/**
+ * vma_last_anon_pgoff() - Get the anonymous page offset of the last page in
+ * @vma.
+ * @vma: The VMA whose last anonymous page offset is required.
+ *
+ * See the description of vma_start_anon_pgoff() for a description of VMA
+ * anonymous page offsets.
+ *
+ * Returns: The last anonymous page offset of @vma.
+ */
+static inline pgoff_t vma_last_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_end_anon_pgoff(vma) - 1;
+}
+
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
 {
 	return desc->end - desc->start;
--- a/include/linux/mm_types.h~mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers
+++ a/include/linux/mm_types.h
@@ -968,6 +968,11 @@ struct vm_area_struct {
 	unsigned int vm_lock_seq;
 #endif
 	/*
+	 * Low 32-bits of anonymous page offset.
+	 * See vma_start_anon_pgoff() comment for details.
+	 */
+	unsigned int __vm_anon_pgoff_lo;
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
+	 * High 32-bits of anonymous page offset.
+	 * See vma_start_anon_pgoff() comment for details.
+	 */
+	unsigned int __vm_anon_pgoff_hi;
+#endif
 	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
--- a/mm/vma.h~mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers
+++ a/mm/vma.h
@@ -283,6 +283,20 @@ static inline void vma_set_pgoff(struct
 	vma->vm_pgoff = pgoff;
 }
 
+static inline void __vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+#ifdef CONFIG_64BIT
+	vma->__vm_anon_pgoff_hi = pgoff >> 32;
+#endif
+	vma->__vm_anon_pgoff_lo = pgoff & GENMASK(31, 0);
+}
+
+static inline void vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+	vma_assert_can_modify(vma);
+	__vma_set_anon_pgoff(vma, pgoff);
+}
+
 static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
--- a/mm/vma_init.c~mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers
+++ a/mm/vma_init.c
@@ -51,6 +51,7 @@ static void vm_area_init_from(const stru
 	dest->vm_end = src->vm_end;
 	dest->anon_vma = src->anon_vma;
 	dest->vm_pgoff = vma_start_pgoff(src);
+	__vma_set_anon_pgoff(dest, vma_start_anon_pgoff(src));
 	dest->vm_file = src->vm_file;
 	dest->vm_private_data = src->vm_private_data;
 	vm_flags_init(dest, src->vm_flags);
--- a/tools/testing/vma/include/dup.h~mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers
+++ a/tools/testing/vma/include/dup.h
@@ -577,6 +577,7 @@ struct vm_area_struct {
 	 */
 	unsigned int vm_lock_seq;
 #endif
+	unsigned int __vm_anon_pgoff_lo;
 
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
@@ -613,6 +614,9 @@ struct vm_area_struct {
 	/* Unstable RCU readers are allowed to read this. */
 	refcount_t vm_refcnt;
 #endif
+#ifdef CONFIG_64BIT
+	unsigned int __vm_anon_pgoff_hi;
+#endif
 	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
@@ -1320,6 +1324,28 @@ static inline pgoff_t vma_end_pgoff(cons
 	return vma_start_pgoff(vma) + vma_pages(vma);
 }
 
+static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = 0;
+
+#ifdef CONFIG_64BIT
+	pgoff += vma->__vm_anon_pgoff_hi;
+	pgoff <<= 32;
+#endif
+	pgoff += vma->__vm_anon_pgoff_lo;
+	return pgoff;
+}
+
+static inline pgoff_t vma_end_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_anon_pgoff(vma) + vma_pages(vma);
+}
+
+static inline pgoff_t vma_last_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_end_anon_pgoff(vma) - 1;
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch
maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch

