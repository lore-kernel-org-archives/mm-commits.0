From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-support-debug_wx.patch added to -mm tree
Date: Sat, 25 Apr 2020 18:06:03 -0700
Message-ID: <20200426010603.ydybnn-Ys%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgDZBGE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 21:06:04 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@alien8.de, catalin.marinas@arm.com, hpa@zytor.com, mingo@redhat.com, mm-commits@vger.kernel.org, palmer@dabbelt.com, paul.walmsley@sifive.com, tglx@linutronix.de, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: riscv: support DEBUG_WX
has been added to the -mm tree.  Its filename is
     riscv-support-debug_wx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/riscv-support-debug_wx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/riscv-support-debug_wx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zong Li <zong.li@sifive.com>
Subject: riscv: support DEBUG_WX

Support DEBUG_WX to check whether there are mapping with write and execute
permission at the same time.

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
 arch/riscv/include/asm/ptdump.h |    6 ++++++
 arch/riscv/mm/init.c            |    3 +++
 3 files changed, 10 insertions(+)

--- a/arch/riscv/include/asm/ptdump.h~riscv-support-debug_wx
+++ a/arch/riscv/include/asm/ptdump.h
@@ -8,4 +8,10 @@
 
 void ptdump_check_wx(void);
 
+#ifdef CONFIG_DEBUG_WX
+#define debug_checkwx() ptdump_check_wx()
+#else
+#define debug_checkwx() do { } while (0)
+#endif
+
 #endif /* _ASM_RISCV_PTDUMP_H */
--- a/arch/riscv/Kconfig~riscv-support-debug_wx
+++ a/arch/riscv/Kconfig
@@ -67,6 +67,7 @@ config RISCV
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select HAVE_COPY_THREAD_TLS
 	select HAVE_ARCH_KASAN if MMU && 64BIT
+	select ARCH_HAS_DEBUG_WX
 
 config ARCH_MMAP_RND_BITS_MIN
 	default 18 if 64BIT
--- a/arch/riscv/mm/init.c~riscv-support-debug_wx
+++ a/arch/riscv/mm/init.c
@@ -19,6 +19,7 @@
 #include <asm/sections.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
+#include <asm/ptdump.h>
 
 #include "../kernel/head.h"
 
@@ -529,6 +530,8 @@ void mark_rodata_ro(void)
 	set_memory_ro(rodata_start, (data_start - rodata_start) >> PAGE_SHIFT);
 	set_memory_nx(rodata_start, (data_start - rodata_start) >> PAGE_SHIFT);
 	set_memory_nx(data_start, (max_low - data_start) >> PAGE_SHIFT);
+
+	debug_checkwx();
 }
 #endif
 
_

Patches currently in -mm which might be from zong.li@sifive.com are

mm-add-debug_wx-support.patch
riscv-support-debug_wx.patch
x86-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch
arm64-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch
