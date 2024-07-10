Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53376848E
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 17:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633729; cv=none; b=hUnnRuAUkQDNAWsdBQXDsmY8rVD2BNjH+XB/MUS4sDOtTEcBiK4UzzzUXvfi4TDu/U2ZwUOpkh/GjPyKPxZk6Lo7TcOVlCgyLGgLCTc3wX/dsL1jOpQMFYzHNqQMbZ45QmKnohWg7BveLv1bal8TfK1mAuIR1ZhqRj0UnnRcRIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633729; c=relaxed/simple;
	bh=aoA2qZUGQlo0IuAMIqaoLfC/6NzwnqRa8PuMYwBZxMc=;
	h=Date:To:From:Subject:Message-Id; b=Gjf3UEnnmxrkj5ggz+idh8B+up0REj0KWt7cgGmRv+Aby4tEQ/yhyHO5x/N9ebmtUrTvW3tAWiyfqb3FZPk0I3IlIcqmrZwQqbcV2EducnwS3x5w/zP2Bv1wZS57dW2Gv8S2qIcPcC9+huKTVBDfrdRkRCayURhUQ8TEF4okhXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L8hKk7gX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L8hKk7gX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0639C32781;
	Wed, 10 Jul 2024 17:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720633728;
	bh=aoA2qZUGQlo0IuAMIqaoLfC/6NzwnqRa8PuMYwBZxMc=;
	h=Date:To:From:Subject:From;
	b=L8hKk7gX+b16kUXDe/Dlnf4QAVRU55xS6JBUuPmmkzIJVc7d163/+E3zdGb26Z36H
	 v9UYypayGQT3llzPxC0yrfeVm2hz4ZLYcLfc/2a2iu7HkqW3vG4RtCuDTXSmSn8da1
	 noD8EF2P8GOUPvSIIFUhlC1ANC3UXVwqoVLLo1uo=
Date: Wed, 10 Jul 2024 10:48:48 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterx@redhat.com,osalvador@suse.de,mingo@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,arnd@arndb.de,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pg-4d_leaf-in-asm-generic-pgtable-nop4-udh.patch added to mm-unstable branch
Message-Id: <20240710174848.A0639C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add p{g/4}d_leaf() in asm-generic/pgtable-nop{4/u}d.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pg-4d_leaf-in-asm-generic-pgtable-nop4-udh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pg-4d_leaf-in-asm-generic-pgtable-nop4-udh.patch

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
Subject: mm: add p{g/4}d_leaf() in asm-generic/pgtable-nop{4/u}d.h
Date: Wed, 10 Jul 2024 09:51:22 +0200

Commit 2c8a81dc0cc5 ("riscv/mm: fix two page table check related issues")
added pud_leaf() in include/asm-generic/pgtable-nopmd.h

Do the same for p4d_leaf() and pgd_leaf() to avoid getting them
erroneously defined by architectures that do not implement the related
page level.

Link: https://lkml.kernel.org/r/f69941b076bf8fec89b6bec5573fdb79483c2a75.1720597744.git.christophe.leroy@csgroup.eu
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

 include/asm-generic/pgtable-nop4d.h |    2 ++
 include/asm-generic/pgtable-nopmd.h |    1 +
 include/asm-generic/pgtable-nopud.h |    2 ++
 3 files changed, 5 insertions(+)

--- a/include/asm-generic/pgtable-nop4d.h~mm-add-pg-4d_leaf-in-asm-generic-pgtable-nop4-udh
+++ a/include/asm-generic/pgtable-nop4d.h
@@ -21,6 +21,8 @@ typedef struct { pgd_t pgd; } p4d_t;
 static inline int pgd_none(pgd_t pgd)		{ return 0; }
 static inline int pgd_bad(pgd_t pgd)		{ return 0; }
 static inline int pgd_present(pgd_t pgd)	{ return 1; }
+static inline int pgd_leaf(pgd_t pgd)		{ return 0; }
+#define pgd_leaf pgd_leaf
 static inline void pgd_clear(pgd_t *pgd)	{ }
 #define p4d_ERROR(p4d)				(pgd_ERROR((p4d).pgd))
 
--- a/include/asm-generic/pgtable-nopmd.h~mm-add-pg-4d_leaf-in-asm-generic-pgtable-nop4-udh
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -31,6 +31,7 @@ static inline int pud_none(pud_t pud)		{
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
 static inline int pud_leaf(pud_t pud)		{ return 0; }
+#define pud_leaf pud_leaf
 static inline void pud_clear(pud_t *pud)	{ }
 #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
 
--- a/include/asm-generic/pgtable-nopud.h~mm-add-pg-4d_leaf-in-asm-generic-pgtable-nop4-udh
+++ a/include/asm-generic/pgtable-nopud.h
@@ -28,6 +28,8 @@ typedef struct { p4d_t p4d; } pud_t;
 static inline int p4d_none(p4d_t p4d)		{ return 0; }
 static inline int p4d_bad(p4d_t p4d)		{ return 0; }
 static inline int p4d_present(p4d_t p4d)	{ return 1; }
+static inline int p4d_leaf(p4d_t p4d)		{ return 0; }
+#define p4d_leaf p4d_leaf
 static inline void p4d_clear(p4d_t *p4d)	{ }
 #define pud_ERROR(pud)				(p4d_ERROR((pud).p4d))
 
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

