Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7541553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011067; cv=none; b=SQqQhmml25VMaXo8i2sBlk+FzPbPB1pgian8RpHkGR7V6dDNV3Nlr4ucDAAp3g3qymmZF1ebHZdaHkDhWTiL/r3654xllU7xFbFaly5/DC2EpK2Z2GcXryOqtPwQMpHineLlh+NUoS8QtnX4oHPBJpz2PfNTh41YAJd/juom+d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011067; c=relaxed/simple;
	bh=b/xvGhI1RUf64zQNK00ZwjtkfmY7tTdI0o6bXrFAbL8=;
	h=Date:To:From:Subject:Message-Id; b=l/zs1Pkvj4oKSq1L2HCt49BMbXtaQdi5E1bAJfxIIlp3Oyt17oViptZXMfri1TLsf1KDmyBqqS4A4vSHUiu/XhjNpWXHTMQJnEOMrLrU4h95aI/xKNFhRqbeQvid61khajsJrC8/dhFYIczUkE6B5N1ff7Ync5hLZxxtVsJdjrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ptQQI3O2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ptQQI3O2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E11C4CEE4;
	Mon, 12 May 2025 00:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011067;
	bh=b/xvGhI1RUf64zQNK00ZwjtkfmY7tTdI0o6bXrFAbL8=;
	h=Date:To:From:Subject:From;
	b=ptQQI3O2t0k1RPumu2mOPzqVKQzqhxX3VjfcR1dtJthIPhT1OZ/24ypfRjYtl7xhM
	 YK9Shew0Av4XRX0sUY7s4qFv/02JHYueEzxuuVuL5NhmLza4gtXfcgwML5GEwn30Vi
	 cxIXWWBYJHxBKVRXz9X++CQxNNvQXeReQkvVthXo=
Date: Sun, 11 May 2025 17:51:06 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mingo@redhat.com,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-define-ptdesc_t.patch removed from -mm tree
Message-Id: <20250512005107.20E11C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: define ptdesc_t
has been removed from the -mm tree.  Its filename was
     arm64-mm-define-ptdesc_t.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: arm64/mm: define ptdesc_t
Date: Mon, 7 Apr 2025 11:01:13 +0530

Define ptdesc_t type which describes the basic page table descriptor
layout on arm64 platform.  Subsequently all level specific pxxval_t
descriptors are derived from ptdesc_t thus establishing a common original
format, which can also be appropriate for page table entries, masks and
protection values etc which are used at all page table levels.

Link: https://lkml.kernel.org/r/20250407053113.746295-4-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable-types.h |   20 ++++++++++++++------
 arch/arm64/include/asm/ptdump.h        |    8 ++++----
 arch/arm64/kernel/efi.c                |    4 ++--
 arch/arm64/kernel/pi/map_kernel.c      |    2 +-
 arch/arm64/kernel/pi/map_range.c       |    4 ++--
 arch/arm64/kernel/pi/pi.h              |    2 +-
 arch/arm64/mm/mmap.c                   |    2 +-
 arch/arm64/mm/ptdump.c                 |    2 +-
 8 files changed, 26 insertions(+), 18 deletions(-)

--- a/arch/arm64/include/asm/pgtable-types.h~arm64-mm-define-ptdesc_t
+++ a/arch/arm64/include/asm/pgtable-types.h
@@ -11,11 +11,19 @@
 
 #include <asm/types.h>
 
-typedef u64 pteval_t;
-typedef u64 pmdval_t;
-typedef u64 pudval_t;
-typedef u64 p4dval_t;
-typedef u64 pgdval_t;
+/*
+ * Page Table Descriptor
+ *
+ * Generic page table descriptor format from which
+ * all level specific descriptors can be derived.
+ */
+typedef u64 ptdesc_t;
+
+typedef ptdesc_t pteval_t;
+typedef ptdesc_t pmdval_t;
+typedef ptdesc_t pudval_t;
+typedef ptdesc_t p4dval_t;
+typedef ptdesc_t pgdval_t;
 
 /*
  * These are used to make use of C type-checking..
@@ -46,7 +54,7 @@ typedef struct { pgdval_t pgd; } pgd_t;
 #define pgd_val(x)	((x).pgd)
 #define __pgd(x)	((pgd_t) { (x) } )
 
-typedef struct { pteval_t pgprot; } pgprot_t;
+typedef struct { ptdesc_t pgprot; } pgprot_t;
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
--- a/arch/arm64/include/asm/ptdump.h~arm64-mm-define-ptdesc_t
+++ a/arch/arm64/include/asm/ptdump.h
@@ -24,8 +24,8 @@ struct ptdump_info {
 };
 
 struct ptdump_prot_bits {
-	u64		mask;
-	u64		val;
+	ptdesc_t	mask;
+	ptdesc_t	val;
 	const char	*set;
 	const char	*clear;
 };
@@ -34,7 +34,7 @@ struct ptdump_pg_level {
 	const struct ptdump_prot_bits *bits;
 	char name[4];
 	int num;
-	u64 mask;
+	ptdesc_t mask;
 };
 
 /*
@@ -51,7 +51,7 @@ struct ptdump_pg_state {
 	const struct mm_struct *mm;
 	unsigned long start_address;
 	int level;
-	u64 current_prot;
+	ptdesc_t current_prot;
 	bool check_wx;
 	unsigned long wx_pages;
 	unsigned long uxn_pages;
--- a/arch/arm64/kernel/efi.c~arm64-mm-define-ptdesc_t
+++ a/arch/arm64/kernel/efi.c
@@ -29,7 +29,7 @@ static bool region_is_misaligned(const e
  * executable, everything else can be mapped with the XN bits
  * set. Also take the new (optional) RO/XP bits into account.
  */
-static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
+static __init ptdesc_t create_mapping_protection(efi_memory_desc_t *md)
 {
 	u64 attr = md->attribute;
 	u32 type = md->type;
@@ -83,7 +83,7 @@ static __init pteval_t create_mapping_pr
 
 int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 {
-	pteval_t prot_val = create_mapping_protection(md);
+	ptdesc_t prot_val = create_mapping_protection(md);
 	bool page_mappings_only = (md->type == EFI_RUNTIME_SERVICES_CODE ||
 				   md->type == EFI_RUNTIME_SERVICES_DATA);
 
--- a/arch/arm64/kernel/pi/map_kernel.c~arm64-mm-define-ptdesc_t
+++ a/arch/arm64/kernel/pi/map_kernel.c
@@ -159,7 +159,7 @@ static void noinline __section(".idmap.t
 static void __init remap_idmap_for_lpa2(void)
 {
 	/* clear the bits that change meaning once LPA2 is turned on */
-	pteval_t mask = PTE_SHARED;
+	ptdesc_t mask = PTE_SHARED;
 
 	/*
 	 * We have to clear bits [9:8] in all block or page descriptors in the
--- a/arch/arm64/kernel/pi/map_range.c~arm64-mm-define-ptdesc_t
+++ a/arch/arm64/kernel/pi/map_range.c
@@ -30,7 +30,7 @@ void __init map_range(u64 *pte, u64 star
 		      int level, pte_t *tbl, bool may_use_cont, u64 va_offset)
 {
 	u64 cmask = (level == 3) ? CONT_PTE_SIZE - 1 : U64_MAX;
-	pteval_t protval = pgprot_val(prot) & ~PTE_TYPE_MASK;
+	ptdesc_t protval = pgprot_val(prot) & ~PTE_TYPE_MASK;
 	int lshift = (3 - level) * PTDESC_TABLE_SHIFT;
 	u64 lmask = (PAGE_SIZE << lshift) - 1;
 
@@ -87,7 +87,7 @@ void __init map_range(u64 *pte, u64 star
 	}
 }
 
-asmlinkage u64 __init create_init_idmap(pgd_t *pg_dir, pteval_t clrmask)
+asmlinkage u64 __init create_init_idmap(pgd_t *pg_dir, ptdesc_t clrmask)
 {
 	u64 ptep = (u64)pg_dir + PAGE_SIZE;
 	pgprot_t text_prot = PAGE_KERNEL_ROX;
--- a/arch/arm64/kernel/pi/pi.h~arm64-mm-define-ptdesc_t
+++ a/arch/arm64/kernel/pi/pi.h
@@ -33,4 +33,4 @@ void map_range(u64 *pgd, u64 start, u64
 
 asmlinkage void early_map_kernel(u64 boot_status, void *fdt);
 
-asmlinkage u64 create_init_idmap(pgd_t *pgd, pteval_t clrmask);
+asmlinkage u64 create_init_idmap(pgd_t *pgd, ptdesc_t clrmask);
--- a/arch/arm64/mm/mmap.c~arm64-mm-define-ptdesc_t
+++ a/arch/arm64/mm/mmap.c
@@ -83,7 +83,7 @@ arch_initcall(adjust_protection_map);
 
 pgprot_t vm_get_page_prot(unsigned long vm_flags)
 {
-	pteval_t prot;
+	ptdesc_t prot;
 
 	/* Short circuit GCS to avoid bloating the table. */
 	if (system_supports_gcs() && (vm_flags & VM_SHADOW_STACK)) {
--- a/arch/arm64/mm/ptdump.c~arm64-mm-define-ptdesc_t
+++ a/arch/arm64/mm/ptdump.c
@@ -194,7 +194,7 @@ void note_page(struct ptdump_state *pt_s
 	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
 	struct ptdump_pg_level *pg_level = st->pg_level;
 	static const char units[] = "KMGTPE";
-	u64 prot = 0;
+	ptdesc_t prot = 0;
 
 	/* check if the current level has been folded dynamically */
 	if (st->mm && ((level == 1 && mm_p4d_folded(st->mm)) ||
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


