From: akpm@linux-foundation.org
Subject: + sh-dma-use-__attribute_unused__.patch added to -mm tree
Date: Fri, 04 May 2007 02:09:18 -0700
Message-ID: <200705040909.l4499IcC000542@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767753AbXEDJJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 05:09:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, lethal@linux-sh.org


The patch titled
     sh: dma: use __attribute_unused__
has been added to the -mm tree.  Its filename is
     sh-dma-use-__attribute_unused__.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sh: dma: use __attribute_unused__
From: David Rientjes <rientjes@google.com>

There is no such thing as labeling a variable as __attribute__((used)).  Since
ts_shift is not referenced in inline assembly, we assume that we're simply
suppressing a warning here if the variable is declared but unreferenced.

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sh/cpu-sh3/dma.h        |    2 +-
 include/asm-sh/cpu-sh4/dma-sh7780.h |    2 +-
 include/asm-sh/cpu-sh4/dma.h        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-sh/cpu-sh3/dma.h~sh-dma-use-__attribute_unused__ include/asm-sh/cpu-sh3/dma.h
--- a/include/asm-sh/cpu-sh3/dma.h~sh-dma-use-__attribute_unused__
+++ a/include/asm-sh/cpu-sh3/dma.h
@@ -26,7 +26,7 @@ enum {
 	XMIT_SZ_128BIT,
 };
 
-static unsigned int ts_shift[] __attribute__ ((used)) = {
+static unsigned int ts_shift[] __attribute_unused__ = {
 	[XMIT_SZ_8BIT]		= 0,
 	[XMIT_SZ_16BIT]		= 1,
 	[XMIT_SZ_32BIT]		= 2,
diff -puN include/asm-sh/cpu-sh4/dma-sh7780.h~sh-dma-use-__attribute_unused__ include/asm-sh/cpu-sh4/dma-sh7780.h
--- a/include/asm-sh/cpu-sh4/dma-sh7780.h~sh-dma-use-__attribute_unused__
+++ a/include/asm-sh/cpu-sh4/dma-sh7780.h
@@ -28,7 +28,7 @@ enum {
 /*
  * The DMA count is defined as the number of bytes to transfer.
  */
-static unsigned int __attribute__ ((used)) ts_shift[] = {
+static unsigned int ts_shift[] __attribute_unused__ = {
 	[XMIT_SZ_8BIT]		= 0,
 	[XMIT_SZ_16BIT]		= 1,
 	[XMIT_SZ_32BIT]		= 2,
diff -puN include/asm-sh/cpu-sh4/dma.h~sh-dma-use-__attribute_unused__ include/asm-sh/cpu-sh4/dma.h
--- a/include/asm-sh/cpu-sh4/dma.h~sh-dma-use-__attribute_unused__
+++ a/include/asm-sh/cpu-sh4/dma.h
@@ -53,7 +53,7 @@ enum {
 /*
  * The DMA count is defined as the number of bytes to transfer.
  */
-static unsigned int ts_shift[] __attribute__ ((used)) = {
+static unsigned int ts_shift[] __attribute_unused__ = {
 	[XMIT_SZ_64BIT]		= 3,
 	[XMIT_SZ_8BIT]		= 0,
 	[XMIT_SZ_16BIT]		= 1,
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
