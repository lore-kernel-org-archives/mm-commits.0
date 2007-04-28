From: akpm@linux-foundation.org
Subject: - avr32-remove-unneeded-cast-in-atomich.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:50:41 -0700
Message-ID: <200704281050.l3SAof1d019950@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965638AbXD1KvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     avr32: remove unneeded cast in atomic.h
has been removed from the -mm tree.  Its filename was
     avr32-remove-unneeded-cast-in-atomich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: avr32: remove unneeded cast in atomic.h
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This int cast is superfluous since system.h cmpxchg already casts it in
(typeof(*(ptr))).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-avr32/atomic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-avr32/atomic.h~avr32-remove-unneeded-cast-in-atomich include/asm-avr32/atomic.h
--- a/include/asm-avr32/atomic.h~avr32-remove-unneeded-cast-in-atomich
+++ a/include/asm-avr32/atomic.h
@@ -173,7 +173,7 @@ static inline int atomic_sub_if_positive
 }
 
 #define atomic_xchg(v, new)	(xchg(&((v)->counter), new))
-#define atomic_cmpxchg(v, o, n)	((int)cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_cmpxchg(v, o, n)	(cmpxchg(&((v)->counter), (o), (n)))
 
 #define atomic_sub(i, v)	(void)atomic_sub_return(i, v)
 #define atomic_add(i, v)	(void)atomic_add_return(i, v)
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
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
linux-kernel-markers-documentation-fix-typo-and-use-array_size.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
