From: akpm@linux-foundation.org
Subject: + local_t-mips-extension-fix.patch added to -mm tree
Date: Thu, 15 Feb 2007 17:17:52 -0800
Message-ID: <200702160117.l1G1Hqmg015252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42114 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbXBPBVP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:21:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ralf@linux-mips.org


The patch titled
     Fix macro error in MIPS local.h
has been added to the -mm tree.  Its filename is
     local_t-mips-extension-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix macro error in MIPS local.h
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This error breaks the MIPS build. () within macro parameters are not
good.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/local.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-mips/local.h~local_t-mips-extension-fix include/asm-mips/local.h
--- a/include/asm-mips/local.h~local_t-mips-extension-fix
+++ a/include/asm-mips/local.h
@@ -411,7 +411,7 @@ static __inline__ long local_sub_if_posi
 
 #define local_cmpxchg(l, o, n) \
 	((long)cmpxchg_local(&((l)->a.counter), (o), (n)))
-#define local_xchg(l, (n)) (xchg_local(&((l)->a.counter),(n)))
+#define local_xchg(l, n) (xchg_local(&((l)->a.counter),(n)))
 
 /**
  * local_add_unless - add unless the number is a given value
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
powerpc-move-of_irq_to_resource-to-prom_parsec.patch
git-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64_xchg-to-s390.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-powerpc-extension-fix.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
