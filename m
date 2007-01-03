From: akpm@osdl.org
Subject: - workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch removed from -mm tree
Date: Tue, 02 Jan 2007 16:01:10 -0800
Message-ID: <200701030001.l0301A91001911@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47128 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbXACABs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 19:01:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, clameter@sgi.com, rmk@arm.linux.org.uk, torvalds@osdl.org, mm-commits@vger.kernel.org


The patch titled
     WorkStruct: Implement generic UP cmpxchg() where an arch doesn't support it
has been removed from the -mm tree.  Its filename was
     workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: WorkStruct: Implement generic UP cmpxchg() where an arch doesn't support it
From: David Howells <dhowells@redhat.com>

Implement generic UP cmpxchg() where an arch doesn't otherwise support it. 
This assuming that the arch doesn't have support SMP without providing its
own cmpxchg() implementation.

This is required because cmpxchg() is used by the reduced work queue
patches to adjust the management data in a work_struct.

Also provide ARMv6 with a cmpxchg() implementation using LDREX/STREXEQ. 
Pre-v6 ARM doesn't support SMP according to ARM's atomic.h, so the generic
IRQ-disablement based cmpxchg() is entirely adequate there (if it isn't,
then atomic_cmpxchg() is also broken on ARM).

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-arm/system.h      |   40 +++++++++++++++++++++++++++
 include/asm-generic/cmpxchg.h |   46 ++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff -puN include/asm-arm/system.h~workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it include/asm-arm/system.h
--- a/include/asm-arm/system.h~workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it
+++ a/include/asm-arm/system.h
@@ -361,6 +361,46 @@ static inline unsigned long __xchg(unsig
 extern void disable_hlt(void);
 extern void enable_hlt(void);
 
+/*
+ * We only implement cmpxchg in ASM on ARMv6 where we have LDREX/STREX
+ * available, and we only implement it for word-sized exchanges
+ */
+#if __LINUX_ARM_ARCH__ >= 6
+extern void __bad_cmpxchg(volatile void *, int);
+
+#define cmpxchg(ptr, old, new)						\
+({									\
+	__typeof__ (ptr) ____p = (ptr);					\
+	__typeof__(*ptr) ____old = (old);				\
+	__typeof__(*ptr) ____new = (new);				\
+	__typeof__(*ptr) ____oldval;					\
+	__typeof__(*ptr) ____res;					\
+									\
+	switch (sizeof(____res)) {					\
+	case 4:								\
+		do {							\
+			__asm__ __volatile__("@ cmpxchg\n"		\
+			"ldrex	%1, [%2]\n"				\
+			"mov	%0, #0\n"				\
+			"teq	%1, %3\n"				\
+			"strexeq %0, %4, [%2]\n"			\
+			: "=&r" (____res), "=&r" (____oldval)		\
+			: "r" (____p), "Ir" (____old), "r" (____new)	\
+			: "cc");					\
+		} while(____res);					\
+		break;							\
+	default:							\
+		__bad_cmpxchg(____p, sizeof(____res));			\
+		____oldval = 0;						\
+		break;							\
+	}								\
+	____oldval;							\
+})
+
+#else
+#include <asm-generic/cmpxchg.h>
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #define arch_align_stack(x) (x)
diff -puN /dev/null include/asm-generic/cmpxchg.h
--- /dev/null
+++ a/include/asm-generic/cmpxchg.h
@@ -0,0 +1,46 @@
+/* Generic cmpxchg for those arches that don't implement it themselves
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_GENERIC_CMPXCHG_H
+#define _ASM_GENERIC_CMPXCHG_H
+
+#if !defined(cmpxchg) && !defined(CONFIG_SMP)
+
+/**
+ * cmpxchg - Atomically conditionally exchange one value for another.
+ * @ptr - Pointer to the value to be altered.
+ * @old - The value to change from.
+ * @new - The value to change to.
+ *
+ * This function atomically compares the current value at the word pointed to
+ * by @ptr, and if it's the same as @old, changes it to @new.  If it's not the
+ * same then it's left unchanged.
+ *
+ * The value that was in the word pointed to by @ptr is returned, whether or
+ * not it was changed to @new.
+ */
+#define cmpxchg(ptr, old, new)			\
+({						\
+	unsigned long ____flags;		\
+	__typeof__ (ptr) ____p = (ptr);		\
+	__typeof__(*ptr) ____old = (old);	\
+	__typeof__(*ptr) ____new = (new);	\
+	__typeof__(*ptr) ____res;		\
+	raw_local_irq_save(____flags);		\
+	____res = *____p;			\
+	if (likely(____res == (____old)))	\
+		*____p = (____new);		\
+	raw_local_irq_restore(____flags);	\
+	____res;				\
+})
+
+#endif /* !cmpxchg && !SMP */
+#endif /* _ASM_GENERIC_CMPXCHG_H */
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-alsa.patch
infiniband-work-around-gcc-bug-on-sparc64.patch
nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems.patch
git-cryptodev.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-packet-management.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch
