Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B25318EC7
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 01:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789434629; cv=none; b=M5fGufwdQQ+W/a4vLkfIu3frvvZdEbBKq94I8uKQdZYQ9oWxCmZ40/jdLmJkkW1y8wIHXEdOVBnxYmstikoeyBGcavBRx+gl4OuDC1c8vNJ6s0KaU8AqZm8NTYU2PJliR8JDyGCl1INAP4N92t/gcizYKhtlsUeQ2oinXqpeiSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789434629; c=relaxed/simple;
	bh=vgLk0h845OB385+ojY3aTnrNL3jA9zmHBG87NcjYfRI=;
	h=Date:To:From:Subject:Message-Id; b=Tm3vxlZ/qYvK69Rcsq7lk+6aSqm0e0/UgNIX4Lo8qQAWjhBDig0/LS01exhjWb+GC8vj2JJoSYUpcWIylkgww4Yn1IRYAuq0SmoXxNXbnVSQyMw9nD6KnG9MyG5ZvnlZDPIcTorifvok0dBCRi+f36rkOBY5YUwFw9xZfjQTzMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=urxig4a3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="urxig4a3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20A41F00893;
	Tue, 15 Sep 2026 01:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789434622;
	bh=tu2SRrPAv2icQ6W5lPQDGaId5P55IUqRO2R1dq9QirA=;
	h=Date:To:From:Subject;
	b=urxig4a3QBWBubDwRvWytYiCSmu1U3/6VlJqbdRYisAGlbc5DuZ4pg/C+UAzmVKzx
	 XlppC4FYdSxW524Rx3hvKNQ8Foo+zS5Ei4cFs+K3Otht9GiXqSBSEInYwFXUfO6SRM
	 YglWUiu2IJPNAGFqcP70zuygBaGuP5CDaZUa2HX0=
Date: Mon, 14 Sep 2026 18:10:22 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-introduce-and-use-vma_can_gup.patch added to mm-new branch
Message-Id: <20260915011022.D20A41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: introduce and use vma[_flags]_can_gup()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-introduce-and-use-vma_can_gup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-introduce-and-use-vma_can_gup.patch

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
Subject: mm/vma: introduce and use vma[_flags]_can_gup()
Date: Mon, 14 Sep 2026 15:58:00 +0100

GUP cannot be used for VMAs which set VMA_IO_BIT - because memory-mapped
I/O must not be accessed on the user's behalf - or VMA_PFNMAP_BIT -
because PFN maps have no folios which the kernel is permitted to access.

Rather than keeping these checks open-coded, abstract them to
vma_flags_can_gup() and its VMA wrapper vma_can_gup().

A number of other places make the same check to decide whether a mapping
can be populated or accessed as GUP would, so update those too.

While here, drop a reference to 'special' and replace a use of the
deprecated VMA flags API in vma_dump_size().

No functional change intended.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-40-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c      |    4 ++--
 include/linux/mm.h |   29 +++++++++++++++++++++++++++++
 mm/gup.c           |    7 +++----
 mm/hmm.c           |    3 +--
 mm/memory.c        |   14 ++++++++------
 mm/mempolicy.c     |    3 ++-
 6 files changed, 45 insertions(+), 15 deletions(-)

--- a/fs/coredump.c~mm-vma-introduce-and-use-vma_can_gup
+++ a/fs/coredump.c
@@ -1616,8 +1616,8 @@ static unsigned long vma_dump_size(struc
 		return 0;
 	}
 
-	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & VM_IO)
+	/* Do not dump memory-mapped I/O, which may have side effects on read. */
+	if (vma_test(vma, VMA_IO_BIT))
 		return 0;
 
 	/* By default, dump shared memory if mapped from an anonymous file. */
--- a/include/linux/mm.h~mm-vma-introduce-and-use-vma_can_gup
+++ a/include/linux/mm.h
@@ -1778,6 +1778,35 @@ static inline bool vma_is_persistent(con
 }
 
 /**
+ * vma_flags_can_gup() - Do the specified VMA flags permit GUP to access the
+ * mapping's pages?
+ * @flags: The VMA flags to test.
+ *
+ * GUP cannot obtain pages from a PFN map (VMA_PFNMAP_BIT), which may have no
+ * struct pages behind it, and must not provide access to memory-mapped I/O
+ * (VMA_IO_BIT).
+ *
+ * Returns: true if GUP may access pages from the mapping, otherwise false.
+ */
+static inline bool vma_flags_can_gup(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_IO_BIT, VMA_PFNMAP_BIT);
+}
+
+/**
+ * vma_can_gup() - May GUP obtain pages from @vma?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_can_gup() for details.
+ *
+ * Returns: true if GUP may access pages from the mapping, otherwise false.
+ */
+static inline bool vma_can_gup(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_gup(&vma->flags);
+}
+
+/**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
  *
--- a/mm/gup.c~mm-vma-introduce-and-use-vma_can_gup
+++ a/mm/gup.c
@@ -1204,7 +1204,7 @@ static int check_vma_flags(struct vm_are
 	int foreign = (gup_flags & FOLL_REMOTE);
 	bool vma_anon = vma_is_anonymous(vma);
 
-	if (vm_flags & (VM_IO | VM_PFNMAP))
+	if (!vma_can_gup(vma))
 		return -EFAULT;
 
 	if ((gup_flags & FOLL_ANON) && !vma_anon)
@@ -1955,7 +1955,7 @@ int __mm_populate(unsigned long start, u
 		 * range with the first VMA. Also, skip undesirable VMA types.
 		 */
 		nend = min(end, vma->vm_end);
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		if (!vma_can_gup(vma))
 			continue;
 		if (nstart < vma->vm_start)
 			nstart = vma->vm_start;
@@ -2017,8 +2017,7 @@ static long __get_user_pages_locked(stru
 			break;
 
 		/* protect what we can, including chardevs */
-		if ((vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
-		    !(vm_flags & vma->vm_flags))
+		if (!vma_can_gup(vma) || !(vm_flags & vma->vm_flags))
 			break;
 
 		if (pages) {
--- a/mm/hmm.c~mm-vma-introduce-and-use-vma_can_gup
+++ a/mm/hmm.c
@@ -595,8 +595,7 @@ static int hmm_vma_walk_test(unsigned lo
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
-	    vma->vm_flags & VM_READ)
+	if (vma_can_gup(vma) && vma_test(vma, VMA_READ_BIT))
 		return 0;
 
 	/*
--- a/mm/memory.c~mm-vma-introduce-and-use-vma_can_gup
+++ a/mm/memory.c
@@ -2417,11 +2417,11 @@ static bool vm_mixed_zeropage_allowed(st
 	 * be problematic as soon as the zeropage gets replaced by a different
 	 * page due to vma->vm_ops->pfn_mkwrite, because what's mapped would
 	 * now differ to what GUP looked up. FSDAX is incompatible to
-	 * FOLL_LONGTERM and VM_IO is incompatible to GUP completely (see
-	 * check_vma_flags).
+	 * FOLL_LONGTERM and memory-mapped I/O is incompatible to GUP completely
+	 * (see vma_can_gup()).
 	 */
 	return vma->vm_ops && vma->vm_ops->pfn_mkwrite &&
-	       (vma_is_fsdax(vma) || vma->vm_flags & VM_IO);
+	       (vma_is_fsdax(vma) || vma_test(vma, VMA_IO_BIT));
 }
 
 static int validate_page_before_insert(struct vm_area_struct *vma,
@@ -7116,7 +7116,8 @@ int follow_pfnmap_start(struct follow_pf
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		goto out;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+	/* Only mappings GUP cannot handle are followed here. */
+	if (vma_can_gup(vma))
 		goto out;
 retry:
 	pgdp = pgd_offset(mm, address);
@@ -7316,8 +7317,9 @@ static int __access_remote_vm(struct mm_
 			}
 
 			/*
-			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
-			 * we can access using slightly different code.
+			 * GUP failed, perhaps because this is a mapping it
+			 * cannot handle (see vma_can_gup()) - such mappings may
+			 * provide access via vm_ops->access() instead.
 			 */
 			bytes = 0;
 #ifdef CONFIG_HAVE_IOREMAP_PROT
--- a/mm/mempolicy.c~mm-vma-introduce-and-use-vma_can_gup
+++ a/mm/mempolicy.c
@@ -2013,7 +2013,8 @@ SYSCALL_DEFINE5(get_mempolicy, int __use
 
 bool vma_migratable(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+	/* Pages which GUP cannot obtain cannot be migrated either. */
+	if (!vma_can_gup(vma))
 		return false;
 
 	/*
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-huge_memory-zap-deposited-page-tables-after-an-rcu-grace-period.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-make-userland-page-table-freeing-rcu-safe.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-predicate-setting-mmap_prepare-vma-fields-on-new-vma-alloc.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_kernel_owned-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-kernel-owned.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_persistent.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch

