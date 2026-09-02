Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DE538DC64
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788376920; cv=none; b=UCCnPL2TJDe3xcShXZL5W6HeehLzExoFhlP3qYe2jIFrSLMJ5smKvhpJ3rqqIE81mLnxps/qhfxbVBmZJbG1T2mQuu0wRKBrs0cYFoVXwEH891+361zzXbqm8TiqT7waIHXSHclXBuxNAIPJMi5zfbt272QTPOH1oHyZHT31aIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788376920; c=relaxed/simple;
	bh=AhCJKsaVtMIMg4FpH9gUZX7EC9cjNoZNnAfxKsqV6pk=;
	h=Date:To:From:Subject:Message-Id; b=h+NMSPUiwJ1nfxghCSU4M7DBD1vxid5nWUJUzgZ40nLIZHSKI5h1Da6yK/U5bY2K4RN6RcFQOU7bONtNyW0qomfN8tjXvxE4STaRZL6waZuImead9dN3hBYTF48LZnsvuT+37OtHAcuGoF1P5qeSZST0iPAIakh1D6oCjB3X21o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZiORp4N5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZiORp4N5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F541F000E9;
	Wed,  2 Sep 2026 19:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788376918;
	bh=yKRIb26QcEg3LhnsL+6LWsPvRfd2TY3bzCcEgj4Yabs=;
	h=Date:To:From:Subject;
	b=ZiORp4N57OmPL9vVd28d7VBGVlIZFoEPjQR0x8M/Mjx6HxPa/VsxnEITUoIVjmgKT
	 LMZ5TJiRmSwYRd+wqe3h8n+Lbvr0pu0li5beS6A1HKjWDeD7N5tpV9NmsC84Ela+pM
	 uT3y0txj/Y4wOYj7QPaEmbkpha+W1iGRvOmbAGpM=
Date: Wed, 02 Sep 2026 12:21:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,jack@suse.cz,hughd@google.com,gregkh@linuxfoundation.org,david@kernel.org,baolin.wang@linux.alibaba.com,arnd@arndb.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch added to mm-new branch
Message-Id: <20260902192158.07F541F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
Date: Wed, 02 Sep 2026 19:00:21 +0100

When mapping /dev/zero with MAP_PRIVATE, one ends up with strange VMAs
originating from Linux's distant past.

These have vma->vm_file set but NULL vma->vm_ops, meaning they satisfy
vma_is_anonymous() but otherwise resemble a file-backed VMA.

The introduction of anonymous page offsets and their subsequent use as
indexes for MAP_PRIVATE-file-backed mappings mean the rmap does the right
thing with these but we are left with inconsistencies.

The vma_start_pgoff(vma) == vma_start_anon_pgoff(vma) invariant is true
for all other anonymous VMAs, but not these.

These VMAs are also observable as files in /proc/<pid>/[maps, smaps,
map_files] but otherwise behave like anonymous mappings.

Therefore let's make these VMAs actually anonymous at mapping time which
will activate the anonymous code path for mappings.

This means we no longer have to account for this discrepancy anywhere and
no longer have to think about these at all.

This is user-observable, as MAP_PRIVATE-/dev/zero will no longer appear in
procfs as a file-backed mapping, but the impact of this change should be
low as likely nobody is relying upon this.

However in any case, in using MAP_PRIVATE-/dev/zero they are explicitly
asking anonymous memory, so no longer seeing these as file mappings is in
fact correct.

A previous commit gave us file_is_dev_zero() to positively identify these
mappings, so we expressly only do so for these alone.

Update assert_sane_pgoff(), the comment for vma_start_pgoff() and
linear_anon_page_index() to reflect the change.

We make this change in call_mmap_prepare() alone as /dev/zero has been
converted to an mmap_prepare hook and we do not permit nested MAP_PRIVATE
mapping of /dev/zero.

We also remove the now defunct vma_desc_set_anonymous() and eliminate the
temporary bisection hazard fix from the previous commit.

Also update the VMA userland tests to reflect the change.

Finally, update the procfs self tests proc-self-map-files-001 and
proc-self-map-files-002 which both intend to map an arbitrary file
MAP_PRIVATE then assert procfs state, but happen to choose /dev/zero.

Fix them by updating these to /proc/self/exe which is guaranteed to be
present if procfs is mounted.

Link: https://lore.kernel.org/20260902-map-private-dev-zero-v1-4-a578c730cec7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                                     |   10 ---
 include/linux/pagemap.h                                |    3 -
 mm/vma.c                                               |   26 ++++++----
 mm/vma.h                                               |    3 -
 tools/testing/selftests/proc/proc-self-map-files-001.c |    2 
 tools/testing/selftests/proc/proc-self-map-files-002.c |    2 
 tools/testing/vma/include/dup.h                        |    3 -
 7 files changed, 23 insertions(+), 26 deletions(-)

--- a/include/linux/mm.h~mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous
+++ a/include/linux/mm.h
@@ -1529,11 +1529,6 @@ static inline void vma_set_anonymous(str
 	vma->vm_ops = NULL;
 }
 
-static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
-{
-	desc->vm_ops = NULL;
-}
-
 static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
@@ -4389,9 +4384,8 @@ static inline unsigned long vma_pages(co
  * If @vma is a MAP_PRIVATE file-backed mapping, then this returns the
  * page offset within the file.
  *
- * Edge cases: nommu does not abide by these, MAP_PRIVATE-/dev/zero satisfies
- * vma_is_anonymous() but has file-backed page offset, and MAP_PRIVATE-pfnmap
- * regions have their page offset set to the first PFN in the range.
+ * Edge cases: nommu does not abide by these and CoW MAP_PRIVATE-pfnmap regions
+ * have their page offset set to the first PFN in the range.
  *
  * Returns: The page offset of the start of @vma.
  */
--- a/include/linux/pagemap.h~mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous
+++ a/include/linux/pagemap.h
@@ -1128,8 +1128,7 @@ static inline pgoff_t linear_anon_page_i
 	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;
--- a/mm/vma.c~mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous
+++ a/mm/vma.c
@@ -2621,6 +2621,13 @@ static int __mmap_new_file_vma(struct mm
 	return 0;
 }
 
+static void map_set_anon(struct mmap_state *map)
+{
+	map->file = NULL;
+	map->vm_ops = NULL;
+	map->pgoff = map->addr >> PAGE_SHIFT;
+}
+
 static bool map_is_private(const struct mmap_state *map)
 {
 	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
@@ -2628,10 +2635,7 @@ static bool map_is_private(const struct
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	if (!map_is_private(map))
-		return false;
-
-	return !map->file || file_is_dev_zero(map->file);
+	return map_is_private(map) && !map->file;
 }
 
 /*
@@ -2663,7 +2667,7 @@ static int __mmap_new_vma(struct mmap_st
 
 	vma_iter_config(vmi, map->addr, map->end);
 
-	if (is_anon && !map->file)
+	if (is_anon)
 		vma_set_anonymous(vma);
 
 	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
@@ -2681,10 +2685,6 @@ static int __mmap_new_vma(struct mmap_st
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
 
-	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
-	if (is_anon && map->file)
-		vma_set_anonymous(vma);
-
 	if (error)
 		goto free_iter_vma;
 
@@ -2813,6 +2813,14 @@ static int call_mmap_prepare(struct mmap
 	map->vm_ops = desc->vm_ops;
 	map->vm_private_data = desc->private_data;
 
+	/*
+	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
+	 * anonymous mappings. Rather than allowing these mappings to be odd
+	 * outliers, simply make them truly anonymous.
+	 */
+	if (map_is_private(map) && file_is_dev_zero(map->file))
+		map_set_anon(map);
+
 	return 0;
 }
 
--- a/mm/vma.h~mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous
+++ a/mm/vma.h
@@ -267,9 +267,6 @@ static inline void assert_sane_pgoff(str
 	 */
 	if (!vma_is_anonymous(vma))
 		return;
-	/* MAP_PRIVATE-/dev/zero is anon, non-NULL vm_file, but has file pgoff. */
-	if (vma->vm_file)
-		return;
 	/* If faulted in, could have been remapped. */
 	if (vma->anon_vma)
 		return;
--- a/tools/testing/selftests/proc/proc-self-map-files-001.c~mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous
+++ a/tools/testing/selftests/proc/proc-self-map-files-001.c
@@ -51,7 +51,7 @@ int main(void)
 	int fd;
 	unsigned long a, b;
 
-	fd = open("/dev/zero", O_RDONLY);
+	fd = open("/proc/self/exe", O_RDONLY);
 	if (fd == -1)
 		return 1;
 
--- a/tools/testing/selftests/proc/proc-self-map-files-002.c~mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous
+++ a/tools/testing/selftests/proc/proc-self-map-files-002.c
@@ -57,7 +57,7 @@ int main(void)
 	int fd;
 	unsigned long a, b;
 
-	fd = open("/dev/zero", O_RDONLY);
+	fd = open("/proc/self/exe", O_RDONLY);
 	if (fd == -1)
 		return 1;
 
--- a/tools/testing/vma/include/dup.h~mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous
+++ a/tools/testing/vma/include/dup.h
@@ -1635,8 +1635,7 @@ static inline pgoff_t linear_anon_page_i
 	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch
mm-secretmem-properly-account-locked-pages.patch
mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch
mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch
mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

