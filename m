From: akpm@linux-foundation.org
Subject: - compiler-define-__attribute_unused__.patch removed from -mm tree
Date: Fri, 04 May 2007 14:54:24 -0700
Message-ID: <200705042154.l44LsP6u018293@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031707AbXEDVyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 17:54:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     compiler: define __attribute_unused__
has been removed from the -mm tree.  Its filename was
     compiler-define-__attribute_unused__.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: compiler: define __attribute_unused__
From: David Rientjes <rientjes@google.com>

For all supported versions of gcc (major version 3 and above), functions and
variables may be declared with __attribute__((unused)) to suppress warnings if
they are declared but unused.

This shouldn't be confused with functions being declared with
__attribute__((used)).  This specifies that the function code shall still be
emitted even if it appears to be unreferenced, normally used if embedded in
inline assembly.  For gcc 3.4 and later, unreferenced static variables and
functions are not emitted so this attribute is necessary to force variables
and functions to be output.  Earlier versions of gcc can simply use
__attribute__((unused)) to suppress warnings about such variables: we do not
require any special classification to ensure they are emitted.

We introduce __attribute_unused__ for variables that should not produce a
compile warning if they can, due to preprocessor macros, go unreferenced.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/linux/compiler-gcc.h~compiler-define-__attribute_unused__ include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-define-__attribute_unused__
+++ a/include/linux/compiler-gcc.h
@@ -40,3 +40,19 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_pure__		__attribute__((pure))
 #define __attribute_const__		__attribute__((__const__))
+
+/*
+ * __attribute_unused__ shall be used for functions or variables to suppress
+ * warnings when they may be declared but, due to preprocessor macros,
+ * commenting, etc., go unreferenced.
+ *
+ * In contrast, __attribute_used__ shall be used only for functions.  gcc <3.4
+ * emits code for static functions that are unreferenced and outputs a warning.
+ * __attribute_used__ will correctly suppress this warning.  gcc >=3.4 does not
+ * emit code for static functions that are unreferenced (and thus there is no
+ * warning), but __attribute_used__ forces the function code to be output.  Use
+ * __attribute_unused__ to suppress warnings about functions being unused or
+ * __attribute_used__ to ensure code is emitted when it is referenced only in
+ * inline assembly.
+ */
+#define __attribute_unused__		__attribute__((unused))
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
oom-fix-constraint-deadlock.patch
wavefront-only-declare-isapnp-on-config_pnp.patch
git-cpufreq.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-define-__attribute_unused__.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__attribute_unused__.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__attribute_unused__.patch
i386-voyager-use-__attribute_unused__.patch
mips-excite-use-__attribute_unused__.patch
mips-tlbex-use-__attribute_unused__.patch
powerpc-ps3-use-__attribute_unused__.patch
i386-mmzone-use-__attribute_unused__.patch
