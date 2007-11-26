From: akpm@linux-foundation.org
Subject: + modules-handle-symbols-that-have-a-zero-value.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:44:29 -0800
Message-ID: <200711262344.lAQNiTSL029246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756492AbXKZXov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:44:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, kay.sievers@vrfy.org, mathieu.desnoyers@polymtl.ca, rusty@rustcorp.com.au


The patch titled
     Modules: handle symbols that have a zero value
has been added to the -mm tree.  Its filename is
     modules-handle-symbols-that-have-a-zero-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Modules: handle symbols that have a zero value
From: Christoph Lameter <clameter@sgi.com>

The module subsystem cannot handle symbols that are zero.  If symbols are
present that have a zero value then the module resolver prints out a
message that these symbols are unresolved.

Use ERR_PTR to return an error code instead of 0.  This is a bit awkward
since the addresses are handled as unsigned longs.  So we need to convert
them everywhere.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN kernel/module.c~modules-handle-symbols-that-have-a-zero-value kernel/module.c
--- a/kernel/module.c~modules-handle-symbols-that-have-a-zero-value
+++ a/kernel/module.c
@@ -283,7 +283,7 @@ static unsigned long __find_symbol(const
 		}
 	}
 	DEBUGP("Failed to find symbol %s\n", name);
-	return 0;
+	return -ENOENT;
 }
 
 /* Search for module by name: must hold module_mutex. */
@@ -754,7 +754,7 @@ void __symbol_put(const char *symbol)
 	const unsigned long *crc;
 
 	preempt_disable();
-	if (!__find_symbol(symbol, &owner, &crc, 1))
+	if (IS_ERR_VALUE(__find_symbol(symbol, &owner, &crc, 1)))
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -900,7 +900,8 @@ static inline int check_modstruct_versio
 	const unsigned long *crc;
 	struct module *owner;
 
-	if (!__find_symbol("struct_module", &owner, &crc, 1))
+	if (IS_ERR_VALUE(__find_symbol("struct_module",
+						&owner, &crc, 1)))
 		BUG();
 	return check_version(sechdrs, versindex, "struct_module", mod,
 			     crc);
@@ -953,7 +954,7 @@ static unsigned long resolve_symbol(Elf_
 		/* use_module can fail due to OOM, or module unloading */
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
 		    !use_module(mod, owner))
-			ret = 0;
+			ret = -EINVAL;
 	}
 	return ret;
 }
@@ -1349,14 +1350,16 @@ static int verify_export_symbols(struct 
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
@@ -1406,7 +1409,7 @@ static int simplify_symbols(Elf_Shdr *se
 					   strtab + sym[i].st_name, mod);
 
 			/* Ok if resolved.  */
-			if (sym[i].st_value != 0)
+			if (!IS_ERR_VALUE(sym[i].st_value))
 				break;
 			/* Ok if weak.  */
 			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
_

Patches currently in -mm which might be from clameter@sgi.com are

ia64-slim-down-__clear_bit_unlock.patch
git-s390.patch
git-unionfs.patch
git-x86.patch
acpi-avoid-references-to-impossible-processors.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-fix.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
modules-handle-symbols-that-have-a-zero-value.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
