Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D306B335082
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025868; cv=none; b=Q8fhJRXF9h0K4aqYCBPlUty0SnkwtQngNxycH4/T73IpLxODH7ASkpWoWtrM6XYaUYMgfG6OechiF3a3t+oy+b74iAwIAqPsayPFEiTocQJsCY9YwGBxqfS5wr5Qh/0x8b+fvYMI7yBYdHaczUULGUXXKdo/VyE7FWaQNIHk9bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025868; c=relaxed/simple;
	bh=l2HEsaV5Gl73LY94mHYI3rDObAydJVNNoASZQkzUHV0=;
	h=Date:To:From:Subject:Message-Id; b=krILcAD89Ns2oiZz/MMdCQHQOGSHY8Gd74rzDbmnoxIXpk5dVmVyzv0DFlR2ds5Wce874IM9vwz5wM07IQUZFCjFo16Zw9EZgfUibDjQh5N/JE3IP/34/l4gVjg4GIFE7GBw1Pvo2synYVtY/Jv/iytppzLxZxdgSbqGGjkYzFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jIvI4c92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jIvI4c92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D53AC4CEF1;
	Mon, 24 Nov 2025 23:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025868;
	bh=l2HEsaV5Gl73LY94mHYI3rDObAydJVNNoASZQkzUHV0=;
	h=Date:To:From:Subject:From;
	b=jIvI4c92BLRSjj6N6K88gQL9NGDWvYwq3H79TpZHBPnp1S1V241SQdSQTzTLL39oW
	 hOcKOZa8PsuAisxgIL3J9dpXoDhCj8RKc4sI0ieNkRalk6Prxu5d7KE7aN2RNVAODr
	 7e+9c8Z8N02C1KB1+5PZM5zH5S/1UGGObDJETj3U=
Date: Mon, 24 Nov 2025 15:11:08 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,robh@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jack@suse.cz,debug@rivosinc.com,david@redhat.com,conor@kernel.org,conor.dooley@microchip.com,brauner@kernel.org,axelrasmussen@google.com,arnd@arndb.de,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,alex@ghiti.fr,ajones@ventanamicro.com,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-mm-add-userfaultfd-write-protect-support.patch removed from -mm tree
Message-Id: <20251124231108.9D53AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: mm: add userfaultfd write-protect support
has been removed from the -mm tree.  Its filename was
     riscv-mm-add-userfaultfd-write-protect-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Subject: riscv: mm: add userfaultfd write-protect support
Date: Thu, 13 Nov 2025 15:28:05 +0800

The Svrsw60t59b extension allows to free the PTE reserved bits 60 and 59
for software, this patch uses bit 60 for uffd-wp tracking

Additionally for tracking the uffd-wp state as a PTE swap bit, we borrow
bit 4 which is not involved into swap entry computation.

Link: https://lkml.kernel.org/r/20251113072806.795029-6-zhangchunyan@iscas.ac.cn
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Conor Dooley <conor.dooley@microchip.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig                    |    1 
 arch/riscv/include/asm/pgtable-bits.h |   18 ++++++
 arch/riscv/include/asm/pgtable.h      |   68 ++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

--- a/arch/riscv/include/asm/pgtable-bits.h~riscv-mm-add-userfaultfd-write-protect-support
+++ a/arch/riscv/include/asm/pgtable-bits.h
@@ -38,6 +38,24 @@
 #define _PAGE_SWP_SOFT_DIRTY	0
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+
+/* ext_svrsw60t59b: Bit(60) for uffd-wp tracking */
+#define _PAGE_UFFD_WP							\
+	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
+	 (1UL << 60) : 0)
+/*
+ * Bit 4 is not involved into swap entry computation, so we
+ * can borrow it for swap page uffd-wp tracking.
+ */
+#define _PAGE_SWP_UFFD_WP						\
+	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
+	 _PAGE_USER : 0)
+#else
+#define _PAGE_UFFD_WP		0
+#define _PAGE_SWP_UFFD_WP	0
+#endif
+
 #define _PAGE_TABLE     _PAGE_PRESENT
 
 /*
--- a/arch/riscv/include/asm/pgtable.h~riscv-mm-add-userfaultfd-write-protect-support
+++ a/arch/riscv/include/asm/pgtable.h
@@ -417,6 +417,41 @@ static inline pte_t pte_wrprotect(pte_t
 	return __pte(pte_val(pte) & ~(_PAGE_WRITE));
 }
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+#define pgtable_supports_uffd_wp()	\
+	riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)
+
+static inline bool pte_uffd_wp(pte_t pte)
+{
+	return !!(pte_val(pte) & _PAGE_UFFD_WP);
+}
+
+static inline pte_t pte_mkuffd_wp(pte_t pte)
+{
+	return pte_wrprotect(__pte(pte_val(pte) | _PAGE_UFFD_WP));
+}
+
+static inline pte_t pte_clear_uffd_wp(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(_PAGE_UFFD_WP));
+}
+
+static inline bool pte_swp_uffd_wp(pte_t pte)
+{
+	return !!(pte_val(pte) & _PAGE_SWP_UFFD_WP);
+}
+
+static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_SWP_UFFD_WP);
+}
+
+static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(_PAGE_SWP_UFFD_WP));
+}
+#endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
+
 /* static inline pte_t pte_mkread(pte_t pte) */
 
 static inline pte_t pte_mkwrite_novma(pte_t pte)
@@ -841,6 +876,38 @@ static inline pud_t pud_mkspecial(pud_t
 }
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+static inline bool pmd_uffd_wp(pmd_t pmd)
+{
+	return pte_uffd_wp(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_mkuffd_wp(pmd_t pmd)
+{
+	return pte_pmd(pte_mkuffd_wp(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_clear_uffd_wp(pmd_t pmd)
+{
+	return pte_pmd(pte_clear_uffd_wp(pmd_pte(pmd)));
+}
+
+static inline bool pmd_swp_uffd_wp(pmd_t pmd)
+{
+	return pte_swp_uffd_wp(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_swp_mkuffd_wp(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_mkuffd_wp(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_clear_uffd_wp(pmd_pte(pmd)));
+}
+#endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline bool pmd_soft_dirty(pmd_t pmd)
 {
@@ -1075,6 +1142,7 @@ static inline pud_t pud_modify(pud_t pud
  *	bit            0:	_PAGE_PRESENT (zero)
  *	bit       1 to 2:	(zero)
  *	bit            3:	_PAGE_SWP_SOFT_DIRTY
+ *	bit            4:	_PAGE_SWP_UFFD_WP
  *	bit            5:	_PAGE_PROT_NONE (zero)
  *	bit            6:	exclusive marker
  *	bits      7 to 11:	swap type
--- a/arch/riscv/Kconfig~riscv-mm-add-userfaultfd-write-protect-support
+++ a/arch/riscv/Kconfig
@@ -148,6 +148,7 @@ config RISCV
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT && MMU
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if 64BIT && MMU
 	select HAVE_ARCH_USERFAULTFD_MINOR if 64BIT && USERFAULTFD
+	select HAVE_ARCH_USERFAULTFD_WP if 64BIT && MMU && USERFAULTFD && RISCV_ISA_SVRSW60T59B
 	select HAVE_ARCH_VMAP_STACK if MMU && 64BIT
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_CONTEXT_TRACKING_USER
_

Patches currently in -mm which might be from zhangchunyan@iscas.ac.cn are


