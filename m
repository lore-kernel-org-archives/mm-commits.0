From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 129/131] riscv: support DEBUG_WX
Date: Wed, 03 Jun 2020 16:03:55 -0700
Message-ID: <20200603230355.TFNjWIB4V%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbgFCXIn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:43 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@alien8.de, catalin.marinas@arm.com, hpa@zytor.com, linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org, palmer@dabbelt.com, paul.walmsley@sifive.com, tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org, zong.li@sifive.com

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
