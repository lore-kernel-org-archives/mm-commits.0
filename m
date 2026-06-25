Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A0D37DEBB
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 01:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782352026; cv=none; b=dkq89lwOCPimitM/G300hN8GDkU1K8mGyKTyGgKJtlo7FNiZXg08isRrFKkW6D8Z1K/v00Zc7UHhICm3fQ8sq6x2S7ZdCJyD+JyVI7i1TSgiyKT377Lq+ghqGbIAv8EPGjtkrgQ36nC3UqZCs8Ap0LVXWxX0abDFDc4ZImw9RT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782352026; c=relaxed/simple;
	bh=jJTPdCC2y6ko6ep9cmEydH5T5JPNH3N7P31YB8I8qIg=;
	h=Date:To:From:Subject:Message-Id; b=q45sS7cxfjtle2tTa6txKh4l240vqf3lmxdL2IjkJ4yf2bhNMt3TGlPlYTXJPVhCx1ZknLInPYiiyrhraa9Z58YA1MZNdgwkq1GzvoguVugUS/1j2MGtyFA57GdmHWrOph9E5UBMVaRboK7e8e5CO/VEFSD9XbS1l2MtCrHGyl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z+J/LZ7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z+J/LZ7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81771F000E9;
	Thu, 25 Jun 2026 01:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782352024;
	bh=VVnrm/jDj4owxe+/hfydH59ixUiyYZRTSGNNB3UMSEw=;
	h=Date:To:From:Subject;
	b=z+J/LZ7HGdfSo9xmShq1UE/VZeQmBJqvIvUTLSPSbrj6r0Efo5TE06xtQPQAPJlb/
	 YEiFNoJxCp5mJc6OInhO0z4LUSsUC7BwlqOyCxUcNLsVOYIWIbSIevxFAqSNOEMOgc
	 JYq7EvxptAcdq9cRs3rRbqv2A24rtVo2qySAG8hk=
Date: Wed, 24 Jun 2026 18:47:04 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,thuth@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files.patch added to mm-new branch
Message-Id: <20260625014704.B81771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: replace __ASSEMBLY__ with __ASSEMBLER__ in memory management header files
has been added to the -mm mm-new branch.  Its filename is
     mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Thomas Huth <thuth@redhat.com>
Subject: mm: replace __ASSEMBLY__ with __ASSEMBLER__ in memory management header files
Date: Fri, 19 Jun 2026 15:18:30 +0200

While the GCC and Clang compilers already define __ASSEMBLER__
automatically when compiling assembly code, __ASSEMBLY__ is a macro that
only gets defined by the Makefiles in the kernel.  This can be very
confusing when switching between userspace and kernelspace coding, or when
dealing with uapi headers that rather should use __ASSEMBLER__ instead. 
So let's standardize now on the __ASSEMBLER__ macro that is provided by
the compilers.

This is a completely mechanical patch (done with a simple "sed -i"
statement).

Link: https://lore.kernel.org/20260619131830.229804-1-thuth@redhat.com
Signed-off-by: Thomas Huth <thuth@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/fixmap.h        |    4 ++--
 include/asm-generic/getorder.h      |    4 ++--
 include/asm-generic/memory_model.h  |    4 ++--
 include/asm-generic/mmu.h           |    2 +-
 include/asm-generic/pgtable-nop4d.h |    4 ++--
 include/asm-generic/pgtable-nopmd.h |    4 ++--
 include/asm-generic/pgtable-nopud.h |    4 ++--
 include/linux/mmzone.h              |    4 ++--
 include/linux/pfn.h                 |    2 +-
 include/linux/pgtable.h             |    4 ++--
 10 files changed, 18 insertions(+), 18 deletions(-)

--- a/include/asm-generic/fixmap.h~mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files
+++ a/include/asm-generic/fixmap.h
@@ -21,7 +21,7 @@
 #define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
 #define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 /*
  * 'index to address' translation. If anyone tries to use the idx
  * directly without translation, we catch the bug with a NULL-deference
@@ -97,5 +97,5 @@ static inline unsigned long virt_to_fix(
 #define set_fixmap_io(idx, phys) \
 	__set_fixmap(idx, phys, FIXMAP_PAGE_IO)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* __ASM_GENERIC_FIXMAP_H */
--- a/include/asm-generic/getorder.h~mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files
+++ a/include/asm-generic/getorder.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_GENERIC_GETORDER_H
 #define __ASM_GENERIC_GETORDER_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/compiler.h>
 #include <linux/log2.h>
@@ -47,6 +47,6 @@ static __always_inline __attribute_const
 #endif
 }
 
-#endif	/* __ASSEMBLY__ */
+#endif	/* __ASSEMBLER__ */
 
 #endif	/* __ASM_GENERIC_GETORDER_H */
--- a/include/asm-generic/memory_model.h~mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files
+++ a/include/asm-generic/memory_model.h
@@ -4,7 +4,7 @@
 
 #include <linux/pfn.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 /*
  * supports 3 memory models.
@@ -86,6 +86,6 @@ static inline int pfn_valid(unsigned lon
 #endif /* CONFIG_DEBUG_VIRTUAL */
 #define phys_to_page(phys)	pfn_to_page(PHYS_PFN(phys))
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif
--- a/include/asm-generic/mmu.h~mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files
+++ a/include/asm-generic/mmu.h
@@ -6,7 +6,7 @@
  * This is the mmu.h header for nommu implementations.
  * Architectures with an MMU need something more complex.
  */
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 typedef struct {
 	unsigned long		end_brk;
 
--- a/include/asm-generic/pgtable-nop4d.h~mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files
+++ a/include/asm-generic/pgtable-nop4d.h
@@ -2,7 +2,7 @@
 #ifndef _PGTABLE_NOP4D_H
 #define _PGTABLE_NOP4D_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #define __PAGETABLE_P4D_FOLDED 1
 
@@ -54,5 +54,5 @@ static inline p4d_t *p4d_offset(pgd_t *p
 #undef  p4d_addr_end
 #define p4d_addr_end(addr, end)			(end)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* _PGTABLE_NOP4D_H */
--- a/include/asm-generic/pgtable-nopmd.h~mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -2,7 +2,7 @@
 #ifndef _PGTABLE_NOPMD_H
 #define _PGTABLE_NOPMD_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm-generic/pgtable-nopud.h>
 
@@ -68,6 +68,6 @@ static inline void pmd_free(struct mm_st
 #undef  pmd_addr_end
 #define pmd_addr_end(addr, end)			(end)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* _PGTABLE_NOPMD_H */
--- a/include/asm-generic/pgtable-nopud.h~mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files
+++ a/include/asm-generic/pgtable-nopud.h
@@ -2,7 +2,7 @@
 #ifndef _PGTABLE_NOPUD_H
 #define _PGTABLE_NOPUD_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm-generic/pgtable-nop4d.h>
 
@@ -62,5 +62,5 @@ static inline pud_t *pud_offset(p4d_t *p
 #undef  pud_addr_end
 #define pud_addr_end(addr, end)			(end)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* _PGTABLE_NOPUD_H */
--- a/include/linux/mmzone.h~mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files
+++ a/include/linux/mmzone.h
@@ -2,7 +2,7 @@
 #ifndef _LINUX_MMZONE_H
 #define _LINUX_MMZONE_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #ifndef __GENERATING_BOUNDS_H
 
 #include <linux/spinlock.h>
@@ -2389,5 +2389,5 @@ static inline unsigned long next_present
 #endif
 
 #endif /* !__GENERATING_BOUNDS.H */
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 #endif /* _LINUX_MMZONE_H */
--- a/include/linux/pfn.h~mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files
+++ a/include/linux/pfn.h
@@ -2,7 +2,7 @@
 #ifndef _LINUX_PFN_H_
 #define _LINUX_PFN_H_
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/types.h>
 #endif
 
--- a/include/linux/pgtable.h~mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files
+++ a/include/linux/pgtable.h
@@ -8,7 +8,7 @@
 #define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 #define PUD_ORDER	(PUD_SHIFT - PAGE_SHIFT)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #ifdef CONFIG_MMU
 
 #include <linux/mm_types.h>
@@ -2320,7 +2320,7 @@ static inline const char *pgtable_level_
 	}
 }
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
_

Patches currently in -mm which might be from thuth@redhat.com are

mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files.patch

