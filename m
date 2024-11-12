Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5428204F7A
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374583; cv=none; b=u0wwqfvpy3Dq0bMoLusxGvmnqFU/UMt/Sr4ShXfN3MOf0iPIB87rSE6ycA+UM05+Dy/qyoBR9wVUddafs7yFnYN7PVzp8qCXDIs6+gWEssvMqOks1xktX4g4duYrfq4/SNL+8Jm6iDWANsusRXcBHFmLkhKfiyVSvvxyITCffak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374583; c=relaxed/simple;
	bh=+KS86CplTwJWphb82VBK2hzz/LzKxhrDeheq4hpA6CM=;
	h=Date:To:From:Subject:Message-Id; b=RfoNCByEBGAK6BkfN9CSVmDgkWWJu38s7Y+N46YWedEJ87nuAAytZKZQuaB4cOqt3kYZZGmg3uvmf7/hiag/vI4yW37BT1ElWdsQSjiI01msKR64x/7CRhH8A4tyb5LxmFXykS9/kdT7ZLfSHoNunbtBgXOvWEc8D42+JCzkCWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Prmct4Fe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Prmct4Fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991F0C4CECF;
	Tue, 12 Nov 2024 01:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374583;
	bh=+KS86CplTwJWphb82VBK2hzz/LzKxhrDeheq4hpA6CM=;
	h=Date:To:From:Subject:From;
	b=Prmct4FeqapwgXRZTTBb2EBydixwgyTdwnHAx8qhI/2BG5iVvAh4Ln2QW4jx6Pd/I
	 b3a0nrsBpHK7akogMEm8m49pUdv0IBhyFi199sgpDZlWRi1MAuCc15Pj7pjd+4tLPN
	 YU7T8pQ0khGLhzClwNtMLTQ26ommEJUtRDh+3jjA=
Date: Mon, 11 Nov 2024 17:23:03 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tsbogend@alpha.franken.de,ryabinin.a.a@gmail.com,kernel@xen0n.name,glider@google.com,dvyukov@google.com,chenhuacai@loongson.cn,andreyknvl@gmail.com,maobibo@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-define-general-function-pxd_init.patch removed from -mm tree
Message-Id: <20241112012303.991F0C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: define general function pXd_init()
has been removed from the -mm tree.  Its filename was
     mm-define-general-function-pxd_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bibo Mao <maobibo@loongson.cn>
Subject: mm: define general function pXd_init()
Date: Mon, 4 Nov 2024 15:07:12 +0800

pud_init(), pmd_init() and kernel_pte_init() are duplicated defined in
file kasan.c and sparse-vmemmap.c as weak functions.  Move them to generic
header file pgtable.h, architecture can redefine them.

Link: https://lkml.kernel.org/r/20241104070712.52902-1-maobibo@loongson.cn
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgtable.h |    3 +++
 arch/mips/include/asm/pgtable-64.h   |    2 ++
 include/linux/mm.h                   |    3 ---
 include/linux/pgtable.h              |   21 +++++++++++++++++++++
 mm/kasan/init.c                      |   12 ------------
 mm/sparse-vmemmap.c                  |   12 ------------
 6 files changed, 26 insertions(+), 27 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h~mm-define-general-function-pxd_init
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -268,8 +268,11 @@ extern void set_pmd_at(struct mm_struct
  */
 extern void pgd_init(void *addr);
 extern void pud_init(void *addr);
+#define pud_init pud_init
 extern void pmd_init(void *addr);
+#define pmd_init pmd_init
 extern void kernel_pte_init(void *addr);
+#define kernel_pte_init kernel_pte_init
 
 /*
  * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
--- a/arch/mips/include/asm/pgtable-64.h~mm-define-general-function-pxd_init
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -317,7 +317,9 @@ static inline pmd_t *pud_pgtable(pud_t p
  */
 extern void pgd_init(void *addr);
 extern void pud_init(void *addr);
+#define pud_init pud_init
 extern void pmd_init(void *addr);
+#define pmd_init pmd_init
 
 /*
  * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
--- a/include/linux/mm.h~mm-define-general-function-pxd_init
+++ a/include/linux/mm.h
@@ -3819,9 +3819,6 @@ void *sparse_buffer_alloc(unsigned long
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
-void pud_init(void *addr);
-void pmd_init(void *addr);
-void kernel_pte_init(void *addr);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
--- a/include/linux/pgtable.h~mm-define-general-function-pxd_init
+++ a/include/linux/pgtable.h
@@ -90,6 +90,27 @@ static inline unsigned long pud_index(un
 #define pgd_index(a)  (((a) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
 #endif
 
+#ifndef kernel_pte_init
+static inline void kernel_pte_init(void *addr)
+{
+}
+#define kernel_pte_init kernel_pte_init
+#endif
+
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
@@ -106,10 +106,6 @@ static void __ref zero_pte_populate(pmd_
 	}
 }
 
-void __weak __meminit kernel_pte_init(void *addr)
-{
-}
-
 static int __ref zero_pmd_populate(pud_t *pud, unsigned long addr,
 				unsigned long end)
 {
@@ -145,10 +141,6 @@ static int __ref zero_pmd_populate(pud_t
 	return 0;
 }
 
-void __weak __meminit pmd_init(void *addr)
-{
-}
-
 static int __ref zero_pud_populate(p4d_t *p4d, unsigned long addr,
 				unsigned long end)
 {
@@ -187,10 +179,6 @@ static int __ref zero_pud_populate(p4d_t
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
@@ -184,10 +184,6 @@ static void * __meminit vmemmap_alloc_bl
 	return p;
 }
 
-void __weak __meminit kernel_pte_init(void *addr)
-{
-}
-
 pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
@@ -201,10 +197,6 @@ pmd_t * __meminit vmemmap_pmd_populate(p
 	return pmd;
 }
 
-void __weak __meminit pmd_init(void *addr)
-{
-}
-
 pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 {
 	pud_t *pud = pud_offset(p4d, addr);
@@ -218,10 +210,6 @@ pud_t * __meminit vmemmap_pud_populate(p
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


