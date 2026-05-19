Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE92E367F40
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 19:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779217306; cv=none; b=izE86jF9JyP4Pl9EUjmwQPLcmPqsWIKXvSHfj+JN3oXeaUV8NAUyw+IdBGIx+o8BX7C7ZkBGIHM0fmCGR3Vob3Z+XCBTMkJQoZVdbkHzH5WUuZnJ882vCFw6y+Qa9S+yKWllvBRsGyfGjLDeeKjbXGGQ1ZhR6Z4wqOm6RrmPabo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779217306; c=relaxed/simple;
	bh=ynZYJ7XRv96qlHZL6XOxOnRQWfVisUE61qChCutsZOo=;
	h=Date:To:From:Subject:Message-Id; b=O8LpRDgHZinaDHsJA5W0Mg77GeMx5a+LpVQ+S19TwG3PElAP6HARFM2ciELfCxyRnr3jCMUugXUPeJQjEh0ccqoUA8cI/3Ifdhln0Be6+aHcOSXSEz6QimQMTnUjaeOJIpmYNFEyNmGjdW1HJkG6o9V663WBscmr96gRpCfm7Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FL6Wplnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FL6Wplnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575C11F000E9;
	Tue, 19 May 2026 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779217304;
	bh=SodhTbe3tJHdcWMSAUH8xSh/jH4wMIevj8eDJC5II68=;
	h=Date:To:From:Subject;
	b=FL6WplnvtR/WvptHWJ149z5l+TMkkFL6Y46FO10MAB5pOvJdKd6wJB/RjM14Ofj8n
	 BfPo7mPHgocAmGgU51/M7fY197GHDppkhhPzqF7RM2Trj4AjVh8rz5hS6OO0X2/7NA
	 4WZ2pa4ue/6lN3dqFvvlN1w/Rv7lIJpuPfLD+tdw=
Date: Tue, 19 May 2026 12:01:43 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] riscv-add-platform-specific-double-word-shifts-for-riscv32.patch removed from -mm tree
Message-Id: <20260519190144.575C11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: add platform-specific double word shifts for riscv32
has been removed from the -mm tree.  Its filename was
     riscv-add-platform-specific-double-word-shifts-for-riscv32.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: riscv: add platform-specific double word shifts for riscv32
Date: Wed, 13 May 2026 16:44:05 +0300

Add riscv32-specific '__ashldi3()', '__ashrdi3()', and '__lshrdi3()'. 
Initially it was intended to fix the following link error observed when
building EFI-enabled kernel with CONFIG_EFI_STUB=y and
CONFIG_EFI_GENERIC_STUB=y:

riscv32-linux-gnu-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L49':
__efistub_cmdline.c:(.init.text+0x1f2): undefined reference to `__efistub___ashldi3'
riscv32-linux-gnu-ld: __efistub_cmdline.c:(.init.text+0x202): undefined reference to `__efistub___lshrdi3'

Reported at [1] trying to build
https://patchew.org/linux/20260212164413.889625-1-dmantipov@yandex.ru,
tested with 'qemu-system-riscv32 -M virt' only.

Link: https://lore.kernel.org/20260513134407.884033-7-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603041925.KLKqpK6N-lkp@intel.com [1]
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Assisted-by: Gemini:gemini-3.1-pro-preview sashiko
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig             |    3 --
 arch/riscv/kernel/image-vars.h |    9 +++++++
 arch/riscv/lib/Makefile        |    1 
 arch/riscv/lib/ashldi3.S       |   36 +++++++++++++++++++++++++++++++
 arch/riscv/lib/ashrdi3.S       |   36 +++++++++++++++++++++++++++++++
 arch/riscv/lib/lshrdi3.S       |   36 +++++++++++++++++++++++++++++++
 6 files changed, 118 insertions(+), 3 deletions(-)

--- a/arch/riscv/Kconfig~riscv-add-platform-specific-double-word-shifts-for-riscv32
+++ a/arch/riscv/Kconfig
@@ -404,9 +404,6 @@ config ARCH_RV32I
 	bool "RV32I"
 	depends on NONPORTABLE
 	select 32BIT
-	select GENERIC_LIB_ASHLDI3
-	select GENERIC_LIB_ASHRDI3
-	select GENERIC_LIB_LSHRDI3
 	select GENERIC_LIB_UCMPDI2
 
 config ARCH_RV64I
--- a/arch/riscv/kernel/image-vars.h~riscv-add-platform-specific-double-word-shifts-for-riscv32
+++ a/arch/riscv/kernel/image-vars.h
@@ -32,6 +32,15 @@ __efistub___init_text_end	= __init_text_
 __efistub_sysfb_primary_display	= sysfb_primary_display;
 #endif
 
+/*
+ * These double-word integer shifts are used by the library code, and
+ * the first two of them are required to link EFI stub. Note __ashrdi3()
+ * is not actually used by the stub but this may change in the future.
+ */
+PROVIDE(__efistub___lshrdi3	= __lshrdi3);
+PROVIDE(__efistub___ashldi3	= __ashldi3);
+PROVIDE(__efistub___ashrdi3	= __ashrdi3);
+
 #endif
 
 #endif /* __RISCV_KERNEL_IMAGE_VARS_H */
diff --git a/arch/riscv/lib/ashldi3.S a/arch/riscv/lib/ashldi3.S
new file mode 100644
--- /dev/null
+++ a/arch/riscv/lib/ashldi3.S
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/**
+ * Adopted for the Linux kernel from IPXE project, see
+ * https://github.com/ipxe/ipxe/blob/master/src/arch/riscv32/libgcc/llshift.S
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+
+/**
+ * Shift left
+ *
+ * @v a1:a0             Value to shift
+ * @v a2                Shift amount
+ * @ret a1:a0           Shifted value
+ */
+
+SYM_FUNC_START(__ashldi3)
+
+        /* Perform shift by 32 bits, if applicable */
+        li      t0, 32
+        sub     t1, t0, a2
+        bgtz    t1, 1f
+        mv      a1, a0
+        mv      a0, zero
+1:      /* Perform shift by modulo-32 bits, if applicable */
+        andi    a2, a2, 0x1f
+        beqz    a2, 2f
+        srl     t2, a0, t1
+        sll     a0, a0, a2
+        sll     a1, a1, a2
+        or      a1, a1, t2
+2:      ret
+
+SYM_FUNC_END(__ashldi3)
+EXPORT_SYMBOL(__ashldi3)
diff --git a/arch/riscv/lib/ashrdi3.S a/arch/riscv/lib/ashrdi3.S
new file mode 100644
--- /dev/null
+++ a/arch/riscv/lib/ashrdi3.S
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/**
+ * Adopted for the Linux kernel from IPXE project, see
+ * https://github.com/ipxe/ipxe/blob/master/src/arch/riscv32/libgcc/llshift.S
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+
+/**
+ * Arithmetic shift right
+ *
+ * @v a1:a0             Value to shift
+ * @v a2                Shift amount
+ * @ret a1:a0           Shifted value
+ */
+
+SYM_FUNC_START(__ashrdi3)
+
+        /* Perform shift by 32 bits, if applicable */
+        li      t0, 32
+        sub     t1, t0, a2
+        bgtz    t1, 1f
+        mv      a0, a1
+        srai    a1, a1, 31
+1:      /* Perform shift by modulo-32 bits, if applicable */
+        andi    a2, a2, 0x1f
+        beqz    a2, 2f
+        sll     t2, a1, t1
+        sra     a1, a1, a2
+        srl     a0, a0, a2
+        or      a0, a0, t2
+2:      ret
+
+SYM_FUNC_END(__ashrdi3)
+EXPORT_SYMBOL(__ashrdi3)
diff --git a/arch/riscv/lib/lshrdi3.S a/arch/riscv/lib/lshrdi3.S
new file mode 100644
--- /dev/null
+++ a/arch/riscv/lib/lshrdi3.S
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/**
+ * Adopted for the Linux kernel from IPXE project, see
+ * https://github.com/ipxe/ipxe/blob/master/src/arch/riscv32/libgcc/llshift.S
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+
+/**
+ * Logical shift right
+ *
+ * @v a1:a0             Value to shift
+ * @v a2                Shift amount
+ * @ret a1:a0           Shifted value
+ */
+
+SYM_FUNC_START(__lshrdi3)
+
+        /* Perform shift by 32 bits, if applicable */
+        li      t0, 32
+        sub     t1, t0, a2
+        bgtz    t1, 1f
+        mv      a0, a1
+        mv      a1, zero
+1:      /* Perform shift by modulo-32 bits, if applicable */
+        andi    a2, a2, 0x1f
+        beqz    a2, 2f
+        sll     t2, a1, t1
+        srl     a1, a1, a2
+        srl     a0, a0, a2
+        or      a0, a0, t2
+2:      ret
+
+SYM_FUNC_END(__lshrdi3)
+EXPORT_SYMBOL(__lshrdi3)
--- a/arch/riscv/lib/Makefile~riscv-add-platform-specific-double-word-shifts-for-riscv32
+++ a/arch/riscv/lib/Makefile
@@ -16,6 +16,7 @@ ifeq ($(CONFIG_MMU), y)
 lib-$(CONFIG_RISCV_ISA_V)	+= uaccess_vector.o
 endif
 lib-$(CONFIG_MMU)	+= uaccess.o
+lib-$(CONFIG_32BIT)	+= ashldi3.o ashrdi3.o lshrdi3.o
 lib-$(CONFIG_64BIT)	+= tishift.o
 lib-$(CONFIG_RISCV_ISA_ZICBOZ)	+= clear_page.o
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch

