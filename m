From: akpm@linux-foundation.org
Subject: - sh-dma-use-__maybe_unused.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:34 -0700
Message-ID: <200705092154.l49LsY2Z003175@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754763AbXEIVzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sh: dma: use __maybe_unused
has been removed from the -mm tree.  Its filename was
     sh-dma-use-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sh: dma: use __maybe_unused
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

diff -puN include/asm-sh/cpu-sh3/dma.h~sh-dma-use-__maybe_unused include/asm-sh/cpu-sh3/dma.h
--- a/include/asm-sh/cpu-sh3/dma.h~sh-dma-use-__maybe_unused
+++ a/include/asm-sh/cpu-sh3/dma.h
@@ -26,7 +26,7 @@ enum {
 	XMIT_SZ_128BIT,
 };
 
-static unsigned int ts_shift[] __attribute__ ((used)) = {
+static unsigned int ts_shift[] __maybe_unused = {
 	[XMIT_SZ_8BIT]		= 0,
 	[XMIT_SZ_16BIT]		= 1,
 	[XMIT_SZ_32BIT]		= 2,
diff -puN include/asm-sh/cpu-sh4/dma-sh7780.h~sh-dma-use-__maybe_unused include/asm-sh/cpu-sh4/dma-sh7780.h
--- a/include/asm-sh/cpu-sh4/dma-sh7780.h~sh-dma-use-__maybe_unused
+++ a/include/asm-sh/cpu-sh4/dma-sh7780.h
@@ -28,7 +28,7 @@ enum {
 /*
  * The DMA count is defined as the number of bytes to transfer.
  */
-static unsigned int __attribute__ ((used)) ts_shift[] = {
+static unsigned int ts_shift[] __maybe_unused = {
 	[XMIT_SZ_8BIT]		= 0,
 	[XMIT_SZ_16BIT]		= 1,
 	[XMIT_SZ_32BIT]		= 2,
diff -puN include/asm-sh/cpu-sh4/dma.h~sh-dma-use-__maybe_unused include/asm-sh/cpu-sh4/dma.h
--- a/include/asm-sh/cpu-sh4/dma.h~sh-dma-use-__maybe_unused
+++ a/include/asm-sh/cpu-sh4/dma.h
@@ -53,7 +53,7 @@ enum {
 /*
  * The DMA count is defined as the number of bytes to transfer.
  */
-static unsigned int ts_shift[] __attribute__ ((used)) = {
+static unsigned int ts_shift[] __maybe_unused = {
 	[XMIT_SZ_64BIT]		= 3,
 	[XMIT_SZ_8BIT]		= 0,
 	[XMIT_SZ_16BIT]		= 1,
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
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
frv-gdb-use-__maybe_unused.patch
