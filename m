From: akpm@linux-foundation.org
Subject: [merged] riscv-support-debug_wx.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:21:37 -0700
Message-ID: <20200604172137.h99Tsq_fh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbgFDRVi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:21:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@alien8.de, catalin.marinas@arm.com, hpa@zytor.com, mingo@redhat.com, mm-commits@vger.kernel.org, palmer@dabbelt.com, paul.walmsley@sifive.com, tglx@linutronix.de, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: riscv: support DEBUG_WX
has been removed from the -mm tree.  Its filename was
     riscv-support-debug_wx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zong Li <zong.li@sifive.com>
Subject: riscv: support DEBUG_WX

Support DEBUG_WX to check whether there are mapping with write and execute
permission at the same time.

[akpm@linux-foundation.org: replace macros with C]
Link: http://lkml.kernel.org/r/282e266311bced080bc6f7c255b92f87c1eb65d6.1587455584.git.zong.li@sifive.com
Signed-off-by: Zong Li <zong.li@sifive.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig              |    1 +
 arch/riscv/include/asm/ptdump.h |   11 +++++++++++
 arch/riscv/mm/init.c            |    3 +++
 3 files changed, 15 insertions(+)

--- a/arch/riscv/include/asm/ptdump.h~riscv-support-debug_wx
+++ a/arch/riscv/include/asm/ptdump.h
@@ -8,4 +8,15 @@
 
 void ptdump_check_wx(void);
 
+#ifdef CONFIG_DEBUG_WX
+static inline void debug_checkwx(void)
+{
+	ptdump_check_wx();
+}
+#else
+static inline void debug_checkwx(void)
+{
+}
+#endif
+
 #endif /* _ASM_RISCV_PTDUMP_H */
--- a/arch/riscv/Kconfig~riscv-support-debug_wx
+++ a/arch/riscv/Kconfig
@@ -16,6 +16,7 @@ config RISCV
 	select OF_EARLY_FLATTREE
 	select OF_IRQ
 	select ARCH_HAS_BINFMT_FLAT
+	select ARCH_HAS_DEBUG_WX
 	select ARCH_WANT_FRAME_POINTERS
 	select CLONE_BACKWARDS
 	select COMMON_CLK
--- a/arch/riscv/mm/init.c~riscv-support-debug_wx
+++ a/arch/riscv/mm/init.c
@@ -19,6 +19,7 @@
 #include <asm/sections.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
+#include <asm/ptdump.h>
 
 #include "../kernel/head.h"
 
@@ -514,6 +515,8 @@ void mark_rodata_ro(void)
 	set_memory_ro(rodata_start, (data_start - rodata_start) >> PAGE_SHIFT);
 	set_memory_nx(rodata_start, (data_start - rodata_start) >> PAGE_SHIFT);
 	set_memory_nx(data_start, (max_low - data_start) >> PAGE_SHIFT);
+
+	debug_checkwx();
 }
 #endif
 
_

Patches currently in -mm which might be from zong.li@sifive.com are
