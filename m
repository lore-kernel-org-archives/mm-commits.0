Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06CC4437A
	for <mm-commits@vger.kernel.org>; Thu,  3 Oct 2024 16:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727974537; cv=none; b=Knvnc6jThiJxvTz17TfdpMdhYG4aoH9FUEFJvkE5ZIScS3VEy4rkVpmLFu6LOO4a6C801ec+Khmns4PQmWrWbWJ2Eu3XBG3axD1nt7OTUovUzB+q8Ti4MjmGkT49GfUE0boE/8uKXE2Ihh+icu+VkRd6JGCMqOucJXYBUfn+FrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727974537; c=relaxed/simple;
	bh=uSUXcSqWFmda/tAQGqZ+wY2dQt9ebUZXbmko3On+rMU=;
	h=Date:To:From:Subject:Message-Id; b=Px5bzPLpXMOnNWvgbdhDu8IqRCeP6D3jB0uB8oAhqEkSsip7LWQp5ab5sG9gx2HCSL2okni0DLnC2gjcgBlCZWM5OZzQ6E/YelnCwRuYz7i223Fo99CCemz/tLqet1Su5w0klaHjI1cepiAKjhUf2efaA8srRyMq4HgOsM+9Dxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hb/hpvvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hb/hpvvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F19C4CEC5;
	Thu,  3 Oct 2024 16:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727974536;
	bh=uSUXcSqWFmda/tAQGqZ+wY2dQt9ebUZXbmko3On+rMU=;
	h=Date:To:From:Subject:From;
	b=Hb/hpvvXxF7Q0E81xM42PxFqxmns/0kD+eJX4l6mIb+G3rZpPYtKF6AC56Igbwux1
	 CtOooEVNpCakJqK6b7QLx77l2ukj5TJkmnMEpcP9GHjhhH4LkCH4WHbG2KrWkZHajC
	 6bOkhj3YR969pQ2vxmy3sZKlj87a9rGSeqoJNKMM=
Date: Thu, 03 Oct 2024 09:55:35 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,david@redhat.com,dave.hansen@linux.intel.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-set_pxd_safe-helpers-from-generic-to-platform.patch added to mm-unstable branch
Message-Id: <20241003165536.34F19C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move set_pxd_safe() helpers from generic to platform
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-set_pxd_safe-helpers-from-generic-to-platform.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-set_pxd_safe-helpers-from-generic-to-platform.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: move set_pxd_safe() helpers from generic to platform
Date: Thu, 3 Oct 2024 10:18:42 +0530

set_pxd_safe() helpers that serve a specific purpose for both x86 and
riscv platforms, do not need to be in the common memory code.  Otherwise
they just unnecessarily make the common API more complicated.  This moves
the helpers from common code to platform instead.

Link: https://lkml.kernel.org/r/20241003044842.246016-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h |   19 ++++++++++++++
 arch/x86/include/asm/pgtable.h   |   37 ++++++++++++++++++++++++++++
 include/linux/pgtable.h          |   38 -----------------------------
 3 files changed, 56 insertions(+), 38 deletions(-)

--- a/arch/riscv/include/asm/pgtable.h~mm-move-set_pxd_safe-helpers-from-generic-to-platform
+++ a/arch/riscv/include/asm/pgtable.h
@@ -963,6 +963,25 @@ void misc_mem_init(void);
 extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 
+/*
+ * Use set_p*_safe(), and elide TLB flushing, when confident that *no*
+ * TLB flush will be required as a result of the "set". For example, use
+ * in scenarios where it is known ahead of time that the routine is
+ * setting non-present entries, or re-setting an existing entry to the
+ * same value. Otherwise, use the typical "set" helpers and flush the
+ * TLB.
+ */
+#define set_p4d_safe(p4dp, p4d) \
+({ \
+	WARN_ON_ONCE(p4d_present(*p4dp) && !p4d_same(*p4dp, p4d)); \
+	set_p4d(p4dp, p4d); \
+})
+
+#define set_pgd_safe(pgdp, pgd) \
+({ \
+	WARN_ON_ONCE(pgd_present(*pgdp) && !pgd_same(*pgdp, pgd)); \
+	set_pgd(pgdp, pgd); \
+})
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_RISCV_PGTABLE_H */
--- a/arch/x86/include/asm/pgtable.h~mm-move-set_pxd_safe-helpers-from-generic-to-platform
+++ a/arch/x86/include/asm/pgtable.h
@@ -1775,6 +1775,43 @@ bool arch_is_platform_page(u64 paddr);
 #define arch_is_platform_page arch_is_platform_page
 #endif
 
+/*
+ * Use set_p*_safe(), and elide TLB flushing, when confident that *no*
+ * TLB flush will be required as a result of the "set". For example, use
+ * in scenarios where it is known ahead of time that the routine is
+ * setting non-present entries, or re-setting an existing entry to the
+ * same value. Otherwise, use the typical "set" helpers and flush the
+ * TLB.
+ */
+#define set_pte_safe(ptep, pte) \
+({ \
+	WARN_ON_ONCE(pte_present(*ptep) && !pte_same(*ptep, pte)); \
+	set_pte(ptep, pte); \
+})
+
+#define set_pmd_safe(pmdp, pmd) \
+({ \
+	WARN_ON_ONCE(pmd_present(*pmdp) && !pmd_same(*pmdp, pmd)); \
+	set_pmd(pmdp, pmd); \
+})
+
+#define set_pud_safe(pudp, pud) \
+({ \
+	WARN_ON_ONCE(pud_present(*pudp) && !pud_same(*pudp, pud)); \
+	set_pud(pudp, pud); \
+})
+
+#define set_p4d_safe(p4dp, p4d) \
+({ \
+	WARN_ON_ONCE(p4d_present(*p4dp) && !p4d_same(*p4dp, p4d)); \
+	set_p4d(p4dp, p4d); \
+})
+
+#define set_pgd_safe(pgdp, pgd) \
+({ \
+	WARN_ON_ONCE(pgd_present(*pgdp) && !pgd_same(*pgdp, pgd)); \
+	set_pgd(pgdp, pgd); \
+})
 #endif	/* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_H */
--- a/include/linux/pgtable.h~mm-move-set_pxd_safe-helpers-from-generic-to-platform
+++ a/include/linux/pgtable.h
@@ -1056,44 +1056,6 @@ static inline int pgd_same(pgd_t pgd_a,
 }
 #endif
 
-/*
- * Use set_p*_safe(), and elide TLB flushing, when confident that *no*
- * TLB flush will be required as a result of the "set". For example, use
- * in scenarios where it is known ahead of time that the routine is
- * setting non-present entries, or re-setting an existing entry to the
- * same value. Otherwise, use the typical "set" helpers and flush the
- * TLB.
- */
-#define set_pte_safe(ptep, pte) \
-({ \
-	WARN_ON_ONCE(pte_present(*ptep) && !pte_same(*ptep, pte)); \
-	set_pte(ptep, pte); \
-})
-
-#define set_pmd_safe(pmdp, pmd) \
-({ \
-	WARN_ON_ONCE(pmd_present(*pmdp) && !pmd_same(*pmdp, pmd)); \
-	set_pmd(pmdp, pmd); \
-})
-
-#define set_pud_safe(pudp, pud) \
-({ \
-	WARN_ON_ONCE(pud_present(*pudp) && !pud_same(*pudp, pud)); \
-	set_pud(pudp, pud); \
-})
-
-#define set_p4d_safe(p4dp, p4d) \
-({ \
-	WARN_ON_ONCE(p4d_present(*p4dp) && !p4d_same(*p4dp, p4d)); \
-	set_p4d(p4dp, p4d); \
-})
-
-#define set_pgd_safe(pgdp, pgd) \
-({ \
-	WARN_ON_ONCE(pgd_present(*pgdp) && !pgd_same(*pgdp, pgd)); \
-	set_pgd(pgdp, pgd); \
-})
-
 #ifndef __HAVE_ARCH_DO_SWAP_PAGE
 static inline void arch_do_swap_page_nr(struct mm_struct *mm,
 				     struct vm_area_struct *vma,
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-move-set_pxd_safe-helpers-from-generic-to-platform.patch

