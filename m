Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67A413C918;
	Wed,  6 Nov 2024 01:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854846; cv=none; b=jxUbZH436dmr4dP/p6nZwnd6x6RAQLuPgn/tDuqK6wAcq/Uf6UXOsONBeE4BVh0csmm4aWHSYUp8Gt41fc5govZiui0KFYUEG+PKotJ4B6QyslRVS8fau8tv5ZKso85Sx/4Lej/sdejSy5Xs+qQvT9j5POp2ranZx5lK7GENwls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854846; c=relaxed/simple;
	bh=9Om+gFCwVfoY0VSwfOXPJdBVMJGJTIl4aXr0gf2uSHA=;
	h=Date:To:From:Subject:Message-Id; b=X1QrRtfqvb/cWBz/agvcdR55alNNScfGhTssdpIJhvAirfSbgB1Qv1MYTtJqL5O9OPEL3dqxhshyMNnNQdIz9yQU5+YJj3I0mQZh6f4PpbEmU7DuWghWhGgJ6k/969nWpp08Kx4jgkqsCe+W/xPd2zIOsbMCBa3O5XsTycvkIcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yo8QCHJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yo8QCHJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4830C4CECF;
	Wed,  6 Nov 2024 01:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854846;
	bh=9Om+gFCwVfoY0VSwfOXPJdBVMJGJTIl4aXr0gf2uSHA=;
	h=Date:To:From:Subject:From;
	b=yo8QCHJ/UJj2eNeX6DQ1IqoJfVa8JxvahUV9tMEuaYTBetgjtK5NWXb0eiOSLg49R
	 7GkTZZTFHzH9hHdQHwPoxOeDkurHghwgHlyeJhRLQLYGHnyftKcjaVCxvpcQ8YLxwY
	 D1LqG76psUGrmsSaTpgoDb4Fxq6ISbDSVjd0C7C0=
Date: Tue, 05 Nov 2024 17:00:46 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,urezki@gmail.com,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,song@kernel.org,shorne@gmail.com,rostedt@goodmis.org,richard@nod.at,peterz@infradead.org,palmer@dabbelt.com,oleg@redhat.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mattst88@gmail.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,kdevops@lists.linux.dev,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hch@lst.de,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,bcain@quicinc.com,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch-introduce-set_direct_map_valid_noflush.patch removed from -mm tree
Message-Id: <20241106010046.A4830C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch: introduce set_direct_map_valid_noflush()
has been removed from the -mm tree.  Its filename was
     arch-introduce-set_direct_map_valid_noflush.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: arch: introduce set_direct_map_valid_noflush()
Date: Wed, 23 Oct 2024 19:27:08 +0300

Add an API that will allow updates of the direct/linear map for a set of
physically contiguous pages.

It will be used in the following patches.

Link: https://lkml.kernel.org/r/20241023162711.2579610-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: kdevops <kdevops@lists.linux.dev>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
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
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
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
Cc: Suren Baghdasaryan <surenb@google.com>
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


