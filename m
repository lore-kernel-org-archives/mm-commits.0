From: akpm@osdl.org
Subject: + local_t-s390-cleanup.patch added to -mm tree
Date: Thu, 25 Jan 2007 21:47:42 -0800
Message-ID: <200701260547.l0Q5lg8v008656@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46768 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030780AbXAZFrx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 00:47:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     local_t: s390 cleanup
has been added to the -mm tree.  Its filename is
     local_t-s390-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: local_t: s390 cleanup
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

s390 architecture local_t cleanup: use asm-generic/local.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-s390/local.h |   59 -------------------------------------
 1 file changed, 1 insertion(+), 58 deletions(-)

diff -puN include/asm-s390/local.h~local_t-s390-cleanup include/asm-s390/local.h
--- a/include/asm-s390/local.h~local_t-s390-cleanup
+++ a/include/asm-s390/local.h
@@ -1,58 +1 @@
-#ifndef _ASM_LOCAL_H
-#define _ASM_LOCAL_H
-
-#include <linux/percpu.h>
-#include <asm/atomic.h>
-
-#ifndef __s390x__
-
-typedef atomic_t local_t;
-
-#define LOCAL_INIT(i)	ATOMIC_INIT(i)
-#define local_read(v)	atomic_read(v)
-#define local_set(v,i)	atomic_set(v,i)
-
-#define local_inc(v)	atomic_inc(v)
-#define local_dec(v)	atomic_dec(v)
-#define local_add(i, v)	atomic_add(i, v)
-#define local_sub(i, v)	atomic_sub(i, v)
-
-#else
-
-typedef atomic64_t local_t;
-
-#define LOCAL_INIT(i)	ATOMIC64_INIT(i)
-#define local_read(v)	atomic64_read(v)
-#define local_set(v,i)	atomic64_set(v,i)
-
-#define local_inc(v)	atomic64_inc(v)
-#define local_dec(v)	atomic64_dec(v)
-#define local_add(i, v)	atomic64_add(i, v)
-#define local_sub(i, v)	atomic64_sub(i, v)
-
-#endif
-
-#define __local_inc(v)		((v)->counter++)
-#define __local_dec(v)		((v)->counter--)
-#define __local_add(i,v)	((v)->counter+=(i))
-#define __local_sub(i,v)	((v)->counter-=(i))
-
-/*
- * Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-#define cpu_local_read(v)	local_read(&__get_cpu_var(v))
-#define cpu_local_set(v, i)	local_set(&__get_cpu_var(v), (i))
-
-#define cpu_local_inc(v)	local_inc(&__get_cpu_var(v))
-#define cpu_local_dec(v)	local_dec(&__get_cpu_var(v))
-#define cpu_local_add(i, v)	local_add((i), &__get_cpu_var(v))
-#define cpu_local_sub(i, v)	local_sub((i), &__get_cpu_var(v))
-
-#define __cpu_local_inc(v)	__local_inc(&__get_cpu_var(v))
-#define __cpu_local_dec(v)	__local_dec(&__get_cpu_var(v))
-#define __cpu_local_add(i, v)	__local_add((i), &__get_cpu_var(v))
-#define __cpu_local_sub(i, v)	__local_sub((i), &__get_cpu_var(v))
-
-#endif /* _ASM_LOCAL_H */
+#include <asm-generic/local.h>
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-complete-atomic_long-operations-in-asm-generic-fix.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
local_t-architecture-independent-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
