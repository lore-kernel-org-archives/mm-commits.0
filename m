Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF07B4D957E
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679441; cv=none; b=hylof21nha1JTrPBHZFLEn+KEF/axdKG1gJNdHdMvvs0mKhlsG0mRbBXWyCLqlLaFVS+aBKG9i05uIpJD/ryabvGpFppyiR9EAXRUgydnLg8TjSVMfucPGP0MPsX9BQmtZhcKVCLanRftwM4pzSxADnXy3OFZOa7gGFZHJ+o+aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679441; c=relaxed/simple;
	bh=JOLmm1K1zD1tyI3u4XusKg+ALM92f0jYH369dd0ctY4=;
	h=Date:To:From:Subject:Message-Id; b=jpRyEl0bvCvygUv2npGbLJax+LO33+VMEuU6ynjhK1bJYy88st2yIEUWAgGgTCssKgphWeZVWzguKtvYrVet43g5bQDrO0a4wxqlX7XQ7QLI3aXYwZCxtLALZrzLRa6bDm33n47lIKEcv0did4P3k5jARjp21vyswm3kqnsMoQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gi/rNuJN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gi/rNuJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DE01F000FF;
	Thu, 17 Sep 2026 21:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679437;
	bh=FHiyH1v+atdtBtwObJyg2C8pkzVAvTPsjfBYlMzwjYU=;
	h=Date:To:From:Subject;
	b=Gi/rNuJNpIkeYpvjj64lb7tRCxWC2bzZGhwvxkcvJeDM8La2BdzOBXrqm6yFAB2P+
	 KMmxGAWSJapxc7SDDchH4fL1Y0c2CPPDQRFwnrAZysy0QElkobr9B61LcZc3N+NDKF
	 CSqkS7Kibfr6Uc4fgs33rGmCx/BvdM9OXihNfPo4=
Date: Thu, 17 Sep 2026 14:10:37 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-introduce-and-use-vma_can_gup.patch removed from -mm tree
Message-Id: <20260917211037.90DE01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: introduce and use vma[_flags]_can_gup()
has been removed from the -mm tree.  Its filename was
     mm-vma-introduce-and-use-vma_can_gup.patch

This patch was dropped because an updated version will be issued

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
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

