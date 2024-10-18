Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E46F18C32A
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 20:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729283076; cv=none; b=ZNHSbH4vXMcTo7b7mPq5f/kEdKOq9ktJf3QKUoLp2b0HZ3MqSIE3jA/RkH1bBLbt5SCmV3Ulxmk+pDC3mKpXXko6XH8S/myUb8G2iLVrmlnT/OC/sXgu6zZJc36MmwKj5PV20ndmkbp0SpywjMyD50cS8kq/oQE1NU6jz+mWkL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729283076; c=relaxed/simple;
	bh=ECbMrTvi95nIMBEK1w1u/AUVXkcWXrtaBdkntL1WFbE=;
	h=Date:To:From:Subject:Message-Id; b=WYGW1cuur6/I4rJRvNLgSC5LJt9R/awHcjmT5YRrxPux976FGixJ2RfVbrMKw19Fis0gGEYotBH1dHRgo3Cl9uF62gsH9EkKzFSbLrvpBYK9HFMqUsI4GxOzmeRJ9O9QQJDYIwLSm04+ILgRnPrV5u8/hUXBeRYDv9sUvFs8zFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H4eFzcDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H4eFzcDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D9BC4CEC3;
	Fri, 18 Oct 2024 20:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729283075;
	bh=ECbMrTvi95nIMBEK1w1u/AUVXkcWXrtaBdkntL1WFbE=;
	h=Date:To:From:Subject:From;
	b=H4eFzcDP94LdDq6plO7Prs5TzLK8y4ZQmy5HjHuFcL8IgKW8hYbuZozFP/eYizKTS
	 RQc7ikQeqi8DoSNxd7qiZd6WHvg5aRyosDXwPNsva0IXVxR0pYLLZJiowNEWG7KO/7
	 9+aZkE1YtEYTa2Z4/XT3K+MD/bskWY+lev8AcvUw=
Date: Fri, 18 Oct 2024 13:24:34 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tsbogend@alpha.franken.de,ryabinin.a.a@gmail.com,kernel@xen0n.name,glider@google.com,dvyukov@google.com,chenhuacai@kernel.org,andreyknvl@gmail.com,maobibo@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-define-general-function-pxd_init.patch removed from -mm tree
Message-Id: <20241018202435.A6D9BC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: define general function pXd_init()
has been removed from the -mm tree.  Its filename was
     mm-define-general-function-pxd_init.patch

This patch was dropped because an updated version will be issued

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


