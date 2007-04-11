From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-architecture-independant-code-markers-add-documentation-to-the-modulec-marker-functions.patch added to -mm tree
Date: Tue, 10 Apr 2007 22:06:09 -0700
Message-ID: <200704110506.l3B569LX028966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59260 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161186AbXDKFGV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 01:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     markers: add documentation to the module.c marker functions
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-architecture-independant-code-markers-add-documentation-to-the-modulec-marker-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: markers: add documentation to the module.c marker functions
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Update them to follow the flags modifications.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |  114 +++++++++++++++++++++++++++++++---------------
 1 file changed, 78 insertions(+), 36 deletions(-)

diff -puN kernel/module.c~linux-kernel-markers-architecture-independant-code-markers-add-documentation-to-the-modulec-marker-functions kernel/module.c
--- a/kernel/module.c~linux-kernel-markers-architecture-independant-code-markers-add-documentation-to-the-modulec-marker-functions
+++ a/kernel/module.c
@@ -303,24 +303,36 @@ static struct module *find_module(const 
 }
 
 #ifdef CONFIG_MARKERS
-void __mark_empty_function(const char *fmt, ...)
+
+/* Empty callback provided as a probe to the markers. By providing this to a
+ * disabled marker, we makes sure the  execution flow is always valid even
+ * though the function pointer change and the marker enabling are two distinct
+ * operations that modifies the execution flow of preemptible code. */
+void __mark_empty_function(const struct __mark_marker_data *mdata,
+	const char *fmt, ...)
 {
 }
 EXPORT_SYMBOL_GPL(__mark_empty_function);
 
+/* Set the enable bit of the marker, choosing the generic or architecture
+ * specific functions depending on the marker's flags.
+ */
 static int marker_set_enable(void *address, char enable, int flags)
 {
-	if (flags & _MF_OPTIMIZED)
+	if (flags & MF_OPTIMIZED)
 		return marker_optimized_set_enable(address, enable);
 	else
 		return marker_generic_set_enable(address, enable);
 }
 
-/* enable and function address are set out of order, and it's ok :
- * the state is always coherent. */
+/* Sets the probe callback and enables the markers corresponding to a range of
+ * markers. The enable bit and function address are set out of order, and it's
+ * ok : the state is always coherent because of the empty callback we provide.
+ */
 static int _marker_set_probe_range(int flags, const char *name,
 	const char *format,
 	marker_probe_func *probe,
+	void *pdata,
 	const struct __mark_marker *begin,
 	const struct __mark_marker *end)
 {
@@ -328,27 +340,27 @@ static int _marker_set_probe_range(int f
 	int found = 0;
 
 	for (iter = begin; iter < end; iter++) {
-		if (strcmp(name, iter->cmark->name) == 0) {
+		if (strcmp(name, iter->mdata->name) == 0) {
 			if (format
-				&& strcmp(format, iter->cmark->format) != 0) {
+				&& strcmp(format, iter->mdata->format) != 0) {
 				printk(KERN_NOTICE
 					"Format mismatch for probe %s "
 					"(%s), marker (%s)\n",
 					name,
 					format,
-					iter->cmark->format);
+					iter->mdata->format);
 				continue;
 			}
-			if (flags & _MF_LOCKDEP
-				&& !(iter->cmark->flags & _MF_LOCKDEP)) {
+			if (flags & MF_LOCKDEP
+				&& !(iter->mdata->flags & MF_LOCKDEP)) {
 					printk(KERN_NOTICE
 					"Incompatible lockdep flags for "
 					"probe %s\n",
 					name);
 					continue;
 			}
-			if (flags & _MF_PRINTK
-				&& !(iter->cmark->flags & _MF_PRINTK)) {
+			if (flags & MF_PRINTK
+				&& !(iter->mdata->flags & MF_PRINTK)) {
 					printk(KERN_NOTICE
 					"Incompatible printk flags for "
 					"probe %s\n",
@@ -356,32 +368,33 @@ static int _marker_set_probe_range(int f
 					continue;
 			}
 			if (probe == __mark_empty_function) {
-				if (*iter->cmark->call
+				if (iter->mdata->call
 					!= __mark_empty_function) {
-					*iter->cmark->call =
+					iter->mdata->call =
 						__mark_empty_function;
 				}
 				marker_set_enable(iter->enable, 0,
-					iter->cmark->flags);
+					iter->mdata->flags);
 			} else {
-				if (*iter->cmark->call
+				if (iter->mdata->call
 					!= __mark_empty_function) {
-					if (*iter->cmark->call != probe) {
+					if (iter->mdata->call != probe) {
 						printk(KERN_NOTICE
 							"Marker %s busy, "
 							"probe %p already "
 							"installed\n",
 							name,
-							*iter->cmark->call);
+							iter->mdata->call);
 						continue;
 					}
 				} else {
 					found++;
-					*iter->cmark->call = probe;
+					iter->mdata->call = probe;
 				}
-				/* Can have many enables for one function */
+				iter->mdata->pdata = pdata;
+				smp_wmb();
 				marker_set_enable(iter->enable, 1,
-					iter->cmark->flags);
+					iter->mdata->flags);
 			}
 			found++;
 		}
@@ -389,7 +402,9 @@ static int _marker_set_probe_range(int f
 	return found;
 }
 
-static int marker_remove_probe_range(marker_probe_func *probe,
+/* Sets a range of markers to a disabled state : unset the enable bit and
+ * provide the empty callback. */
+static int marker_remove_probe_range(const char *name,
 	const struct __mark_marker *begin,
 	const struct __mark_marker *end)
 {
@@ -397,16 +412,19 @@ static int marker_remove_probe_range(mar
 	int found = 0;
 
 	for (iter = begin; iter < end; iter++) {
-		if (*iter->cmark->call == probe) {
+		if (strcmp(name, iter->mdata->name) == 0) {
 			marker_set_enable(iter->enable, 0,
-				iter->cmark->flags);
-			*iter->cmark->call = __mark_empty_function;
+				iter->mdata->flags);
+			iter->mdata->call = __mark_empty_function;
 			found++;
 		}
 	}
 	return found;
 }
 
+/* Provides a listing of the markers present in the kernel with their type
+ * (optimized or generic), state (enabled or disabled), callback and format
+ * string. */
 static int marker_list_probe_range(marker_probe_func *probe,
 	const struct __mark_marker *begin,
 	const struct __mark_marker *end)
@@ -416,23 +434,26 @@ static int marker_list_probe_range(marke
 
 	for (iter = begin; iter < end; iter++) {
 		if (probe)
-			if (probe != *iter->cmark->call) continue;
-		printk("name %s \n", iter->cmark->name);
-		if (iter->cmark->flags & _MF_OPTIMIZED)
+			if (probe != iter->mdata->call) continue;
+		printk("name %s \n", iter->mdata->name);
+		if (iter->mdata->flags & MF_OPTIMIZED)
 			printk("  enable %u optimized ",
 				MARK_OPTIMIZED_ENABLE(iter->enable));
 		else
 			printk("  enable %u generic ",
 				MARK_GENERIC_ENABLE(iter->enable));
 		printk("  func 0x%p format \"%s\"\n",
-			*iter->cmark->call, iter->cmark->format);
+			iter->mdata->call, iter->mdata->format);
 		found++;
 	}
 	return found;
 }
-/* markers use the modlist_lock to to synchronise */
+
+/* Calls _marker_set_probe_range for the core markers and modules markers.
+ * Marker enabling/disabling use the modlist_lock to synchronise. */
 int _marker_set_probe(int flags, const char *name, const char *format,
-				marker_probe_func *probe)
+				marker_probe_func *probe,
+				void *pdata)
 {
 	struct module *mod;
 	int found = 0;
@@ -440,31 +461,35 @@ int _marker_set_probe(int flags, const c
 	mutex_lock(&module_mutex);
 	/* Core kernel markers */
 	found += _marker_set_probe_range(flags, name, format, probe,
+			pdata,
 			__start___markers, __stop___markers);
 	/* Markers in modules. */
 	list_for_each_entry(mod, &modules, list) {
 		if (!mod->taints)
 			found += _marker_set_probe_range(flags, name, format,
-			probe, mod->markers, mod->markers+mod->num_markers);
+			probe, pdata,
+			mod->markers, mod->markers+mod->num_markers);
 	}
 	mutex_unlock(&module_mutex);
 	return found;
 }
 EXPORT_SYMBOL_GPL(_marker_set_probe);
 
-int marker_remove_probe(marker_probe_func *probe)
+/* Calls _marker_remove_probe_range for the core markers and modules markers.
+ * Marker enabling/disabling use the modlist_lock to synchronise. */
+int marker_remove_probe(const char *name)
 {
 	struct module *mod;
 	int found = 0;
 
 	mutex_lock(&module_mutex);
 	/* Core kernel markers */
-	found += marker_remove_probe_range(probe,
+	found += marker_remove_probe_range(name,
 			__start___markers, __stop___markers);
 	/* Markers in modules. */
 	list_for_each_entry(mod, &modules, list) {
 		if (!mod->taints)
-			found += marker_remove_probe_range(probe,
+			found += marker_remove_probe_range(name,
 				mod->markers, mod->markers+mod->num_markers);
 	}
 	mutex_unlock(&module_mutex);
@@ -472,6 +497,9 @@ int marker_remove_probe(marker_probe_fun
 }
 EXPORT_SYMBOL_GPL(marker_remove_probe);
 
+/* Calls _marker_list_probe_range for the core markers and modules markers.
+ * Marker listing uses the modlist_lock to synchronise.
+ * TODO : should output this listing to a procfs file. */
 int marker_list_probe(marker_probe_func *probe)
 {
 	struct module *mod;
@@ -1853,6 +1881,8 @@ static struct module *load_module(void _
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
 	unsigned int markersindex;
+	unsigned int markersdataindex;
+	unsigned int markersstringsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1949,7 +1979,10 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
-	markersindex = find_sec(hdr, sechdrs, secstrings, ".markers");
+	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
+	markersdataindex = find_sec(hdr, sechdrs, secstrings, "__markers_data");
+	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
+				"__markers_strings");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1963,9 +1996,18 @@ static struct module *load_module(void _
 #ifdef CONFIG_MARKERS
 	if (markersindex)
 		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
+	if (markersdataindex)
+		sechdrs[markersdataindex].sh_flags |= SHF_ALLOC;
+	if (markersstringsindex)
+		sechdrs[markersstringsindex].sh_flags |= SHF_ALLOC;
 #else
 	if (markersindex)
 		sechdrs[markersindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	if (markersdataindex)
+		sechdrs[markersdataindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	if (markersstringsindex)
+		sechdrs[markersstringsindex].sh_flags
+					&= ~(unsigned long)SHF_ALLOC;
 #endif
 
 	/* Check module struct version now, before we try to use module. */
@@ -2619,7 +2661,7 @@ void list_modules(void)
 #ifdef CONFIG_MODULE_UNLOAD
 		refcount = local_read(&mod->ref[0].count);
 #endif //CONFIG_MODULE_UNLOAD
-		MARK(list_modules, "%s %d[enum module_state] %lu",
+		MARK(list_module, "%s %d %lu",
 				mod->name, mod->state, refcount);
 	}
 	mutex_unlock(&module_mutex);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

avr32-remove-unneeded-cast-in-atomich.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-markers-document-the-linux-markerh-header.patch
linux-kernel-markers-architecture-independant-code-markers-add-documentation-to-the-modulec-marker-functions.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-markers-changes-to-the-powerpc-marker-header.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-markers-document-the-i386-marker-header.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-markers-update-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
