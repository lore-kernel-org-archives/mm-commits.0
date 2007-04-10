From: akpm@linux-foundation.org
Subject: + avr32-remove-unneeded-cast-in-atomich.patch added to -mm tree
Date: Tue, 10 Apr 2007 16:32:20 -0700
Message-ID: <200704102332.l3ANWKwC023052@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51779 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbXDJXca (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 19:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, hskinnemoen@atmel.com


The patch titled
     avr32: remove unneeded cast in atomic.h
has been added to the -mm tree.  Its filename is
     avr32-remove-unneeded-cast-in-atomich.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

avr32-remove-unneeded-cast-in-atomich.patch
git-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
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
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
