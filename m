From: akpm@linux-foundation.org
Subject: - atomich-add-atomic64_xchg-to-s390.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:03:10 -0800
Message-ID: <200702160803.l1G83AP5023983@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58817 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423402AbXBPIDX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:03:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     atomic.h: add atomic64_xchg to s390
has been removed from the -mm tree.  Its filename was
     atomich-add-atomic64_xchg-to-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atomic.h: add atomic64_xchg to s390
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-s390/atomic.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-s390/atomic.h~atomich-add-atomic64_xchg-to-s390 include/asm-s390/atomic.h
--- a/include/asm-s390/atomic.h~atomich-add-atomic64_xchg-to-s390
+++ a/include/asm-s390/atomic.h
@@ -215,6 +215,8 @@ static __inline__ void atomic64_set_mask
 	       __CSG_LOOP(v, mask, "ogr");
 }
 
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
 static __inline__ long long atomic64_cmpxchg(atomic64_t *v,
 					     long long old, long long new)
 {
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-powerpc.patch
powerpc-move-of_irq_to_resource-to-prom_parsec.patch
git-mips.patch
git-s390.patch
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
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-powerpc-extension-fix.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
