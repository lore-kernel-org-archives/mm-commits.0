Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832279;
	b=L5HdJzdEsJT0eA3pcJDCOzmSUXFo7/bYISK7vSKrpAi57aBStZoGSXbo9ZG7hXZMYL3A
	 5U2Ai3RXBsKs9OQlVd/okaSMJnTUaIDdJ/rKFGVWMVp7IlCl32l7DNGvkjZ3td0cLK+Ln
	 XQrOls6cZRgezzdoxXd34FxpM2mAOxnW730RShMFyQGWqHZoar0Po0gfxQ/iijMuW74dz
	 /0onRlzPCYy/O2GqOkpO0KYG/Y/TykRYc3WLsmRUyQT/o8GF9b/PBse1c9uCwv3uo5s0z
	 MWyrxoDX86eyt00jXcJNx0XzI8JgLhRU/ky3BAcE/tag022X2nDM+DIuF9Ddaa8DR/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832279;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bXBCF2zRF1hfOHtjKLsA77yKnSAhoz7tAz/lAS5iBZw=;
	b=EDnKBipPXnjKOba/kYDirLjEmaWBBp1Eat+EkZqvpG9OziYvDh/e2a8JxQLx8U5bVWYj
	 C6PpKsX51C887iyqTCym2sjv07jRIsc2PGv4ph6lCvbOghgKstZeYRw511liv41g3lVK6
	 frM+sYXtHp8ugCT/NKB0NoXeWpycwIS8ige+tzLvltSPC51Z8JasBikpSFlhglZr6zoRD
	 1lpywkqV/e9t0GxvR8AtQ+QsDbWow5hXapjO6AqGJaeCTSHyODlHaxRCyM6wZUUqXn41t
	 DJf9zmEVeUXpOuCdXRU2JXdbnYgB3jh7BlnvxRwK47mLoyFDbCunfzN7soKUPjqsXUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KFmhfVRw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FE7606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KFmhfVRw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14C91F01825;
	Sat, 24 Oct 2026 08:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832279;
	bh=bXBCF2zRF1hfOHtjKLsA77yKnSAhoz7tAz/lAS5iBZw=;
	h=Date:To:From:Subject;
	b=KFmhfVRw/UmM3MkPdSrafszpDCpKK/q1dG/R5A1lYNDX8cmiETmsNu7lZ9i5dzGOy
	 mQEkEpcC4CyuK5Yy7z4nSEYXWMi/jXgH/2nhQmyPgKK3LBR/Dq6sXefeGxlAWDMVzg
	 HEoOXD1AC+16zx1ybytNexd0+ZkKCS4yQE8cqxtk=
Date: Sat, 24 Oct 2026 01:57:58 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,ljs@kernel.org,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-move-__check_safe_pte_update.patch removed from -mm tree
Message-Id: <20261024085758.F14C91F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: arm64/mm: move __check_safe_pte_update()
has been removed from the -mm tree.  Its filename was
     arm64-mm-move-__check_safe_pte_update.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: arm64/mm: move __check_safe_pte_update()
Date: Wed, 16 Sep 2026 10:19:32 +0530

Patch series "arm64/mm: Standardize printing for pgtable entries", v3.

Standardize printing for pgtable entries using recently introduced generic
helper ptval_bytes_to_hex_str() in core MM which automatically enables 128
bits entries when added later.

But first move __check_safe_pte_update() outside <asm/pgtable.h> to avoid
a cyclic dependency while accessing these afore mentioned core MM helpers
defined in <linux/pgtable.h>.  This replaces the original page table entry
print standardisation proposal which was part of the D128 series [1].


This patch (of 2):

The page table entry print helpers and related macros which are defined in
<linux/pgtable.h> will not be accessible in platform <asm/pgtable.h> which
is basically caused by cycling dependency.

Move __check_safe_pte_update() inside arch/arm64/mm/mmu.c as a preparation
for subsequent usage of the afore mentioned generic MM helpers.  While
here drop IS_ENABLED(CONFIG_DEBUG_VM), although wrap
__check_safe_pte_update() inside #ifdef CONFIG_DEBUG_VM that preserves the
current code optimization which is achieved via the static inline
functions.

This does not cause any functional change.

[david@kernel.org: aarch64-linux-ld error]
  Link: https://lore.kernel.org/99023678-fd8a-4eef-8e43-a07b504e3e96@kernel.org
Link: https://lore.kernel.org/20260916044933.2689426-2-anshuman.khandual@arm.com
Link: https://lore.kernel.org/linux-mm/20260729122452.3797443-11-anshuman.khandual@arm.com/ [1]
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
---

 arch/arm64/include/asm/pgtable.h |   49 ++---------------------------
 arch/arm64/mm/mmu.c              |   44 ++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 44 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-move-__check_safe_pte_update
+++ a/arch/arm64/include/asm/pgtable.h
@@ -387,52 +387,13 @@ static inline pte_t __ptep_get(pte_t *pt
 extern void __sync_icache_dcache(pte_t pteval);
 bool pgattr_change_is_safe(pteval_t old, pteval_t new);
 
-/*
- * PTE bits configuration in the presence of hardware Dirty Bit Management
- * (PTE_WRITE == PTE_DBM):
- *
- * Dirty  Writable | PTE_RDONLY  PTE_WRITE  PTE_DIRTY (sw)
- *   0      0      |   1           0          0
- *   0      1      |   1           1          0
- *   1      0      |   1           0          1
- *   1      1      |   0           1          x
- *
- * When hardware DBM is not present, the software PTE_DIRTY bit is updated via
- * the page fault mechanism. Checking the dirty status of a pte becomes:
- *
- *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
- */
-
-static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
-					   pte_t pte)
+#ifdef CONFIG_DEBUG_VM
+void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte);
+#else
+static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 {
-	pte_t old_pte;
-
-	if (!IS_ENABLED(CONFIG_DEBUG_VM))
-		return;
-
-	old_pte = __ptep_get(ptep);
-
-	if (!pte_valid(old_pte) || !pte_valid(pte))
-		return;
-	if (mm != current->active_mm && atomic_read(&mm->mm_users) <= 1)
-		return;
-
-	/*
-	 * Check for potential race with hardware updates of the pte
-	 * (__ptep_set_access_flags safely changes valid ptes without going
-	 * through an invalid entry).
-	 */
-	VM_WARN_ONCE(!pte_young(pte),
-		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
-	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
-		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
-	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
-		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
 }
+#endif /* CONFIG_DEBUG_VM */
 
 static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
 {
--- a/arch/arm64/mm/mmu.c~arm64-mm-move-__check_safe_pte_update
+++ a/arch/arm64/mm/mmu.c
@@ -2393,3 +2393,47 @@ int arch_set_user_pkey_access(int pkey,
 	return 0;
 }
 #endif
+
+/*
+ * PTE bits configuration in the presence of hardware Dirty Bit Management
+ * (PTE_WRITE == PTE_DBM):
+ *
+ * Dirty  Writable | PTE_RDONLY  PTE_WRITE  PTE_DIRTY (sw)
+ *   0      0      |   1           0          0
+ *   0      1      |   1           1          0
+ *   1      0      |   1           0          1
+ *   1      1      |   0           1          x
+ *
+ * When hardware DBM is not present, the software PTE_DIRTY bit is updated via
+ * the page fault mechanism. Checking the dirty status of a pte becomes:
+ *
+ *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
+ */
+#ifdef CONFIG_DEBUG_VM
+void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
+{
+	pte_t old_pte;
+
+	old_pte = __ptep_get(ptep);
+
+	if (!pte_valid(old_pte) || !pte_valid(pte))
+		return;
+	if (mm != current->active_mm && atomic_read(&mm->mm_users) <= 1)
+		return;
+
+	/*
+	 * Check for potential race with hardware updates of the pte
+	 * (__ptep_set_access_flags safely changes valid ptes without going
+	 * through an invalid entry).
+	 */
+	VM_WARN_ONCE(!pte_young(pte),
+		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
+		     __func__, pte_val(old_pte), pte_val(pte));
+	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
+		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
+		     __func__, pte_val(old_pte), pte_val(pte));
+	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
+		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
+		     __func__, pte_val(old_pte), pte_val(pte));
+}
+#endif /* CONFIG_DEBUG_VM */
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


