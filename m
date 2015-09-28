From: akpm@linux-foundation.org
Subject: [merged] x86-efi-kasan-undef-memset-memcpy-memmove-per-arch.patch removed from -mm tree
Date: Mon, 28 Sep 2015 11:16:01 -0700
Message-ID: <560983e1.Teww9+pMP/3Z393U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryabinin.a.a@gmail.com, catalin.marinas@arm.com, fengguang.wu@gmail.com, hpa@zytor.com, matt.fleming@intel.com, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, efi, kasan: #undef memset/memcpy/memmove per arch
has been removed from the -mm tree.  Its filename was
     x86-efi-kasan-undef-memset-memcpy-memmove-per-arch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: x86, efi, kasan: #undef memset/memcpy/memmove per arch

In not-instrumented code KASAN replaces instrumented memset/memcpy/memmove
with not-instrumented analogues __memset/__memcpy/__memove.

However, on x86 the EFI stub is not linked with the kernel.  It uses
not-instrumented mem*() functions from arch/x86/boot/compressed/string.c

So we don't replace them with __mem*() variants in EFI stub.

On ARM64 the EFI stub is linked with the kernel, so we should replace
mem*() functions with __mem*(), because the EFI stub runs before KASAN
sets up early shadow.

So let's move these #undef mem* into arch's asm/efi.h which is also
included by the EFI stub.

Also, this will fix the warning in 32-bit build reported by kbuild test
robot:

	efi-stub-helper.c:599:2: warning: implicit declaration of function 'memcpy'

[akpm@linux-foundation.org: use 80 cols in comment]
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reported-by: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/efi.h             |   10 ++++++++++
 drivers/firmware/efi/libstub/efistub.h |    4 ----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/efi.h~x86-efi-kasan-undef-memset-memcpy-memmove-per-arch arch/x86/include/asm/efi.h
--- a/arch/x86/include/asm/efi.h~x86-efi-kasan-undef-memset-memcpy-memmove-per-arch
+++ a/arch/x86/include/asm/efi.h
@@ -86,6 +86,16 @@ extern u64 asmlinkage efi_call(void *fp,
 extern void __iomem *__init efi_ioremap(unsigned long addr, unsigned long size,
 					u32 type, u64 attribute);
 
+/*
+ * CONFIG_KASAN may redefine memset to __memset.  __memset function is present
+ * only in kernel binary.  Since the EFI stub linked into a separate binary it
+ * doesn't have __memset().  So we should use standard memset from
+ * arch/x86/boot/compressed/string.c.  The same applies to memcpy and memmove.
+ */
+#undef memcpy
+#undef memset
+#undef memmove
+
 #endif /* CONFIG_X86_32 */
 
 extern struct efi_scratch efi_scratch;
diff -puN drivers/firmware/efi/libstub/efistub.h~x86-efi-kasan-undef-memset-memcpy-memmove-per-arch drivers/firmware/efi/libstub/efistub.h
--- a/drivers/firmware/efi/libstub/efistub.h~x86-efi-kasan-undef-memset-memcpy-memmove-per-arch
+++ a/drivers/firmware/efi/libstub/efistub.h
@@ -5,10 +5,6 @@
 /* error code which can't be mistaken for valid address */
 #define EFI_ERROR	(~0UL)
 
-#undef memcpy
-#undef memset
-#undef memmove
