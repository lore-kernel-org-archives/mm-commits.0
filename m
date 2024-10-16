Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6201D47A0
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729118215; cv=none; b=tf8b4E5NVMM1e8m+RayyOhWduPliH9rBA8rmTTyZoFB3h2f7ADgfjBDKLOX3BEZlx55GZaENqNsI25+7jv4Cvcyo2YvPh277byTJooLX7DMuBEbp6DERS2uiChFP44Vpfimv3P05eY1bl0uS+nMhRd4UUcnlBLfSGWPghgZggYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729118215; c=relaxed/simple;
	bh=uQTuDDnJt23z6z7QbI/sIr7PcfXxXBMTy79ySwggWgM=;
	h=Date:To:From:Subject:Message-Id; b=kXTWuWPsUilI7ZVjlrLaG3aWwIo+eQdwQTeRLnlg1OB3sK8oHhqU9Hv+5WZ6vO/0r8x4P3BjeEBT1coDjqYT0WzqGt9DTYX/85zQU0zzC3f1CIDfPeYL7wINuhXZnNX49m0ESQFOS1a9Eb3cFy1ga1rZDx+df6SHGu9SH4XzAhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G5NtIH2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G5NtIH2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FE0C4CEC7;
	Wed, 16 Oct 2024 22:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729118214;
	bh=uQTuDDnJt23z6z7QbI/sIr7PcfXxXBMTy79ySwggWgM=;
	h=Date:To:From:Subject:From;
	b=G5NtIH2y+g6D4/QZ2IBHZNrNS60ZNlGWdHCUFj3lSBnj4iV6DUCKxIm5w/hd9EGHz
	 TsoQZcSEwZIzDNjBd6yp3okpNnHuZ/i8hHbuS+PfJUIoj9xNUMUDK4PKEUiFgCAoWY
	 HQu8l7xnvmEbwGLnoZk3IeXA5f9hzc3O9P8+asYU=
Date: Wed, 16 Oct 2024 15:36:53 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,urezki@gmail.com,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,song@kernel.org,shorne@gmail.com,rostedt@goodmis.org,richard@nod.at,peterz@infradead.org,palmer@dabbelt.com,oleg@redhat.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mattst88@gmail.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hch@lst.de,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,bcain@quicinc.com,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-module-enable-rox-caches-for-module-text-on-64-bit.patch added to mm-unstable branch
Message-Id: <20241016223654.86FE0C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/module: enable ROX caches for module text on 64 bit
has been added to the -mm mm-unstable branch.  Its filename is
     x86-module-enable-rox-caches-for-module-text-on-64-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-module-enable-rox-caches-for-module-text-on-64-bit.patch

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
Subject: x86/module: enable ROX caches for module text on 64 bit
Date: Wed, 16 Oct 2024 15:24:24 +0300

Enable execmem's cache of PMD_SIZE'ed pages mapped as ROX for module text
allocations on 64 bit.

Link: https://lkml.kernel.org/r/20241016122424.1655560-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@lst.de>
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
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig   |    1 +
 arch/x86/mm/init.c |   37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

--- a/arch/x86/Kconfig~x86-module-enable-rox-caches-for-module-text-on-64-bit
+++ a/arch/x86/Kconfig
@@ -83,6 +83,7 @@ config X86
 	select ARCH_HAS_DMA_OPS			if GART_IOMMU || XEN
 	select ARCH_HAS_EARLY_DEBUG		if KGDB
 	select ARCH_HAS_ELF_RANDOMIZE
+	select ARCH_HAS_EXECMEM_ROX		if X86_64
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
--- a/arch/x86/mm/init.c~x86-module-enable-rox-caches-for-module-text-on-64-bit
+++ a/arch/x86/mm/init.c
@@ -1053,18 +1053,53 @@ unsigned long arch_max_swapfile_size(voi
 #ifdef CONFIG_EXECMEM
 static struct execmem_info execmem_info __ro_after_init;
 
+#ifdef CONFIG_ARCH_HAS_EXECMEM_ROX
+void execmem_fill_trapping_insns(void *ptr, size_t size, bool writeable)
+{
+	/* fill memory with INT3 instructions */
+	if (writeable)
+		memset(ptr, INT3_INSN_OPCODE, size);
+	else
+		text_poke_set(ptr, INT3_INSN_OPCODE, size);
+}
+#endif
+
 struct execmem_info __init *execmem_arch_setup(void)
 {
 	unsigned long start, offset = 0;
+	enum execmem_range_flags flags;
+	pgprot_t pgprot;
 
 	if (kaslr_enabled())
 		offset = get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
 
 	start = MODULES_VADDR + offset;
 
+	if (IS_ENABLED(CONFIG_ARCH_HAS_EXECMEM_ROX)) {
+		pgprot = PAGE_KERNEL_ROX;
+		flags = EXECMEM_KASAN_SHADOW | EXECMEM_ROX_CACHE;
+	} else {
+		pgprot = PAGE_KERNEL;
+		flags = EXECMEM_KASAN_SHADOW;
+	}
+
 	execmem_info = (struct execmem_info){
 		.ranges = {
-			[EXECMEM_DEFAULT] = {
+			[EXECMEM_MODULE_TEXT] = {
+				.flags	= flags,
+				.start	= start,
+				.end	= MODULES_END,
+				.pgprot	= pgprot,
+				.alignment = MODULE_ALIGN,
+			},
+			[EXECMEM_KPROBES ... EXECMEM_BPF] = {
+				.flags	= EXECMEM_KASAN_SHADOW,
+				.start	= start,
+				.end	= MODULES_END,
+				.pgprot	= PAGE_KERNEL,
+				.alignment = MODULE_ALIGN,
+			},
+			[EXECMEM_MODULE_DATA] = {
 				.flags	= EXECMEM_KASAN_SHADOW,
 				.start	= start,
 				.end	= MODULES_END,
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-kmemleak-fix-typo-in-object_no_scan-comment.patch
mm-vmalloc-group-declarations-depending-on-config_mmu-together.patch
mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch
asm-generic-introduce-text-patchingh.patch
module-prepare-to-handle-rox-allocations-for-text.patch
arch-introduce-set_direct_map_valid_noflush.patch
x86-module-prepare-module-loading-for-rox-allocations-of-text.patch
execmem-add-support-for-cache-of-large-rox-pages.patch
x86-module-enable-rox-caches-for-module-text-on-64-bit.patch

