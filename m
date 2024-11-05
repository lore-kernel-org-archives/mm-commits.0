Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9C92EAE5
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 03:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730775811; cv=none; b=e97iLku8IlJWcvr6Aa+9H/pvCSCJo0P0nTf//NNMk4E9no1lxIQFL99kgCuIjEFAeRWUaALOHCmoJkSGyhadJqLAngRWSD4Lob08VG3x+HjCW6IZ0/jUhU4sGp5vSU3yX73xWe2c5k/S/Zicrbc1QK/NzV1vP87GQuG4dZV/Qss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730775811; c=relaxed/simple;
	bh=Vgx+ckB2BcU/dafPWRoc9pdOk7W2AE9PTpfm3yH7j24=;
	h=Date:To:From:Subject:Message-Id; b=ifchlhZmKMHhu/gmOOFgcL3sCpGC7oXm/+EPAMZsxx4AUK5W8nAxbs4hhhpIUfpA8GcOVE/V30U8gsCfesFk+CbwTf/3r4eBwZb2TsFdT3ViHbJ5fhNqz7KsswyXds1bEZid1V039knb6zFqXui94I4lajvjYTSBGW5Kj/4uT7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W0BH2vFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W0BH2vFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5ADC4CECE;
	Tue,  5 Nov 2024 03:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730775811;
	bh=Vgx+ckB2BcU/dafPWRoc9pdOk7W2AE9PTpfm3yH7j24=;
	h=Date:To:From:Subject:From;
	b=W0BH2vFwJjwdbX2sSjvWbYcut6komVaY8ROcb2iFAEo8fHZCb97TetHSnQSVM5p+I
	 PdnhkvSrR4MFpzfE5Gevi+nvnEDCAy99IQJnJkBEbXSaEVVOyjNYd2OHhcP7w2RSfm
	 OLk2JO71gTU5FjU83Iq4YDLmf7mLtk893GEQJO10=
Date: Mon, 04 Nov 2024 19:03:30 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tsbogend@alpha.franken.de,ryabinin.a.a@gmail.com,kernel@xen0n.name,glider@google.com,dvyukov@google.com,chenhuacai@loongson.cn,andreyknvl@gmail.com,maobibo@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-define-general-function-pxd_init.patch added to mm-unstable branch
Message-Id: <20241105030331.0F5ADC4CECE@smtp.kernel.org>
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

mm-define-general-function-pxd_init.patch

