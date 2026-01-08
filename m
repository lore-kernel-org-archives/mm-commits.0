Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74404329C49
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 19:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767899988; cv=none; b=aGBLyhDLeNoPVkvFdN/fpqdxLmVSCvS9x/ZA9Td0Pq/lq6PgWL3USAZPkkpvWsoJMRrhVORndDGULy1eOSlB+KoU9DDJoGafmB9Uu+OwdC+JBqO+1SCJXGDtldL3/Fg6NnJ7RTregeqRJ+DpKAt0f5K6mJgJvmedXvKUbZ2NoGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767899988; c=relaxed/simple;
	bh=x+IqH6rxkY/I3zEjZOzFsgzT4xOJ1BJJ1AQ4FKcQkio=;
	h=Date:To:From:Subject:Message-Id; b=gG2adsG6ZcGVSgENmhctU5zBqN8FkWHF/dbIq5Z/BfK1W8QRlTP4aADSchzD2I0rYNRnAuNWMJT9hZzFrctYDWqTYHsZmrOKPon+Uat4+xXWAtPgWg6fBakYF+C/GzrtXGxsgGulL9acuJ1OX8g9jhb3fGGGzLMvlO/SpQvU2pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ocH/c3VJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ocH/c3VJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9936C116D0;
	Thu,  8 Jan 2026 19:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767899987;
	bh=x+IqH6rxkY/I3zEjZOzFsgzT4xOJ1BJJ1AQ4FKcQkio=;
	h=Date:To:From:Subject:From;
	b=ocH/c3VJ5GJ8aSR0ug72G//O213aquVGAJLNU131fHMexuE343FEtC7KweBPhy7gN
	 Tsan+LW0k7FCzZXjjhQY/frwh4OfSrNr8P/S4zxQ1evmHYZvHT7cuzVC9AU4DrhYjh
	 rVF/epm/O6CKzrv9LdwtqMBZfXi4Eor+z1buAYiM=
Date: Thu, 08 Jan 2026 11:19:47 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,linux@armlinux.org.uk,catalin.marinas@arm.com,klarasmodin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-make-initialization-of-zero-page-independent-of-the-memory-map.patch added to mm-unstable branch
Message-Id: <20260108191947.D9936C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Date: Sat, 3 Jan 2026 20:40:09 +0200
has been added to the -mm mm-unstable branch.  Its filename is
     arm-make-initialization-of-zero-page-independent-of-the-memory-map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-make-initialization-of-zero-page-independent-of-the-memory-map.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Klara Modin <klarasmodin@gmail.com>
Date: Sat, 3 Jan 2026 20:40:09 +0200
Subject: arm: make initialization of zero page independent of the memory map

Unlike most architectures, arm keeps a struct page pointer to the
empty_zero_page and to initialize it requires conversion of a virtual
address to page which makes it necessary to have memory map initialized
before creating the empty_zero_page.

Make empty_zero_page a stataic array in BSS to decouple it's
initialization from the initialization of the memory map.

This also aligns arm with vast majority of architectures.

Link: https://lkml.kernel.org/r/aVpWpLV4Dut5Muo2@kernel.org
Signed-off-by: Klara Modin <klarasmodin@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable.h |    4 ++--
 arch/arm/mm/mmu.c              |   10 +---------
 arch/arm/mm/nommu.c            |   10 +---------
 3 files changed, 4 insertions(+), 20 deletions(-)

--- a/arch/arm/include/asm/pgtable.h~arm-make-initialization-of-zero-page-independent-of-the-memory-map
+++ a/arch/arm/include/asm/pgtable.h
@@ -15,8 +15,8 @@
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
  */
-extern struct page *empty_zero_page;
-#define ZERO_PAGE(vaddr)	(empty_zero_page)
+extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
+#define ZERO_PAGE(vaddr)	(virt_to_page(empty_zero_page))
 #endif
 
 #include <asm-generic/pgtable-nopud.h>
--- a/arch/arm/mm/mmu.c~arm-make-initialization-of-zero-page-independent-of-the-memory-map
+++ a/arch/arm/mm/mmu.c
@@ -45,7 +45,7 @@ extern unsigned long __atags_pointer;
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
  */
-struct page *empty_zero_page;
+unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)] __page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
 
 /*
@@ -1754,8 +1754,6 @@ static void __init early_fixmap_shutdown
  */
 void __init paging_init(const struct machine_desc *mdesc)
 {
-	void *zero_page;
-
 #ifdef CONFIG_XIP_KERNEL
 	/* Store the kernel RW RAM region start/end in these variables */
 	kernel_sec_start = CONFIG_PHYS_OFFSET & SECTION_MASK;
@@ -1781,13 +1779,7 @@ void __init paging_init(const struct mac
 
 	top_pmd = pmd_off_k(0xffff0000);
 
-	/* allocate the zero page. */
-	zero_page = early_alloc(PAGE_SIZE);
-
 	bootmem_init();
-
-	empty_zero_page = virt_to_page(zero_page);
-	__flush_dcache_folio(NULL, page_folio(empty_zero_page));
 }
 
 void __init early_mm_init(const struct machine_desc *mdesc)
--- a/arch/arm/mm/nommu.c~arm-make-initialization-of-zero-page-independent-of-the-memory-map
+++ a/arch/arm/mm/nommu.c
@@ -31,7 +31,7 @@ unsigned long vectors_base;
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
  */
-struct page *empty_zero_page;
+unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)] __page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
 
 #ifdef CONFIG_ARM_MPU
@@ -156,18 +156,10 @@ void __init adjust_lowmem_bounds(void)
  */
 void __init paging_init(const struct machine_desc *mdesc)
 {
-	void *zero_page;
-
 	early_trap_init((void *)vectors_base);
 	mpu_setup();
 
-	/* allocate the zero page. */
-	zero_page = (void *)memblock_alloc_or_panic(PAGE_SIZE, PAGE_SIZE);
-
 	bootmem_init();
-
-	empty_zero_page = virt_to_page(zero_page);
-	flush_dcache_page(empty_zero_page);
 }
 
 /*
_

Patches currently in -mm which might be from klarasmodin@gmail.com are

arm-make-initialization-of-zero-page-independent-of-the-memory-map.patch

