From: akpm@linux-foundation.org
Subject: + mm-add-utility-for-early-copy-from-unmapped-ram.patch added to
 -mm tree
Date: Fri, 07 Aug 2015 15:19:48 -0700
Message-ID: <55c52f04.96BoeeVXfEpI5t8U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946302AbbHGWTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 18:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, ard.biesheuvel@linaro.org, arnd@arndb.de, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add utility for early copy from unmapped ram
has been added to the -mm tree.  Its filename is
     mm-add-utility-for-early-copy-from-unmapped-ram.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-utility-for-early-copy-from-unmapped-ram.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-utility-for-early-copy-from-unmapped-ram.patch

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
Subject: mm: add utility for early copy from unmapped ram

When booting an arm64 kernel w/initrd using UEFI/grub, use of mem= will
likely cut off part or all of the initrd.  This leaves it outside the
kernel linear map which leads to failure when unpacking.  The x86 code has
a similar need to relocate an initrd outside of mapped memory in some
cases.

The current x86 code uses early_memremap() to copy the original initrd
from unmapped to mapped RAM.  This patchset creates a generic
copy_from_early_mem() utility based on that x86 code and has arm64 and x86
share it in their respective initrd relocation code.



This patch (of 3):

In some early boot circumstances, it may be necessary to copy from RAM
outside the kernel linear mapping to mapped RAM.  The need to relocate an
initrd is one example in the x86 code.  This patch creates a helper
function based on current x86 code.

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/early_ioremap.h |    6 ++++++
 mm/early_ioremap.c                  |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff -puN include/asm-generic/early_ioremap.h~mm-add-utility-for-early-copy-from-unmapped-ram include/asm-generic/early_ioremap.h
--- a/include/asm-generic/early_ioremap.h~mm-add-utility-for-early-copy-from-unmapped-ram
+++ a/include/asm-generic/early_ioremap.h
@@ -33,6 +33,12 @@ extern void early_ioremap_setup(void);
  */
 extern void early_ioremap_reset(void);
 
+/*
+ * Early copy from unmapped memory to kernel mapped memory.
+ */
+extern void copy_from_early_mem(void *dest, phys_addr_t src,
+				unsigned long size);
+
 #else
 static inline void early_ioremap_init(void) { }
 static inline void early_ioremap_setup(void) { }
diff -puN mm/early_ioremap.c~mm-add-utility-for-early-copy-from-unmapped-ram mm/early_ioremap.c
--- a/mm/early_ioremap.c~mm-add-utility-for-early-copy-from-unmapped-ram
+++ a/mm/early_ioremap.c
@@ -217,6 +217,28 @@ early_memremap(resource_size_t phys_addr
 	return (__force void *)__early_ioremap(phys_addr, size,
 					       FIXMAP_PAGE_NORMAL);
 }
+
+#define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
+
+void __init copy_from_early_mem(void *dest, phys_addr_t src, unsigned long size)
+{
+	unsigned long slop, clen;
+	char *p;
+
+	while (size) {
+		slop = src & ~PAGE_MASK;
+		clen = size;
+		if (clen > MAX_MAP_CHUNK - slop)
+			clen = MAX_MAP_CHUNK - slop;
+		p = early_memremap(src & PAGE_MASK, clen + slop);
+		memcpy(dest, p + slop, clen);
+		early_iounmap(p, clen + slop);
+		dest += clen;
+		src += clen;
+		size -= clen;
+	}
+}
+
 #else /* CONFIG_MMU */
 
 void __init __iomem *
_

Patches currently in -mm which might be from msalter@redhat.com are

mm-add-utility-for-early-copy-from-unmapped-ram.patch
arm64-support-initrd-outside-kernel-linear-map.patch
x86-use-generic-early-mem-copy.patch
linux-next.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch

