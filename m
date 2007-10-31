From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-s390.patch removed from -mm tree
Date: Wed, 31 Oct 2007 15:41:28 -0700
Message-ID: <20071031224128.554E2432BF5@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:24560 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760824AbXJaWnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2007 18:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to s390
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-s390.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add cmpxchg_local to s390
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the standard __cmpxchg for every type that can be updated atomically.
Use the new generic cmpxchg_local (disables interrupt) for other types.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-s390/system.h |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN include/asm-s390/system.h~add-cmpxchg_local-to-s390 include/asm-s390/system.h
--- a/include/asm-s390/system.h~add-cmpxchg_local-to-s390
+++ a/include/asm-s390/system.h
@@ -355,6 +355,40 @@ __cmpxchg(volatile void *ptr, unsigned l
 
 #include <linux/irqflags.h>
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 1:
+	case 2:
+	case 4:
+#ifdef __s390x__
+	case 8:
+#endif
+		return __cmpxchg(ptr, old, new, size);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr,o,n)						\
+     (__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#ifdef __s390x__
+#define cmpxchg64_local(ptr,o,n) cmpxchg_local((ptr),(o),(n))
+#else
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
 /*
  * Use to set psw mask except for the first byte which
  * won't be changed by this function.
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

local_t-documentation-update-2.patch
markers-fix-warnings.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
