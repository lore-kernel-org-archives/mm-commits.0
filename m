Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002B91A0BC4;
	Wed, 23 Oct 2024 22:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729724294; cv=none; b=NF8sPMwJeL3nq7IVUDypMbH+rGN7xThgzAwmAWOasEa0JPg3ONfmoodpheY8KSzWX+o2GYkBnfL5/MXsB9PWsC5ToqSq073XyNiGFkK/H4q3vK2QIMHhr14okMcibS5QsSKeazW/0JARSCaSRKv3dOWiPm+jl4T028e/L/Ow9j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729724294; c=relaxed/simple;
	bh=VmY8RG8QmHWlVqtr5NBhlQDyFtefRTNJIxbDsa8v29s=;
	h=Date:To:From:Subject:Message-Id; b=D6W8JXOjvn2KJOPepuYLqbYiA+7zpjJWCIiujHz2LAblQlZC1QQ1brL+thHuEAvvQ8Dh9pCAVWzMMPp4YsGMUrK9je5kfIOCJjWwUN4d5flvMnJYehbMg/3yxuqtc4aj0V7848RUk2d/cfz4SZh5Jx5lu/PnPAkO42q4zr3D3tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PPvldaPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PPvldaPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685C1C4CEC6;
	Wed, 23 Oct 2024 22:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729724293;
	bh=VmY8RG8QmHWlVqtr5NBhlQDyFtefRTNJIxbDsa8v29s=;
	h=Date:To:From:Subject:From;
	b=PPvldaPh2cCS9fKsXk3VH8bpRVXrb3jB5K/zGOj9QS/cpl3BVLw2Oh24vSCXvrYqZ
	 0nVtHCaC/Q9VvSTDQ0kTeD6gbAMmFSmNkmtJNrbsoFmq8GxL5cfn9MdWpV+BwBKNnY
	 TtKH5fstcvv9bqtWL0wsQyL8uc7jBpWvIKUDdY1g=
Date: Wed, 23 Oct 2024 15:58:12 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,urezki@gmail.com,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,song@kernel.org,shorne@gmail.com,rostedt@goodmis.org,richard@nod.at,peterz@infradead.org,palmer@dabbelt.com,oleg@redhat.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mattst88@gmail.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,kdevops@lists.linux.dev,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hch@lst.de,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,bcain@quicinc.com,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-prepare-to-handle-rox-allocations-for-text.patch added to mm-unstable branch
Message-Id: <20241023225813.685C1C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: prepare to handle ROX allocations for text
has been added to the -mm mm-unstable branch.  Its filename is
     module-prepare-to-handle-rox-allocations-for-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-prepare-to-handle-rox-allocations-for-text.patch

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
Subject: module: prepare to handle ROX allocations for text
Date: Wed, 23 Oct 2024 19:27:07 +0300

In order to support ROX allocations for module text, it is necessary to
handle modifications to the code, such as relocations and alternatives
patching, without write access to that memory.

One option is to use text patching, but this would make module loading
extremely slow and will expose executable code that is not finally formed.

A better way is to have memory allocated with ROX permissions contain
invalid instructions and keep a writable, but not executable copy of the
module text.  The relocations and alternative patches would be done on the
writable copy using the addresses of the ROX memory.  Once the module is
completely ready, the updated text will be copied to ROX memory using text
patching in one go and the writable copy will be freed.

Add support for that to module initialization code and provide necessary
interfaces in execmem.

Link: https://lkml.kernel.org/r/20241023162711.2579610-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewd-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: kdevops <kdevops@lists.linux.dev>
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

 include/linux/execmem.h        |   23 +++++++++
 include/linux/module.h         |   16 ++++++
 include/linux/moduleloader.h   |    4 +
 kernel/module/debug_kmemleak.c |    3 -
 kernel/module/main.c           |   74 ++++++++++++++++++++++++++++---
 kernel/module/strict_rwx.c     |    3 +
 mm/execmem.c                   |   11 ++++
 7 files changed, 126 insertions(+), 8 deletions(-)

--- a/include/linux/execmem.h~module-prepare-to-handle-rox-allocations-for-text
+++ a/include/linux/execmem.h
@@ -46,9 +46,11 @@ enum execmem_type {
 /**
  * enum execmem_range_flags - options for executable memory allocations
  * @EXECMEM_KASAN_SHADOW:	allocate kasan shadow
+ * @EXECMEM_ROX_CACHE:		allocations should use ROX cache of huge pages
  */
 enum execmem_range_flags {
 	EXECMEM_KASAN_SHADOW	= (1 << 0),
+	EXECMEM_ROX_CACHE	= (1 << 1),
 };
 
 /**
@@ -123,6 +125,27 @@ void *execmem_alloc(enum execmem_type ty
  */
 void execmem_free(void *ptr);
 
+/**
+ * execmem_update_copy - copy an update to executable memory
+ * @dst:  destination address to update
+ * @src:  source address containing the data
+ * @size: how many bytes of memory shold be copied
+ *
+ * Copy @size bytes from @src to @dst using text poking if the memory at
+ * @dst is read-only.
+ *
+ * Return: a pointer to @dst or NULL on error
+ */
+void *execmem_update_copy(void *dst, const void *src, size_t size);
+
+/**
+ * execmem_is_rox - check if execmem is read-only
+ * @type - the execmem type to check
+ *
+ * Return: %true if the @type is read-only, %false if it's writable
+ */
+bool execmem_is_rox(enum execmem_type type);
+
 #if defined(CONFIG_EXECMEM) && !defined(CONFIG_ARCH_WANTS_EXECMEM_LATE)
 void execmem_init(void);
 #else
--- a/include/linux/module.h~module-prepare-to-handle-rox-allocations-for-text
+++ a/include/linux/module.h
@@ -367,6 +367,8 @@ enum mod_mem_type {
 
 struct module_memory {
 	void *base;
+	void *rw_copy;
+	bool is_rox;
 	unsigned int size;
 
 #ifdef CONFIG_MODULES_TREE_LOOKUP
@@ -767,6 +769,15 @@ static inline bool is_livepatch_module(s
 
 void set_module_sig_enforced(void);
 
+void *__module_writable_address(struct module *mod, void *loc);
+
+static inline void *module_writable_address(struct module *mod, void *loc)
+{
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_EXECMEM_ROX) || !mod)
+		return loc;
+	return __module_writable_address(mod, loc);
+}
+
 #else /* !CONFIG_MODULES... */
 
 static inline struct module *__module_address(unsigned long addr)
@@ -874,6 +885,11 @@ static inline bool module_is_coming(stru
 {
 	return false;
 }
+
+static inline void *module_writable_address(struct module *mod, void *loc)
+{
+	return loc;
+}
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_SYSFS
--- a/include/linux/moduleloader.h~module-prepare-to-handle-rox-allocations-for-text
+++ a/include/linux/moduleloader.h
@@ -108,6 +108,10 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *mod);
 
+int module_post_finalize(const Elf_Ehdr *hdr,
+			 const Elf_Shdr *sechdrs,
+			 struct module *mod);
+
 #ifdef CONFIG_MODULES
 void flush_module_init_free_work(void);
 #else
--- a/kernel/module/debug_kmemleak.c~module-prepare-to-handle-rox-allocations-for-text
+++ a/kernel/module/debug_kmemleak.c
@@ -14,7 +14,8 @@ void kmemleak_load_module(const struct m
 {
 	/* only scan writable, non-executable sections */
 	for_each_mod_mem_type(type) {
-		if (type != MOD_DATA && type != MOD_INIT_DATA)
+		if (type != MOD_DATA && type != MOD_INIT_DATA &&
+		    !mod->mem[type].is_rox)
 			kmemleak_no_scan(mod->mem[type].base);
 	}
 }
--- a/kernel/module/main.c~module-prepare-to-handle-rox-allocations-for-text
+++ a/kernel/module/main.c
@@ -1189,6 +1189,18 @@ void __weak module_arch_freeing_init(str
 {
 }
 
+void *__module_writable_address(struct module *mod, void *loc)
+{
+	for_class_mod_mem_type(type, text) {
+		struct module_memory *mem = &mod->mem[type];
+
+		if (loc >= mem->base && loc < mem->base + mem->size)
+			return loc + (mem->rw_copy - mem->base);
+	}
+
+	return loc;
+}
+
 static int module_memory_alloc(struct module *mod, enum mod_mem_type type)
 {
 	unsigned int size = PAGE_ALIGN(mod->mem[type].size);
@@ -1206,6 +1218,23 @@ static int module_memory_alloc(struct mo
 	if (!ptr)
 		return -ENOMEM;
 
+	mod->mem[type].base = ptr;
+
+	if (execmem_is_rox(execmem_type)) {
+		ptr = vzalloc(size);
+
+		if (!ptr) {
+			execmem_free(mod->mem[type].base);
+			return -ENOMEM;
+		}
+
+		mod->mem[type].rw_copy = ptr;
+		mod->mem[type].is_rox = true;
+	} else {
+		mod->mem[type].rw_copy = mod->mem[type].base;
+		memset(mod->mem[type].base, 0, size);
+	}
+
 	/*
 	 * The pointer to these blocks of memory are stored on the module
 	 * structure and we keep that around so long as the module is
@@ -1219,16 +1248,17 @@ static int module_memory_alloc(struct mo
 	 */
 	kmemleak_not_leak(ptr);
 
-	memset(ptr, 0, size);
-	mod->mem[type].base = ptr;
-
 	return 0;
 }
 
 static void module_memory_free(struct module *mod, enum mod_mem_type type,
 			       bool unload_codetags)
 {
-	void *ptr = mod->mem[type].base;
+	struct module_memory *mem = &mod->mem[type];
+	void *ptr = mem->base;
+
+	if (mem->is_rox)
+		vfree(mem->rw_copy);
 
 	if (!unload_codetags && mod_mem_type_is_core_data(type))
 		return;
@@ -2251,6 +2281,7 @@ static int move_module(struct module *mo
 	for_each_mod_mem_type(type) {
 		if (!mod->mem[type].size) {
 			mod->mem[type].base = NULL;
+			mod->mem[type].rw_copy = NULL;
 			continue;
 		}
 
@@ -2267,11 +2298,14 @@ static int move_module(struct module *mo
 		void *dest;
 		Elf_Shdr *shdr = &info->sechdrs[i];
 		enum mod_mem_type type = shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
+		unsigned long offset = shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK;
+		unsigned long addr;
 
 		if (!(shdr->sh_flags & SHF_ALLOC))
 			continue;
 
-		dest = mod->mem[type].base + (shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK);
+		addr = (unsigned long)mod->mem[type].base + offset;
+		dest = mod->mem[type].rw_copy + offset;
 
 		if (shdr->sh_type != SHT_NOBITS) {
 			/*
@@ -2293,7 +2327,7 @@ static int move_module(struct module *mo
 		 * users of info can keep taking advantage and using the newly
 		 * minted official memory area.
 		 */
-		shdr->sh_addr = (unsigned long)dest;
+		shdr->sh_addr = addr;
 		pr_debug("\t0x%lx 0x%.8lx %s\n", (long)shdr->sh_addr,
 			 (long)shdr->sh_size, info->secstrings + shdr->sh_name);
 	}
@@ -2441,8 +2475,17 @@ int __weak module_finalize(const Elf_Ehd
 	return 0;
 }
 
+int __weak module_post_finalize(const Elf_Ehdr *hdr,
+				const Elf_Shdr *sechdrs,
+				struct module *me)
+{
+	return 0;
+}
+
 static int post_relocation(struct module *mod, const struct load_info *info)
 {
+	int ret;
+
 	/* Sort exception table now relocations are done. */
 	sort_extable(mod->extable, mod->extable + mod->num_exentries);
 
@@ -2454,7 +2497,24 @@ static int post_relocation(struct module
 	add_kallsyms(mod, info);
 
 	/* Arch-specific module finalizing. */
-	return module_finalize(info->hdr, info->sechdrs, mod);
+	ret = module_finalize(info->hdr, info->sechdrs, mod);
+	if (ret)
+		return ret;
+
+	for_each_mod_mem_type(type) {
+		struct module_memory *mem = &mod->mem[type];
+
+		if (mem->is_rox) {
+			if (!execmem_update_copy(mem->base, mem->rw_copy,
+						 mem->size))
+				return -ENOMEM;
+
+			vfree(mem->rw_copy);
+			mem->rw_copy = NULL;
+		}
+	}
+
+	return module_post_finalize(info->hdr, info->sechdrs, mod);
 }
 
 /* Call module constructors. */
--- a/kernel/module/strict_rwx.c~module-prepare-to-handle-rox-allocations-for-text
+++ a/kernel/module/strict_rwx.c
@@ -34,6 +34,9 @@ int module_enable_text_rox(const struct
 	for_class_mod_mem_type(type, text) {
 		int ret;
 
+		if (mod->mem[type].is_rox)
+			continue;
+
 		if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
 			ret = module_set_memory(mod, type, set_memory_rox);
 		else
--- a/mm/execmem.c~module-prepare-to-handle-rox-allocations-for-text
+++ a/mm/execmem.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/execmem.h>
 #include <linux/moduleloader.h>
+#include <linux/text-patching.h>
 
 static struct execmem_info *execmem_info __ro_after_init;
 static struct execmem_info default_execmem_info __ro_after_init;
@@ -69,6 +70,16 @@ void execmem_free(void *ptr)
 	vfree(ptr);
 }
 
+void *execmem_update_copy(void *dst, const void *src, size_t size)
+{
+	return text_poke_copy(dst, src, size);
+}
+
+bool execmem_is_rox(enum execmem_type type)
+{
+	return !!(execmem_info->ranges[type].flags & EXECMEM_ROX_CACHE);
+}
+
 static bool execmem_validate(struct execmem_info *info)
 {
 	struct execmem_range *r = &info->ranges[EXECMEM_DEFAULT];
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

