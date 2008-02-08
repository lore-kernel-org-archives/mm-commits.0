From: akpm@linux-foundation.org
Subject: - modules-handle-symbols-that-have-a-zero-value.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:25 -0800
Message-ID: <200802082012.m18KC6fB010173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758584AbYBHVDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, akinobu.mita@gmail.com, kay.sievers@vrfy.org, mathieu.desnoyers@polymtl.ca, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Modules: handle symbols that have a zero value
has been removed from the -mm tree.  Its filename was
     modules-handle-symbols-that-have-a-zero-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Modules: handle symbols that have a zero value
From: Christoph Lameter <clameter@sgi.com>

The module subsystem cannot handle symbols that are zero.  If symbols are
present that have a zero value then the module resolver prints out a
message that these symbols are unresolved.

[akinobu.mita@gmail.com: fix __find_symbl() error checks]
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN kernel/module.c~modules-handle-symbols-that-have-a-zero-value kernel/module.c
--- a/kernel/module.c~modules-handle-symbols-that-have-a-zero-value
+++ a/kernel/module.c
@@ -290,7 +290,7 @@ static unsigned long __find_symbol(const
 		}
 	}
 	DEBUGP("Failed to find symbol %s\n", name);
-	return 0;
+	return -ENOENT;
 }
 
 /* Search for module by name: must hold module_mutex. */
@@ -783,7 +783,7 @@ void __symbol_put(const char *symbol)
 	const unsigned long *crc;
 
 	preempt_disable();
-	if (!__find_symbol(symbol, &owner, &crc, 1))
+	if (IS_ERR_VALUE(__find_symbol(symbol, &owner, &crc, 1)))
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -929,7 +929,8 @@ static inline int check_modstruct_versio
 	const unsigned long *crc;
 	struct module *owner;
 
-	if (!__find_symbol("struct_module", &owner, &crc, 1))
+	if (IS_ERR_VALUE(__find_symbol("struct_module",
+						&owner, &crc, 1)))
 		BUG();
 	return check_version(sechdrs, versindex, "struct_module", mod,
 			     crc);
@@ -978,12 +979,12 @@ static unsigned long resolve_symbol(Elf_
 
 	ret = __find_symbol(name, &owner, &crc,
 			!(mod->taints & TAINT_PROPRIETARY_MODULE));
-	if (ret) {
+	if (!IS_ERR_VALUE(ret)) {
 		/* use_module can fail due to OOM,
 		   or module initialization or unloading */
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
 		    !use_module(mod, owner))
-			ret = 0;
+			ret = -EINVAL;
 	}
 	return ret;
 }
@@ -1371,7 +1372,9 @@ void *__symbol_get(const char *symbol)
 
 	preempt_disable();
 	value = __find_symbol(symbol, &owner, &crc, 1);
-	if (value && strong_try_module_get(owner) != 0)
+	if (IS_ERR_VALUE(value))
+		value = 0;
+	else if (strong_try_module_get(owner))
 		value = 0;
 	preempt_enable();
 
@@ -1391,14 +1394,16 @@ static int verify_export_symbols(struct 
 	const unsigned long *crc;
 
 	for (i = 0; i < mod->num_syms; i++)
-		if (__find_symbol(mod->syms[i].name, &owner, &crc, 1)) {
+		if (!IS_ERR_VALUE(__find_symbol(mod->syms[i].name,
+							&owner, &crc, 1))) {
 			name = mod->syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
 		}
 
 	for (i = 0; i < mod->num_gpl_syms; i++)
-		if (__find_symbol(mod->gpl_syms[i].name, &owner, &crc, 1)) {
+		if (!IS_ERR_VALUE(__find_symbol(mod->gpl_syms[i].name,
+							&owner, &crc, 1))) {
 			name = mod->gpl_syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
@@ -1448,7 +1453,7 @@ static int simplify_symbols(Elf_Shdr *se
 					   strtab + sym[i].st_name, mod);
 
 			/* Ok if resolved.  */
-			if (sym[i].st_value != 0)
+			if (!IS_ERR_VALUE(sym[i].st_value))
 				break;
 			/* Ok if weak.  */
 			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
