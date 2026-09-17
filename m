Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB314E50DF
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679432; cv=none; b=lTUYdPn7aPviMt1Rx57NDOYG9KRqMg+9LulmcJ8vlRN3NppnfQPk2G/Q4Mavo24k6nbxi7+YjyX8ulX+MxyP1Ir9TGqF1O+x83MupsCDIU0O5Pd3ChTEgS8xxHQwoXHL+eswd5eMdcm9mgZ3/o2HUIu9ogb3Yp1rrzMc4GnKKAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679432; c=relaxed/simple;
	bh=f8TVpfAwtrM//+glYt3CO5jkwR6mUFTPNlgJGU5QwDI=;
	h=Date:To:From:Subject:Message-Id; b=q5m0Hd1spbOjsRSCBDPXJJiIxiW7qWWonRy5FMBDqL5GknTo3r1YFy6MxXXxo5nD3RNP6EAD91G8TZCF3ONrV4NFM42pYyl24FIMCSEMPzk+PIzxxqYk+LGI5Ly6HlNcKvhBToJMPuAtDVIp85GPlwYmSq8a0fG6J22MhPko2Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ch5iyr+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ch5iyr+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7981F00893;
	Thu, 17 Sep 2026 21:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679430;
	bh=95pY7EBQYDrjoBNYDdiCMJT7Y+GW+6xQPe1foVnZ4GM=;
	h=Date:To:From:Subject;
	b=Ch5iyr+pp4prhHT5XL0mMY4IhMEGKkeRQvfP2ruXqwFdnKabA6Ks118VtGWbwYunj
	 pCAPcBH0Qz08CWBnsoz2XzaBLR2d7M3syz9yk3nSJH0wFRpnNY1OM5B/+oKTQFfi2g
	 VUqdTIb9FfhDZhJPBkiI5prkq23bGvSIqxEugprE=
Date: Thu, 17 Sep 2026 14:10:30 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch removed from -mm tree
Message-Id: <20260917211030.9D7981F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb explicitly tested
has been removed from the -mm tree.  Its filename was
     mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb explicitly tested
Date: Mon, 14 Sep 2026 15:57:54 +0100

It is now an invariant that VMA_IO_BIT is not set except by kernel-owned
mappings, so each existing VMA_SPECIAL_FLAGS test need only test for
VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.

This is precisely a test for a kernel-owned or fixed mapping.

Update a number of callsites which already explicitly handle hugetlb
mappings.

vma_supports_mlock() and ksm_compatible() also explicitly bail on
droppable mappings - detecting kernel-owned, fixed or droppable mappings
is handled by vma_is_persistent(), so in these cases use this predicate.

should_skip_vma() tests for locked, kernel-owned or fixed memory (having
already excluded hugetlb mappings) so simply test for those there.

No functional change intended.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-34-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 +---
 mm/ksm.c      |    4 +---
 mm/vmscan.c   |    3 ++-
 3 files changed, 4 insertions(+), 7 deletions(-)

--- a/mm/internal.h~mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested
+++ a/mm/internal.h
@@ -1111,9 +1111,7 @@ static inline struct file *maybe_unlock_
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {
-	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
-		return false;
-	if (vma_test_single_mask(vma, VMA_DROPPABLE))
+	if (!vma_is_persistent(vma))
 		return false;
 	if (vma_is_dax(vma) || vma_is_hugetlb(vma))
 		return false;
--- a/mm/ksm.c~mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested
+++ a/mm/ksm.c
@@ -747,9 +747,7 @@ static bool ksm_compatible(const struct
 	if (vma_flags_test_any(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT,
 			       VMA_HUGETLB_BIT))
 		return false;
-	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
-		return false;
-	if (vma_flags_test_any_mask(&vma_flags, VMA_SPECIAL_FLAGS))
+	if (!vma_flags_is_persistent(&vma_flags))
 		return false;
 	if (file_is_dax(file))
 		return false;
--- a/mm/vmscan.c~mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested
+++ a/mm/vmscan.c
@@ -3481,7 +3481,8 @@ static int should_skip_vma(unsigned long
 	if (!vma_has_recency(vma))
 		return true;
 
-	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
+	if (vma_test(vma, VMA_LOCKED_BIT) || vma_is_kernel_owned(vma) ||
+	    vma_is_fixed_mapping(vma))
 		return true;
 
 	if (vma == get_gate_vma(vma->vm_mm))
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
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

