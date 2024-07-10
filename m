Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CB3194C79
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 17:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633726; cv=none; b=uQkxIVjff+R4KLkQrgK1RbuNFhSAD9lFlMkJ9DIOY9ATgPeo4OUzrIoalld18bsM7o+sGj1eL31vxaXfkznNqGZ80BT+E5Dw1xrQR4NIfL/R6FCr3Xvlynn6zMtTeKnwC1U1PqaH4UhiYCETrmWbGLF8M5WJLVBP3OZgmKoE13s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633726; c=relaxed/simple;
	bh=4wKum+d0HPUZcPQDTGuR4aBV3tLnaQp/nRZweznSQX8=;
	h=Date:To:From:Subject:Message-Id; b=hD2AZrIzBU0vH7+0wbdYWxNO28ouj+1pZZ56LLV0rSETf+Esqz6Y1W92Ei4f8ZaNtf4cnUHm9tf0LJTgKsmcWjVvknEGJzBdDw5Xnk/3pEi4wTBeXxOoOFYZn6qrN8eTaOJpyOSChYeDzgNqwmP0jdqG5YNN3zyKW22mk+sEjms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EyTjTt0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EyTjTt0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD45C32786;
	Wed, 10 Jul 2024 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720633726;
	bh=4wKum+d0HPUZcPQDTGuR4aBV3tLnaQp/nRZweznSQX8=;
	h=Date:To:From:Subject:From;
	b=EyTjTt0Wqdfc4viktyvqi4kuaLBn3aJo6yDHoWU2Vs1tiGDqdb/r4JoUO+KtIDfd5
	 G6E7LQIUh+IXYs3Yr6ByRGHhmoh7EPZ6oAYsutBXDRDyrFmk5Vu2R7d1Wz1COVYfyW
	 58iDeseEoz0xljWTGRS3lNgCGjQjX/gyLRfDePWQ=
Date: Wed, 10 Jul 2024 10:48:45 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterx@redhat.com,osalvador@suse.de,mingo@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,arnd@arndb.de,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pud_user-from-asm-generic-pgtable-nopmdh.patch added to mm-unstable branch
Message-Id: <20240710174846.5BD45C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove pud_user() from asm-generic/pgtable-nopmd.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pud_user-from-asm-generic-pgtable-nopmdh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pud_user-from-asm-generic-pgtable-nopmdh.patch

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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: remove pud_user() from asm-generic/pgtable-nopmd.h
Date: Wed, 10 Jul 2024 09:51:21 +0200

Commit 2c8a81dc0cc5 ("riscv/mm: fix two page table check related issues")
added pud_user() in include/asm-generic/pgtable-nopmd.h

But pud_user() only exists on ARM64 and RISCV and is not expected by any
part of MM.

Add the missing definition in arch/riscv/include/asm/pgtable-32.h and
remove it from asm-generic/pgtable-nopmd.h

Link: https://lkml.kernel.org/r/c31a39463929daba6c91917598ec05cf47103af5.1720597744.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable-32.h |    5 +++++
 include/asm-generic/pgtable-nopmd.h |    1 -
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable-32.h~mm-remove-pud_user-from-asm-generic-pgtable-nopmdh
+++ a/arch/riscv/include/asm/pgtable-32.h
@@ -36,4 +36,9 @@
 static const __maybe_unused int pgtable_l4_enabled;
 static const __maybe_unused int pgtable_l5_enabled;
 
+static inline int pud_user(pud_t pud)
+{
+	return 0;
+}
+
 #endif /* _ASM_RISCV_PGTABLE_32_H */
--- a/include/asm-generic/pgtable-nopmd.h~mm-remove-pud_user-from-asm-generic-pgtable-nopmdh
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -30,7 +30,6 @@ typedef struct { pud_t pud; } pmd_t;
 static inline int pud_none(pud_t pud)		{ return 0; }
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
-static inline int pud_user(pud_t pud)		{ return 0; }
 static inline int pud_leaf(pud_t pud)		{ return 0; }
 static inline void pud_clear(pud_t *pud)	{ }
 #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch
mm-provide-mm_struct-and-address-to-huge_ptep_get.patch
powerpc-mm-remove-_page_psize.patch
powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries.patch
powerpc-mm-allow-hugepages-without-hugepd.patch
powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch
powerpc-8xx-rework-support-for-8m-pages-using-contiguous-pte-entries.patch
powerpc-8xx-simplify-struct-mmu_psize_def.patch
powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def.patch
powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits.patch
powerpc-e500-encode-hugepage-size-in-pte-bits.patch
powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch
powerpc-e500-free-r10-for-find_pte.patch
powerpc-e500-use-contiguous-pmd-instead-of-hugepd.patch
powerpc-64s-use-contiguous-pmd-pud-instead-of-hugepd.patch
powerpc-mm-remove-hugepd-leftovers.patch
mm-remove-config_arch_has_hugepd.patch
mm-remove-pud_user-from-asm-generic-pgtable-nopmdh.patch
mm-add-pg-4d_leaf-in-asm-generic-pgtable-nop4-udh.patch

