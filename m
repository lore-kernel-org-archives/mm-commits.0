From: akpm@linux-foundation.org
Subject: + atomich-add-atomic64_xchg-to-s390.patch added to -mm tree
Date: Wed, 14 Feb 2007 23:06:12 -0800
Message-ID: <200702150706.l1F76C0r022528@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37293 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964930AbXBOHG0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 02:06:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     atomic.h: add atomic64_xchg to s390
has been added to the -mm tree.  Its filename is
     atomich-add-atomic64_xchg-to-s390.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
