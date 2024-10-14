Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CA81D0797
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 20:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728936762; cv=none; b=Pwl3YJlUyXTiGvxPeUSJwwKj63SNyOjcJ620yFv2x1XGj+/tK54QRbJwAVoEXqrgLxRoFU38uPQRpzcL3TNV9p5jqMCRc4hic3zWvK6H1Fds3LgyONnEx58ujT9Gp7J5Nr2NWwFP/hKBjTg1Sn8YkxtJZGp4UkqTW/X8t6BSf1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728936762; c=relaxed/simple;
	bh=i/oPxkmdTq+b26+K4kR1Kx1eY4gL9AkjVWJzDqy3lks=;
	h=Date:To:From:Subject:Message-Id; b=jEOV4NN2poBnvMXYWt+vpCbsTfTj6G/JyI70cbJctX4oEjZxnhNMkZYVebS7ShNGcrqj8+Cc4MIcxdvajnlU6SUbnFO2NLQ3draGhxZMFDQBkWTtCR7svG4aYkii8a6LdG38tYGvrJvDBVI5/Tepzu3/kGC/m6t/RdIgO+xCgUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ldjcpXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ldjcpXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6F4C4CEC3;
	Mon, 14 Oct 2024 20:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728936761;
	bh=i/oPxkmdTq+b26+K4kR1Kx1eY4gL9AkjVWJzDqy3lks=;
	h=Date:To:From:Subject:From;
	b=0ldjcpXUgEgUPHl2xg2c/gZ9QMVdFWXEHmFQGjpH10MevYOa076UVFu9o+dRs1+/3
	 jrQD0FwcV/Y9rkN47RmiB8QHiqu0AlkcbAFvMuj8bpJj3nNL7R70ZeXfKG5EmR8gbF
	 4XkFn8+bCHmgfeFHLAbN0zkgs/HX8yJjXAS8tyKw=
Date: Mon, 14 Oct 2024 13:12:40 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tsbogend@alpha.franken.de,ryabinin.a.a@gmail.com,kernel@xen0n.name,glider@google.com,dvyukov@google.com,chenhuacai@kernel.org,andreyknvl@gmail.com,maobibo@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-define-general-function-pxd_init.patch added to mm-unstable branch
Message-Id: <20241014201240.DF6F4C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: define general function pXd_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-define-general-function-pxd_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-define-general-function-pxd_init.patch

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
From: Bibo Mao <maobibo@loongson.cn>
Subject: mm: define general function pXd_init()
Date: Fri, 11 Oct 2024 17:33:18 +0800

pmd_init() and pud_init() are duplicated defined in file kasan.c and
sparse-vmemmap.c as weak functions.  Move them to generic header file
pgtable.h, architecture can redefine them.

Link: https://lkml.kernel.org/r/20241011093318.519432-1-maobibo@loongson.cn
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgtable.h |    2 ++
 arch/mips/include/asm/pgtable-64.h   |    2 ++
 include/linux/mm.h                   |    2 --
 include/linux/pgtable.h              |   14 ++++++++++++++
 mm/kasan/init.c                      |    8 --------
 mm/sparse-vmemmap.c                  |    8 --------
 6 files changed, 18 insertions(+), 18 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h~mm-define-general-function-pxd_init
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -267,7 +267,9 @@ extern void set_pmd_at(struct mm_struct
  * Initialize a new pgd / pud / pmd table with invalid pointers.
  */
 extern void pgd_init(void *addr);
+#define pud_init pud_init
 extern void pud_init(void *addr);
+#define pmd_init pmd_init
 extern void pmd_init(void *addr);
 
 /*
--- a/arch/mips/include/asm/pgtable-64.h~mm-define-general-function-pxd_init
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -316,7 +316,9 @@ static inline pmd_t *pud_pgtable(pud_t p
  * Initialize a new pgd / pud / pmd table with invalid pointers.
  */
 extern void pgd_init(void *addr);
+#define pud_init pud_init
 extern void pud_init(void *addr);
+#define pmd_init pmd_init
 extern void pmd_init(void *addr);
 
 /*
--- a/include/linux/mm.h~mm-define-general-function-pxd_init
+++ a/include/linux/mm.h
@@ -3821,8 +3821,6 @@ void *sparse_buffer_alloc(unsigned long
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
-void pmd_init(void *addr);
-void pud_init(void *addr);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
--- a/include/linux/pgtable.h~mm-define-general-function-pxd_init
+++ a/include/linux/pgtable.h
@@ -90,6 +90,20 @@ static inline unsigned long pud_index(un
 #define pgd_index(a)  (((a) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
 #endif
 
+#ifndef pmd_init
+static inline void pmd_init(void *addr)
+{
+}
+#define pmd_init pmd_init
+#endif
+
+#ifndef pud_init
+static inline void pud_init(void *addr)
+{
+}
+#define pud_init pud_init
+#endif
+
 #ifndef pte_offset_kernel
 static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
 {
--- a/mm/kasan/init.c~mm-define-general-function-pxd_init
+++ a/mm/kasan/init.c
@@ -139,10 +139,6 @@ static int __ref zero_pmd_populate(pud_t
 	return 0;
 }
 
-void __weak __meminit pmd_init(void *addr)
-{
-}
-
 static int __ref zero_pud_populate(p4d_t *p4d, unsigned long addr,
 				unsigned long end)
 {
@@ -181,10 +177,6 @@ static int __ref zero_pud_populate(p4d_t
 	return 0;
 }
 
-void __weak __meminit pud_init(void *addr)
-{
-}
-
 static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
 				unsigned long end)
 {
--- a/mm/sparse-vmemmap.c~mm-define-general-function-pxd_init
+++ a/mm/sparse-vmemmap.c
@@ -196,10 +196,6 @@ pmd_t * __meminit vmemmap_pmd_populate(p
 	return pmd;
 }
 
-void __weak __meminit pmd_init(void *addr)
-{
-}
-
 pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 {
 	pud_t *pud = pud_offset(p4d, addr);
@@ -213,10 +209,6 @@ pud_t * __meminit vmemmap_pud_populate(p
 	return pud;
 }
 
-void __weak __meminit pud_init(void *addr)
-{
-}
-
 p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
_

Patches currently in -mm which might be from maobibo@loongson.cn are

mm-define-general-function-pxd_init.patch

