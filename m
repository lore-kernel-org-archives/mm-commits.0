Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B673C1E9B0B
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801689; cv=none; b=oKuAc7SWjPjQnvZ7kBoU9MHinIHY/D093CQtyfAA78Twv5PXSKL3YiUBRCc/Gc+Nz/5xahNWUvWTPezBO9RLEESFj05EoH6rRr2lXfTywJUAnj16O1OOAeDq6n8my1SkBz89e+UodtESoiEgkXBGbP360K9wYXDhXH7v+ZfqUEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801689; c=relaxed/simple;
	bh=5xVRAOEhNONxcPt06pBl9qDTb1KyidqcC/GVo5cbZpI=;
	h=Date:To:From:Subject:Message-Id; b=OeCZ4Rt9IgcGwSAgpxOmO59e4KEuAfHlCrK5G8TeDwvyA8VCnCmIod1lnenDlU3tHYfcj/XztA+BUsppkZ6YqRDdmY5SocKnaCMCKKj3RPwZn2Tu17YaO2NvJtrFDT748Wu5pBw2Zl3s5RLrIgOxgiKh8pZBgLFReFGqD6UFe6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sZ4gQZH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sZ4gQZH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BA5C4CEEB;
	Sat, 13 Sep 2025 22:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801689;
	bh=5xVRAOEhNONxcPt06pBl9qDTb1KyidqcC/GVo5cbZpI=;
	h=Date:To:From:Subject:From;
	b=sZ4gQZH4hSHPbjnzZJ3DvqPYH3+KV75LbQ+g2mt5NatZjoCZVPW2DLjtRBomzNe+1
	 as33OU8rjsMMZ8NAaCa2rnd3B0MIsqu860/zt7nUI0cr0Rkqq0OsHUZkJRYU2mp5YJ
	 ZQpqh+TMWDrKtV/+aDF4Y+NyH5Eg+YagV7rSOf8c=
Date: Sat, 13 Sep 2025 15:14:48 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch removed from -mm tree
Message-Id: <20250913221449.41BA5C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prefer BIT() to _BITUL()
has been removed from the -mm tree.  Its filename was
     mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch

This patch was dropped because it was folded into mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: prefer BIT() to _BITUL()
Date: Tue, 26 Aug 2025 15:01:18 +0100

BIT() does the same thing, and is defined in actual linux headers rather
than a uapi header.  per David.

Link: https://lkml.kernel.org/r/a0290c77-cd88-46d6-8d9a-073be7600d88@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/include/linux/mm_types.h~mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix
+++ a/include/linux/mm_types.h
@@ -1767,7 +1767,7 @@ enum {
  * the modes are SUID_DUMP_* defined in linux/sched/coredump.h
  */
 #define MMF_DUMPABLE_BITS 2
-#define MMF_DUMPABLE_MASK (_BITUL(MMF_DUMPABLE_BITS) - 1)
+#define MMF_DUMPABLE_MASK (BIT(MMF_DUMPABLE_BITS) - 1)
 /* coredump filter bits */
 #define MMF_DUMP_ANON_PRIVATE	2
 #define MMF_DUMP_ANON_SHARED	3
@@ -1782,13 +1782,13 @@ enum {
 #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
 #define MMF_DUMP_FILTER_BITS	9
 #define MMF_DUMP_FILTER_MASK \
-	((_BITUL(MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
+	((BIT(MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
 #define MMF_DUMP_FILTER_DEFAULT \
-	(_BITUL(MMF_DUMP_ANON_PRIVATE) | _BITUL(MMF_DUMP_ANON_SHARED) | \
-	 _BITUL(MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
+	(BIT(MMF_DUMP_ANON_PRIVATE) | BIT(MMF_DUMP_ANON_SHARED) | \
+	 BIT(MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
 
 #ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
-# define MMF_DUMP_MASK_DEFAULT_ELF	_BITUL(MMF_DUMP_ELF_HEADERS)
+# define MMF_DUMP_MASK_DEFAULT_ELF	BIT(MMF_DUMP_ELF_HEADERS)
 #else
 # define MMF_DUMP_MASK_DEFAULT_ELF	0
 #endif
@@ -1808,7 +1808,7 @@ enum {
 #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
 #define MMF_HUGE_ZERO_FOLIO	23      /* mm has ever used the global huge zero folio */
 #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
-#define MMF_DISABLE_THP_MASK	_BITUL(MMF_DISABLE_THP)
+#define MMF_DISABLE_THP_MASK	BIT(MMF_DISABLE_THP)
 #define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
 #define MMF_MULTIPROCESS	26	/* mm is shared between processes */
 /*
@@ -1821,15 +1821,15 @@ enum {
 #define MMF_HAS_PINNED		27	/* FOLL_PIN has run, never cleared */
 
 #define MMF_HAS_MDWE		28
-#define MMF_HAS_MDWE_MASK	_BITUL(MMF_HAS_MDWE)
+#define MMF_HAS_MDWE_MASK	BIT(MMF_HAS_MDWE)
 
 #define MMF_HAS_MDWE_NO_INHERIT	29
 
 #define MMF_VM_MERGE_ANY	30
-#define MMF_VM_MERGE_ANY_MASK	_BITUL(MMF_VM_MERGE_ANY)
+#define MMF_VM_MERGE_ANY_MASK	BIT(MMF_VM_MERGE_ANY)
 
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
-#define MMF_TOPDOWN_MASK	_BITUL(MMF_TOPDOWN)
+#define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-bitmap-mm-flags-field.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch
mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch
mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-introduce-io_remap_pfn_range_.patch
mm-introduce-io_remap_pfn_range_-fix.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-update-cramfs-to-use-mmap_prepare.patch
fs-proc-add-the-proc_mmap_prepare-hook-for-procfs.patch
fs-proc-update-vmcore-to-use-proc_mmap_prepare.patch
fs-proc-update-vmcore-to-use-proc_mmap_prepare-fix.patch
kcov-update-kcov-to-use-mmap_prepare.patch

