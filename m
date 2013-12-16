From: akpm@linux-foundation.org
Subject: + add-generic-fixmaph.patch added to -mm tree
Date: Mon, 16 Dec 2013 11:55:54 -0800
Message-ID: <52af5aca.0iKZhX2T3Tlubp7A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3LPTz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rkuo@codeaurora.org, richard@nod.at, ralf@linux-mips.org, paulus@samba.org, monstr@monstr.eu, mingo@redhat.com, linux@arm.linux.org.uk, lethal@linux-sh.org, jonas.bonn@gmail.com, jdike@addtoit.com, james.hogan@imgtec.com, hpa@zytor.com, cmetcalf@tilera.com, benh@kernel.crashing.org, arnd@arndb.de, msalter@redhat.com

Subject: + add-generic-fixmaph.patch added to -mm tree
To: msalter@redhat.com,arnd@arndb.de,benh@kernel.crashing.org,cmetcalf@tilera.com,hpa@zytor.com,james.hogan@imgtec.com,jdike@addtoit.com,jonas.bonn@gmail.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mingo@redhat.com,monstr@monstr.eu,paulus@samba.org,ralf@linux-mips.org,richard@nod.at,rkuo@codeaurora.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:54 -0800


The patch titled
     Subject: add generic fixmap.h
has been added to the -mm tree.  Its filename is
     add-generic-fixmaph.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-generic-fixmaph.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-generic-fixmaph.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: add generic fixmap.h

Many architectures provide an asm/fixmap.h which defines support for
compile-time 'special' virtual mappings which need to be made before
paging_init() has run.  This support is also used for early ioremap on
x86.  Much of this support is identical across the architectures.  This
patch consolidates all of the common bits into asm-generic/fixmap.h which
is intended to be included from arch/*/include/asm/fixmap.h.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jonas Bonn <jonas.bonn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/fixmap.h |   97 +++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff -puN /dev/null include/asm-generic/fixmap.h
--- /dev/null
+++ a/include/asm-generic/fixmap.h
@@ -0,0 +1,97 @@
+/*
+ * fixmap.h: compile-time virtual memory allocation
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1998 Ingo Molnar
+ *
+ * Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
+ * x86_32 and x86_64 integration by Gustavo F. Padovan, February 2009
+ * Break out common bits to asm-generic by Mark Salter, November 2013
+ */
+
+#ifndef __ASM_GENERIC_FIXMAP_H
+#define __ASM_GENERIC_FIXMAP_H
+
+#include <linux/bug.h>
+
+#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
+
+#ifndef __ASSEMBLY__
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without translation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static __always_inline unsigned long fix_to_virt(const unsigned int idx)
+{
+	BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
+	return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
+	return __virt_to_fix(vaddr);
+}
+
+/*
+ * Provide some reasonable defaults for page flags.
+ * Not all architectures use all of these different types and some
+ * architectures use different names.
+ */
+#ifndef FIXMAP_PAGE_NORMAL
+#define FIXMAP_PAGE_NORMAL PAGE_KERNEL
+#endif
+#ifndef FIXMAP_PAGE_NOCACHE
+#define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
+#endif
+#ifndef FIXMAP_PAGE_IO
+#define FIXMAP_PAGE_IO PAGE_KERNEL_IO
+#endif
+#ifndef FIXMAP_PAGE_CLEAR
+#define FIXMAP_PAGE_CLEAR __pgprot(0)
+#endif
+
+#ifndef set_fixmap
+#define set_fixmap(idx, phys)				\
+	__set_fixmap(idx, phys, FIXMAP_PAGE_NORMAL)
+#endif
+
+#ifndef clear_fixmap
+#define clear_fixmap(idx)			\
+	__set_fixmap(idx, 0, FIXMAP_PAGE_CLEAR)
+#endif
+
+/* Return a pointer with offset calculated */
+#define __set_fixmap_offset(idx, phys, flags)		      \
+({							      \
+	unsigned long addr;				      \
+	__set_fixmap(idx, phys, flags);			      \
+	addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1)); \
+	addr;						      \
+})
+
+#define set_fixmap_offset(idx, phys) \
+	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL)
+
+/*
+ * Some hardware wants to get fixmapped without caching.
+ */
+#define set_fixmap_nocache(idx, phys) \
+	__set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE)
+
+#define set_fixmap_offset_nocache(idx, phys) \
+	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE)
+
+/*
+ * Some fixmaps are for IO
+ */
+#define set_fixmap_io(idx, phys) \
+	__set_fixmap(idx, phys, FIXMAP_PAGE_IO)
+
+#endif /* __ASSEMBLY__ */
+#endif /* __ASM_GENERIC_FIXMAP_H */
_

Patches currently in -mm which might be from msalter@redhat.com are

add-generic-fixmaph.patch
x86-use-generic-fixmaph.patch
arm-use-generic-fixmaph.patch
hexagon-use-generic-fixmaph.patch
metag-use-generic-fixmaph.patch
microblaze-use-generic-fixmaph.patch
mips-use-generic-fixmaph.patch
powerpc-use-generic-fixmaph.patch
sh-use-generic-fixmaph.patch
tile-use-generic-fixmaph.patch
um-use-generic-fixmaph.patch
linux-next.patch

