Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8FE4A21
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735605752; cv=none; b=PuCixGqP+8FlqIlKU7bbhOzULu354FCAqiYUzBNDH+C592o2CAMXmhPz95UVqA350bY8j0INe9tHjo+wek6ehXyEHNt5yrXivFHiOtgZimPoGVwatzCTF8NjbeF8/ApJlAShDpNxPkV1oy+8PW8aFVKhLgq5G7J29yu/m7urd8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735605752; c=relaxed/simple;
	bh=BFvD+Xuxcxcvuv4vGByX7O+UKZCkdEzrEFemOUypUuo=;
	h=Date:To:From:Subject:Message-Id; b=G9F3rBtv3qEymNV9tCeWjBm44SHqaeOL7X/dcjfoKKHGHoZisOSiUOEieyYdLMI7i7yvQ5GZD2rHoP97ZPwTO3bvuqS/qfjIDPvtrT805IIAkW4kxo6O+UhBZYI9bp/Jv6pOGwmPs2ER1icbrnPqWp/Xb+eXVvyCGtjyOfmkdnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vb05ui1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vb05ui1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167F6C4CED0;
	Tue, 31 Dec 2024 00:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735605752;
	bh=BFvD+Xuxcxcvuv4vGByX7O+UKZCkdEzrEFemOUypUuo=;
	h=Date:To:From:Subject:From;
	b=Vb05ui1us2k8unkl8Kfvw9TKiaFbsVzTrmbuwlsijQHcsIPi7PouUUnv8AmDyJLtx
	 Lif6uc3prtKDVzqpNz1XMqGzvQ9fwPZbB6vvWTTBCcBTWX8GIt2Yz8xKABtbjwv8h8
	 N9aBiWCqP1K6lhfDXe68KFVamHlOWm8+13onxX4Y=
Date: Mon, 30 Dec 2024 16:42:31 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,song@kernel.org,shuah@kernel.org,samitolvanen@google.com,rostedt@goodmis.org,rmoar@google.com,richard@nod.at,pmladek@suse.com,petr.pavlu@suse.com,peterz@infradead.org,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mbenes@suse.cz,mark.rutland@arm.com,luto@kernel.org,kirill.shutemov@linux.intel.com,jpoimboe@kernel.org,johannes@sipsolutions.net,joe.lawrence@redhat.com,jikos@kernel.org,jason.wessel@windriver.com,hpa@zytor.com,dianders@chromium.org,davidgow@google.com,dave.hansen@linux.intel.com,danielt@kernel.org,da.gomez@samsung.com,brendan.higgins@linux.dev,bp@alien8.de,anton.ivanov@cambridgegreys.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox.patch added to mm-unstable branch
Message-Id: <20241231004232.167F6C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: modules: switch to execmem API for remapping as RW and restoring ROX
has been added to the -mm mm-unstable branch.  Its filename is
     modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox.patch

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
Subject: modules: switch to execmem API for remapping as RW and restoring ROX
Date: Fri, 27 Dec 2024 09:28:23 +0200

Instead of using writable copy for module text sections, temporarily remap
the memory allocated from execmem's ROX cache as writable and restore its
ROX permissions after the module is formed.

This will allow removing nasty games with writable copy in alternatives
patching on x86.

Link: https://lkml.kernel.org/r/20241227072825.1288491-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Daniel Thompson <danielt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Gow <davidgow@google.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h       |    7 ---
 include/linux/moduleloader.h |    4 -
 kernel/module/main.c         |   67 +++++----------------------------
 kernel/module/strict_rwx.c   |    9 ++--
 4 files changed, 17 insertions(+), 70 deletions(-)

--- a/include/linux/module.h~modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox
+++ a/include/linux/module.h
@@ -368,7 +368,6 @@ enum mod_mem_type {
 
 struct module_memory {
 	void *base;
-	void *rw_copy;
 	bool is_rox;
 	unsigned int size;
 
@@ -775,13 +774,9 @@ static inline bool is_livepatch_module(s
 
 void set_module_sig_enforced(void);
 
-void *__module_writable_address(struct module *mod, void *loc);
-
 static inline void *module_writable_address(struct module *mod, void *loc)
 {
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_EXECMEM_ROX) || !mod)
-		return loc;
-	return __module_writable_address(mod, loc);
+	return loc;
 }
 
 #else /* !CONFIG_MODULES... */
--- a/include/linux/moduleloader.h~modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox
+++ a/include/linux/moduleloader.h
@@ -108,10 +108,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *mod);
 
-int module_post_finalize(const Elf_Ehdr *hdr,
-			 const Elf_Shdr *sechdrs,
-			 struct module *mod);
-
 #ifdef CONFIG_MODULES
 void flush_module_init_free_work(void);
 #else
--- a/kernel/module/main.c~modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox
+++ a/kernel/module/main.c
@@ -1221,18 +1221,6 @@ void __weak module_arch_freeing_init(str
 {
 }
 
-void *__module_writable_address(struct module *mod, void *loc)
-{
-	for_class_mod_mem_type(type, text) {
-		struct module_memory *mem = &mod->mem[type];
-
-		if (loc >= mem->base && loc < mem->base + mem->size)
-			return loc + (mem->rw_copy - mem->base);
-	}
-
-	return loc;
-}
-
 static int module_memory_alloc(struct module *mod, enum mod_mem_type type)
 {
 	unsigned int size = PAGE_ALIGN(mod->mem[type].size);
@@ -1250,21 +1238,15 @@ static int module_memory_alloc(struct mo
 	if (!ptr)
 		return -ENOMEM;
 
-	mod->mem[type].base = ptr;
-
 	if (execmem_is_rox(execmem_type)) {
-		ptr = vzalloc(size);
+		int err = execmem_make_temp_rw(ptr, size);
 
-		if (!ptr) {
-			execmem_free(mod->mem[type].base);
+		if (err) {
+			execmem_free(ptr);
 			return -ENOMEM;
 		}
 
-		mod->mem[type].rw_copy = ptr;
 		mod->mem[type].is_rox = true;
-	} else {
-		mod->mem[type].rw_copy = mod->mem[type].base;
-		memset(mod->mem[type].base, 0, size);
 	}
 
 	/*
@@ -1280,6 +1262,9 @@ static int module_memory_alloc(struct mo
 	 */
 	kmemleak_not_leak(ptr);
 
+	memset(ptr, 0, size);
+	mod->mem[type].base = ptr;
+
 	return 0;
 }
 
@@ -1287,8 +1272,8 @@ static void module_memory_free(struct mo
 {
 	struct module_memory *mem = &mod->mem[type];
 
-	if (mem->is_rox)
-		vfree(mem->rw_copy);
+	if (mod->state == MODULE_STATE_UNFORMED && mem->is_rox)
+		execmem_restore_rox(mem->base, mem->size);
 
 	execmem_free(mem->base);
 }
@@ -2561,7 +2546,6 @@ static int move_module(struct module *mo
 	for_each_mod_mem_type(type) {
 		if (!mod->mem[type].size) {
 			mod->mem[type].base = NULL;
-			mod->mem[type].rw_copy = NULL;
 			continue;
 		}
 
@@ -2578,7 +2562,6 @@ static int move_module(struct module *mo
 		void *dest;
 		Elf_Shdr *shdr = &info->sechdrs[i];
 		const char *sname;
-		unsigned long addr;
 
 		if (!(shdr->sh_flags & SHF_ALLOC))
 			continue;
@@ -2599,14 +2582,12 @@ static int move_module(struct module *mo
 				ret = PTR_ERR(dest);
 				goto out_err;
 			}
-			addr = (unsigned long)dest;
 			codetag_section_found = true;
 		} else {
 			enum mod_mem_type type = shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
 			unsigned long offset = shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK;
 
-			addr = (unsigned long)mod->mem[type].base + offset;
-			dest = mod->mem[type].rw_copy + offset;
+			dest = mod->mem[type].base + offset;
 		}
 
 		if (shdr->sh_type != SHT_NOBITS) {
@@ -2629,7 +2610,7 @@ static int move_module(struct module *mo
 		 * users of info can keep taking advantage and using the newly
 		 * minted official memory area.
 		 */
-		shdr->sh_addr = addr;
+		shdr->sh_addr = (unsigned long)dest;
 		pr_debug("\t0x%lx 0x%.8lx %s\n", (long)shdr->sh_addr,
 			 (long)shdr->sh_size, info->secstrings + shdr->sh_name);
 	}
@@ -2782,17 +2763,8 @@ int __weak module_finalize(const Elf_Ehd
 	return 0;
 }
 
-int __weak module_post_finalize(const Elf_Ehdr *hdr,
-				const Elf_Shdr *sechdrs,
-				struct module *me)
-{
-	return 0;
-}
-
 static int post_relocation(struct module *mod, const struct load_info *info)
 {
-	int ret;
-
 	/* Sort exception table now relocations are done. */
 	sort_extable(mod->extable, mod->extable + mod->num_exentries);
 
@@ -2804,24 +2776,7 @@ static int post_relocation(struct module
 	add_kallsyms(mod, info);
 
 	/* Arch-specific module finalizing. */
-	ret = module_finalize(info->hdr, info->sechdrs, mod);
-	if (ret)
-		return ret;
-
-	for_each_mod_mem_type(type) {
-		struct module_memory *mem = &mod->mem[type];
-
-		if (mem->is_rox) {
-			if (!execmem_update_copy(mem->base, mem->rw_copy,
-						 mem->size))
-				return -ENOMEM;
-
-			vfree(mem->rw_copy);
-			mem->rw_copy = NULL;
-		}
-	}
-
-	return module_post_finalize(info->hdr, info->sechdrs, mod);
+	return module_finalize(info->hdr, info->sechdrs, mod);
 }
 
 /* Call module constructors. */
--- a/kernel/module/strict_rwx.c~modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox
+++ a/kernel/module/strict_rwx.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/set_memory.h>
+#include <linux/execmem.h>
 #include "internal.h"
 
 static int module_set_memory(const struct module *mod, enum mod_mem_type type,
@@ -32,12 +33,12 @@ static int module_set_memory(const struc
 int module_enable_text_rox(const struct module *mod)
 {
 	for_class_mod_mem_type(type, text) {
+		const struct module_memory *mem = &mod->mem[type];
 		int ret;
 
-		if (mod->mem[type].is_rox)
-			continue;
-
-		if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
+		if (mem->is_rox)
+			ret = execmem_restore_rox(mem->base, mem->size);
+		else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
 			ret = module_set_memory(mod, type, set_memory_rox);
 		else
 			ret = module_set_memory(mod, type, set_memory_x);
_

Patches currently in -mm which might be from rppt@kernel.org are

x86-mm-pat-cpa-test-fix-length-for-cpa_array-test.patch
x86-mm-pat-drop-duplicate-variable-in-cpa_flush.patch
execmem-add-api-for-temporal-remapping-as-rw-and-restoring-rox-afterwards.patch
module-introduce-module_state_gone.patch
modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox.patch
revert-x86-module-prepare-module-loading-for-rox-allocations-of-text.patch
module-drop-unused-module_writable_address.patch

