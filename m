Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3201EEE6
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 23:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757807429; cv=none; b=ElCRFWIlcp+MxVQFb7KNmB8mGL3zzS/g9Vfcdw1qTmXlg32byxZSYzUSBXra5TT6JaEY9zIKrFFhroKQHB8icvN4ugQ9+JLT4us0V8NlfjmsgHirP7/8esP4I2xKB0IG0Ht9FwhjOktE21AO0S8NV0m7eX3MRZ59UNPzHAPi+fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757807429; c=relaxed/simple;
	bh=H2IyJLstryveY+fBDJpGfNc5jijlDoVm23C7/B6iTmw=;
	h=Date:To:From:Subject:Message-Id; b=nJwUpBRIGNc2C3zkk6z3PGb76X8HA9N0ok6gSijHoPw4mXlFDdLJDrzxuWc5qzchyO3XBZG+R+uKrgQMFzxU9mhyfsrLiXOEvXlLSAu1CpJdB/uc9DnDkHDpxF7mNbypn7mIlnuPkgvi7hlRMuDM44HnbWeJKXehqS2PXoiOSoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2rjvrX6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2rjvrX6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20941C4CEEB;
	Sat, 13 Sep 2025 23:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757807429;
	bh=H2IyJLstryveY+fBDJpGfNc5jijlDoVm23C7/B6iTmw=;
	h=Date:To:From:Subject:From;
	b=2rjvrX6eRvKiEDho9cJ2+RJdEGiIMpQhW8hUuHVNqFj/zJn5SJDzswja3IKdPyXVO
	 kQ4jygoUgXQQ2xTH+ffFGlcfH6LB/3pE/RKgn0gGV2aO+yjbHMQ2meVlErmWQ52j2p
	 sp8px3giCVUbjGCZMgxJfdbd6WPyQ2qD3GorJF54=
Date: Sat, 13 Sep 2025 16:50:28 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch removed from -mm tree
Message-Id: <20250913235029.20941C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: abstract set_mask_bits() invocation to mm_types.h to satisfy ARC
has been removed from the -mm tree.  Its filename was
     mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch

This patch was dropped because it was folded into mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: abstract set_mask_bits() invocation to mm_types.h to satisfy ARC
Date: Tue, 26 Aug 2025 12:25:16 +0100

There's some horrible recursive header issue for ARCH whereby you can't
even apparently include very fundamental headers like compiler_types.h in
linux/sched/coredump.h.

So work around this by putting the thing that needs this (use of
ACCESS_PRIVATE()) into mm_types.h which presumably in some fashion avoids
this issue.

This also makes it consistent with __mm_flags_get_dumpable() so is a good
change to make things more consistent and neat anyway.

Link: https://lkml.kernel.org/r/0e7ad263-1ff7-446d-81fe-97cff9c0e7ed@lucifer.local
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508240502.frw1Krzo-lkp@intel.com/
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h       |   12 ++++++++++++
 include/linux/sched/coredump.h |    5 +----
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/mm_types.h~mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix
+++ a/include/linux/mm_types.h
@@ -1255,6 +1255,18 @@ static inline unsigned long __mm_flags_g
 	return bitmap_read(bitmap, 0, BITS_PER_LONG);
 }
 
+/*
+ * Update the first system word of mm flags ONLY, applying the specified mask to
+ * it, then setting all flags specified by bits.
+ */
+static inline void __mm_flags_set_mask_bits_word(struct mm_struct *mm,
+		unsigned long mask, unsigned long bits)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
+
+	set_mask_bits(bitmap, mask, bits);
+}
+
 #define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
--- a/include/linux/sched/coredump.h~mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix
+++ a/include/linux/sched/coredump.h
@@ -2,7 +2,6 @@
 #ifndef _LINUX_SCHED_COREDUMP_H
 #define _LINUX_SCHED_COREDUMP_H
 
-#include <linux/compiler_types.h>
 #include <linux/mm_types.h>
 
 #define SUID_DUMP_DISABLE	0	/* No setuid dumping */
@@ -20,9 +19,7 @@ static inline unsigned long __mm_flags_g
 
 static inline void __mm_flags_set_mask_dumpable(struct mm_struct *mm, int value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
-
-	set_mask_bits(bitmap, MMF_DUMPABLE_MASK, value);
+	__mm_flags_set_mask_bits_word(mm, MMF_DUMPABLE_MASK, value);
 }
 
 extern void set_dumpable(struct mm_struct *mm, int value);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-bitmap-mm-flags-field.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
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

