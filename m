Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EEB1A2544
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 20:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728505716; cv=none; b=odIBlzz1FmL8ifL5LGr6YM/LRliAMdefvj/xeWhiBYgzC2TvQEdAeh4vjDuNKVq/lHWEgSZ6cWotKMwE6U5T3r+kqFfeTlfe58vMgJZhzWyoVIOKb6CgAzXdTQitOlUhI0Mh20K5wy8n8GWwIzDIYCtj9S9kzUE6wU32byuhiQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728505716; c=relaxed/simple;
	bh=LznZIdfarJxhVBIveKDwdBz91Lw1kb5sMTbxvhfvq2g=;
	h=Date:To:From:Subject:Message-Id; b=S7sUKp9LG/DUWr+x39YrHUfIeqOuBhQDz7f0WNgxPUdNNpbb617z+wQbM7s6KLalCRXIdYq8gp8HiHyykgj5y8YlVcIpN/bcZD6UvL+gO7zR7KFrIZby8DQm94Wtl3pLqu5qPvgMhPNfTuDBkPFxhj3QGZhWrx7N8KViczXzp9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zIRVKh8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIRVKh8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F55C4CEC3;
	Wed,  9 Oct 2024 20:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728505715;
	bh=LznZIdfarJxhVBIveKDwdBz91Lw1kb5sMTbxvhfvq2g=;
	h=Date:To:From:Subject:From;
	b=zIRVKh8x1HSKxu/GQ8K2+iALnV1T1XGjj3pNCt0XVMTggXyQl8RZbjodqy5kjzXEj
	 eUrhHKnOghNLBC5Pe6qRDl5XxWOuPHAuoODERt/RQZTm6ZTPKicKVM4aHoXWX6VIL9
	 8hOQO+ra2pTEFkLAK2OfBK0y2act63I7duWug+/8=
Date: Wed, 09 Oct 2024 13:28:35 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,urezki@gmail.com,tsbogend@alpha.franken.de,tglx@linutronix.de,song@kernel.org,shorne@gmail.com,rostedt@goodmis.org,richard@nod.at,peterz@infradead.org,palmer@dabbelt.com,oleg@redhat.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mattst88@gmail.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hch@infradead.org,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,bcain@quicinc.com,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-introduce-set_direct_map_valid_noflush.patch added to mm-unstable branch
Message-Id: <20241009202835.C9F55C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch: introduce set_direct_map_valid_noflush()
has been added to the -mm mm-unstable branch.  Its filename is
     arch-introduce-set_direct_map_valid_noflush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-introduce-set_direct_map_valid_noflush.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: arch: introduce set_direct_map_valid_noflush()
Date: Wed, 9 Oct 2024 21:08:13 +0300

Add an API that will allow updates of the direct/linear map for a set of
physically contiguous pages.

It will be used in the following patches.

Link: https://lkml.kernel.org/r/20241009180816.83591-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/set_memory.h     |    1 +
 arch/arm64/mm/pageattr.c                |   10 ++++++++++
 arch/loongarch/include/asm/set_memory.h |    1 +
 arch/loongarch/mm/pageattr.c            |   19 +++++++++++++++++++
 arch/riscv/include/asm/set_memory.h     |    1 +
 arch/riscv/mm/pageattr.c                |   15 +++++++++++++++
 arch/s390/include/asm/set_memory.h      |    1 +
 arch/s390/mm/pageattr.c                 |   11 +++++++++++
 arch/x86/include/asm/set_memory.h       |    1 +
 arch/x86/mm/pat/set_memory.c            |    8 ++++++++
 include/linux/set_memory.h              |    6 ++++++
 11 files changed, 74 insertions(+)

--- a/arch/arm64/include/asm/set_memory.h~arch-introduce-set_direct_map_valid_noflush
+++ a/arch/arm64/include/asm/set_memory.h
@@ -13,6 +13,7 @@ int set_memory_valid(unsigned long addr,
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 #endif /* _ASM_ARM64_SET_MEMORY_H */
--- a/arch/arm64/mm/pageattr.c~arch-introduce-set_direct_map_valid_noflush
+++ a/arch/arm64/mm/pageattr.c
@@ -192,6 +192,16 @@ int set_direct_map_default_noflush(struc
 				   PAGE_SIZE, change_page_range, &data);
 }
 
+int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+
+	if (!can_set_direct_map())
+		return 0;
+
+	return set_memory_valid(addr, nr, valid);
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
--- a/arch/loongarch/include/asm/set_memory.h~arch-introduce-set_direct_map_valid_noflush
+++ a/arch/loongarch/include/asm/set_memory.h
@@ -17,5 +17,6 @@ int set_memory_rw(unsigned long addr, in
 bool kernel_page_present(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_invalid_noflush(struct page *page);
+int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
--- a/arch/loongarch/mm/pageattr.c~arch-introduce-set_direct_map_valid_noflush
+++ a/arch/loongarch/mm/pageattr.c
@@ -216,3 +216,22 @@ int set_direct_map_invalid_noflush(struc
 
 	return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
 }
+
+int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	pgprot_t set, clear;
+
+	if (addr < vm_map_base)
+		return 0;
+
+	if (valid) {
+		set = PAGE_KERNEL;
+		clear = __pgprot(0);
+	} else {
+		set = __pgprot(0);
+		clear = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
+	}
+
+	return __set_memory(addr, 1, set, clear);
+}
--- a/arch/riscv/include/asm/set_memory.h~arch-introduce-set_direct_map_valid_noflush
+++ a/arch/riscv/include/asm/set_memory.h
@@ -42,6 +42,7 @@ static inline int set_kernel_memory(char
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 #endif /* __ASSEMBLY__ */
--- a/arch/riscv/mm/pageattr.c~arch-introduce-set_direct_map_valid_noflush
+++ a/arch/riscv/mm/pageattr.c
@@ -386,6 +386,21 @@ int set_direct_map_default_noflush(struc
 			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
 }
 
+int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
+{
+	pgprot_t set, clear;
+
+	if (valid) {
+		set = PAGE_KERNEL;
+		clear = __pgprot(_PAGE_EXEC);
+	} else {
+		set = __pgprot(0);
+		clear = __pgprot(_PAGE_PRESENT);
+	}
+
+	return __set_memory((unsigned long)page_address(page), nr, set, clear);
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *data)
 {
--- a/arch/s390/include/asm/set_memory.h~arch-introduce-set_direct_map_valid_noflush
+++ a/arch/s390/include/asm/set_memory.h
@@ -62,5 +62,6 @@ __SET_MEMORY_FUNC(set_memory_4k, SET_MEM
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 
 #endif
--- a/arch/s390/mm/pageattr.c~arch-introduce-set_direct_map_valid_noflush
+++ a/arch/s390/mm/pageattr.c
@@ -406,6 +406,17 @@ int set_direct_map_default_noflush(struc
 	return __set_memory((unsigned long)page_to_virt(page), 1, SET_MEMORY_DEF);
 }
 
+int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
+{
+	unsigned long flags;
+
+	if (valid)
+		flags = SET_MEMORY_DEF;
+	else
+		flags = SET_MEMORY_INV;
+
+	return __set_memory((unsigned long)page_to_virt(page), nr, flags);
+}
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
 
 static void ipte_range(pte_t *pte, unsigned long address, int nr)
--- a/arch/x86/include/asm/set_memory.h~arch-introduce-set_direct_map_valid_noflush
+++ a/arch/x86/include/asm/set_memory.h
@@ -89,6 +89,7 @@ int set_pages_rw(struct page *page, int
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
--- a/arch/x86/mm/pat/set_memory.c~arch-introduce-set_direct_map_valid_noflush
+++ a/arch/x86/mm/pat/set_memory.c
@@ -2444,6 +2444,14 @@ int set_direct_map_default_noflush(struc
 	return __set_pages_p(page, 1);
 }
 
+int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
+{
+	if (valid)
+		return __set_pages_p(page, nr);
+
+	return __set_pages_np(page, nr);
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
--- a/include/linux/set_memory.h~arch-introduce-set_direct_map_valid_noflush
+++ a/include/linux/set_memory.h
@@ -34,6 +34,12 @@ static inline int set_direct_map_default
 	return 0;
 }
 
+static inline int set_direct_map_valid_noflush(struct page *page,
+					       unsigned nr, bool valid)
+{
+	return 0;
+}
+
 static inline bool kernel_page_present(struct page *page)
 {
 	return true;
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-vmalloc-group-declarations-depending-on-config_mmu-together.patch
mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch
asm-generic-introduce-text-patchingh.patch
module-prepare-to-handle-rox-allocations-for-text.patch
arch-introduce-set_direct_map_valid_noflush.patch
x86-module-perpare-module-loading-for-rox-allocations-of-text.patch
execmem-add-support-for-cache-of-large-rox-pages.patch
x86-module-enable-rox-caches-for-module-text.patch

