From: akpm@linux-foundation.org
Subject: + local_t-ia64-extension.patch added to -mm tree
Date: Wed, 14 Feb 2007 23:06:26 -0800
Message-ID: <200702150706.l1F76Qwp022546@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37312 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964938AbXBOHGd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 02:06:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, tony.luck@intel.com


The patch titled
     local_t: ia64 extension
has been added to the -mm tree.  Its filename is
     local_t-ia64-extension.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: local_t: ia64 extension
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/local.h |   51 -------------------------------------
 1 file changed, 1 insertion(+), 50 deletions(-)

diff -puN include/asm-ia64/local.h~local_t-ia64-extension include/asm-ia64/local.h
--- a/include/asm-ia64/local.h~local_t-ia64-extension
+++ a/include/asm-ia64/local.h
@@ -1,50 +1 @@
-#ifndef _ASM_IA64_LOCAL_H
-#define _ASM_IA64_LOCAL_H
-
-/*
- * Copyright (C) 2003 Hewlett-Packard Co
- *	David Mosberger-Tang <davidm@hpl.hp.com>
- */
-
-#include <linux/percpu.h>
-
-typedef struct {
-	atomic64_t val;
-} local_t;
-
-#define LOCAL_INIT(i)	((local_t) { { (i) } })
-#define local_read(l)	atomic64_read(&(l)->val)
-#define local_set(l, i)	atomic64_set(&(l)->val, i)
-#define local_inc(l)	atomic64_inc(&(l)->val)
-#define local_dec(l)	atomic64_dec(&(l)->val)
-#define local_add(i, l)	atomic64_add((i), &(l)->val)
-#define local_sub(i, l)	atomic64_sub((i), &(l)->val)
-
-/* Non-atomic variants, i.e., preemption disabled and won't be touched in interrupt, etc.  */
-
-#define __local_inc(l)		(++(l)->val.counter)
-#define __local_dec(l)		(--(l)->val.counter)
-#define __local_add(i,l)	((l)->val.counter += (i))
-#define __local_sub(i,l)	((l)->val.counter -= (i))
-
-/*
- * Use these for per-cpu local_t variables.  Note they take a variable (eg. mystruct.foo),
- * not an address.
- */
-#define cpu_local_read(v)	local_read(&__ia64_per_cpu_var(v))
-#define cpu_local_set(v, i)	local_set(&__ia64_per_cpu_var(v), (i))
-#define cpu_local_inc(v)	local_inc(&__ia64_per_cpu_var(v))
-#define cpu_local_dec(v)	local_dec(&__ia64_per_cpu_var(v))
-#define cpu_local_add(i, v)	local_add((i), &__ia64_per_cpu_var(v))
-#define cpu_local_sub(i, v)	local_sub((i), &__ia64_per_cpu_var(v))
-
-/*
- * Non-atomic increments, i.e., preemption disabled and won't be touched in interrupt,
- * etc.
- */
-#define __cpu_local_inc(v)	__local_inc(&__ia64_per_cpu_var(v))
-#define __cpu_local_dec(v)	__local_dec(&__ia64_per_cpu_var(v))
-#define __cpu_local_add(i, v)	__local_add((i), &__ia64_per_cpu_var(v))
-#define __cpu_local_sub(i, v)	__local_sub((i), &__ia64_per_cpu_var(v))
-
-#endif /* _ASM_IA64_LOCAL_H */
+#include <asm-generic/local.h>
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
