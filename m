Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFE91E9B0B
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801644; cv=none; b=DUeAEWtDumSdtilouMraftLdUsr5G7eAzgYoptMud7ydvn9NEDisFzPrNqO+CSKhao2Byhq+FmGJy115h5zDKXJ+xId1j6/fRNX2uGT/8EI2PNlzcSHjKODPSdIVm3xyt8y9PGZhOTvrTI7Tw6wGChAWETu/MUqY4zawbwzieQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801644; c=relaxed/simple;
	bh=w1ilmna/o4Vag1LNp+ZZoqxnYMujBdOkgbqcVAIJgkY=;
	h=Date:To:From:Subject:Message-Id; b=GMBM6CR0p5kF2Q97Yk637HRIiXlT+rJiiMJ1RxeDLXsKJhVNyu2fbRBs6oZ5nPmpuPIOkwFDY0U9jrdpkxggzc/w01BeluR7p89mJVRHELY6/gJkrdNsSOHFISZreY4R9oh7rRar66TCGgXVGFwsZnaYi6UZb9UsL2A5CtuyynM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=enct0QBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="enct0QBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90B9C4CEEB;
	Sat, 13 Sep 2025 22:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801643;
	bh=w1ilmna/o4Vag1LNp+ZZoqxnYMujBdOkgbqcVAIJgkY=;
	h=Date:To:From:Subject:From;
	b=enct0QBHENX0MkJs9GHE1GRaNWoRGh/i+U3PM4ICR0eO3jmdRdz9VuvG/ZVXbmT+9
	 P4eqOFmzJ18HufNSRPg67s2Z3GfR5n2U+8CQ1m8QBUkvtVbrHr4OP7dsB01Mxl89cz
	 i2qYErVqoWBiXeZNI2LhXAjRvUTkOnsaBcf11J2c=
Date: Sat, 13 Sep 2025 15:14:03 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-bitmap-mm-flags-field-fix.patch removed from -mm tree
Message-Id: <20250913221403.D90B9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: place __private in correct place, const-ify __mm_flags_get_word
has been removed from the -mm tree.  Its filename was
     mm-add-bitmap-mm-flags-field-fix.patch

This patch was dropped because it was folded into mm-add-bitmap-mm-flags-field.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: place __private in correct place, const-ify __mm_flags_get_word
Date: Wed, 13 Aug 2025 20:40:10 +0100

The __private sparse indicator was placed in the wrong location, resulting
in sparse errors, correct this by placing it where it ought to be.

Also, share some code for __mm_flags_get_word() and const-ify it to be
consistent.

Finally, fixup inconsistency in __mm_flags_set_word() param alignment.

Link: https://lkml.kernel.org/r/d4ba117d-6234-4069-b871-254d152d7d21@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/include/linux/mm_types.h~mm-add-bitmap-mm-flags-field-fix
+++ a/include/linux/mm_types.h
@@ -934,8 +934,8 @@ struct mm_cid {
  */
 #define NUM_MM_FLAG_BITS BITS_PER_LONG
 typedef struct {
-	__private DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
-} mm_flags_t;
+	DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
+} __private mm_flags_t;
 
 struct kioctx_table;
 struct iommu_mm_data;
@@ -1233,17 +1233,8 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
-/* Read the first system word of mm flags, non-atomically. */
-static inline unsigned long __mm_flags_get_word(struct mm_struct *mm)
-{
-	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
-
-	return bitmap_read(bitmap, 0, BITS_PER_LONG);
-}
-
 /* Set the first system word of mm flags, non-atomically. */
-static inline void __mm_flags_set_word(struct mm_struct *mm,
-				       unsigned long value)
+static inline void __mm_flags_set_word(struct mm_struct *mm, unsigned long value)
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
 
@@ -1256,6 +1247,14 @@ static inline const unsigned long *__mm_
 	return (const unsigned long *)ACCESS_PRIVATE(&mm->_flags, __mm_flags);
 }
 
+/* Read the first system word of mm flags, non-atomically. */
+static inline unsigned long __mm_flags_get_word(const struct mm_struct *mm)
+{
+	const unsigned long *bitmap = __mm_flags_get_bitmap(mm);
+
+	return bitmap_read(bitmap, 0, BITS_PER_LONG);
+}
+
 #define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
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
mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch
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

