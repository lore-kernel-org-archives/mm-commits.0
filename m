From: akpm@linux-foundation.org
Subject: [merged] x86-use-set_memoryh-header.patch removed from -mm
 tree
Date: Tue, 09 May 2017 11:03:14 -0700
Message-ID: <20170509180314.xm4x8hKlY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34830 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754410AbdEISDP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:03:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: use set_memory.h header
has been removed from the -mm tree.  Its filename was
     x86-use-set_memoryh-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: x86: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-6-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/amd_gart_64.c      |    2 +-
 arch/x86/kernel/cpu/amd.c          |    2 +-
 arch/x86/kernel/cpu/bugs.c         |    2 +-
 arch/x86/kernel/ftrace.c           |    2 +-
 arch/x86/kernel/machine_kexec_32.c |    2 +-
 arch/x86/kernel/machine_kexec_64.c |    1 +
 arch/x86/mm/init.c                 |    2 +-
 arch/x86/mm/init_32.c              |    2 +-
 arch/x86/mm/init_64.c              |    2 +-
 arch/x86/mm/ioremap.c              |    2 +-
 arch/x86/mm/pageattr.c             |    1 +
 arch/x86/net/bpf_jit_comp.c        |    1 +
 arch/x86/pci/pcbios.c              |    2 +-
 arch/x86/platform/efi/efi.c        |    2 +-
 arch/x86/realmode/init.c           |    2 +-
 15 files changed, 15 insertions(+), 12 deletions(-)

diff -puN arch/x86/kernel/amd_gart_64.c~x86-use-set_memoryh-header arch/x86/kernel/amd_gart_64.c
--- a/arch/x86/kernel/amd_gart_64.c~x86-use-set_memoryh-header
+++ a/arch/x86/kernel/amd_gart_64.c
@@ -36,7 +36,7 @@
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 #include <asm/amd_nb.h>
diff -puN arch/x86/kernel/cpu/amd.c~x86-use-set_memoryh-header arch/x86/kernel/cpu/amd.c
--- a/arch/x86/kernel/cpu/amd.c~x86-use-set_memoryh-header
+++ a/arch/x86/kernel/cpu/amd.c
@@ -16,7 +16,7 @@
 
 #ifdef CONFIG_X86_64
 # include <asm/mmconfig.h>
-# include <asm/cacheflush.h>
+# include <asm/set_memory.h>
 #endif
 
 #include "cpu.h"
diff -puN arch/x86/kernel/cpu/bugs.c~x86-use-set_memoryh-header arch/x86/kernel/cpu/bugs.c
--- a/arch/x86/kernel/cpu/bugs.c~x86-use-set_memoryh-header
+++ a/arch/x86/kernel/cpu/bugs.c
@@ -17,7 +17,7 @@
 #include <asm/paravirt.h>
 #include <asm/alternative.h>
 #include <asm/pgtable.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 
 void __init check_bugs(void)
 {
diff -puN arch/x86/kernel/ftrace.c~x86-use-set_memoryh-header arch/x86/kernel/ftrace.c
--- a/arch/x86/kernel/ftrace.c~x86-use-set_memoryh-header
+++ a/arch/x86/kernel/ftrace.c
@@ -24,7 +24,7 @@
 
 #include <trace/syscall.h>
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/kprobes.h>
 #include <asm/ftrace.h>
 #include <asm/nops.h>
diff -puN arch/x86/kernel/machine_kexec_32.c~x86-use-set_memoryh-header arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~x86-use-set_memoryh-header
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -23,7 +23,7 @@
 #include <asm/io_apic.h>
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/debugreg.h>
 
 static void set_idt(void *newidt, __u16 limit)
diff -puN arch/x86/kernel/machine_kexec_64.c~x86-use-set_memoryh-header arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~x86-use-set_memoryh-header
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -27,6 +27,7 @@
 #include <asm/debugreg.h>
 #include <asm/kexec-bzimage64.h>
 #include <asm/setup.h>
+#include <asm/set_memory.h>
 
 #ifdef CONFIG_KEXEC_FILE
 static struct kexec_file_ops *kexec_file_loaders[] = {
diff -puN arch/x86/mm/init.c~x86-use-set_memoryh-header arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-use-set_memoryh-header
+++ a/arch/x86/mm/init.c
@@ -5,7 +5,7 @@
 #include <linux/memblock.h>
 #include <linux/bootmem.h>	/* for max_low_pfn */
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/e820/api.h>
 #include <asm/init.h>
 #include <asm/page.h>
diff -puN arch/x86/mm/init_32.c~x86-use-set_memoryh-header arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~x86-use-set_memoryh-header
+++ a/arch/x86/mm/init_32.c
@@ -48,7 +48,7 @@
 #include <asm/sections.h>
 #include <asm/paravirt.h>
 #include <asm/setup.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/page_types.h>
 #include <asm/init.h>
 
diff -puN arch/x86/mm/init_64.c~x86-use-set_memoryh-header arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-use-set_memoryh-header
+++ a/arch/x86/mm/init_64.c
@@ -50,7 +50,7 @@
 #include <asm/sections.h>
 #include <asm/kdebug.h>
 #include <asm/numa.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/init.h>
 #include <asm/uv/uv.h>
 #include <asm/setup.h>
diff -puN arch/x86/mm/ioremap.c~x86-use-set_memoryh-header arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-use-set_memoryh-header
+++ a/arch/x86/mm/ioremap.c
@@ -14,7 +14,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mmiotrace.h>
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/e820/api.h>
 #include <asm/fixmap.h>
 #include <asm/pgtable.h>
diff -puN arch/x86/mm/pageattr.c~x86-use-set_memoryh-header arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~x86-use-set_memoryh-header
+++ a/arch/x86/mm/pageattr.c
@@ -24,6 +24,7 @@
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/pat.h>
+#include <asm/set_memory.h>
 
 /*
  * The current flushing context - we pass it instead of 5 arguments:
diff -puN arch/x86/net/bpf_jit_comp.c~x86-use-set_memoryh-header arch/x86/net/bpf_jit_comp.c
--- a/arch/x86/net/bpf_jit_comp.c~x86-use-set_memoryh-header
+++ a/arch/x86/net/bpf_jit_comp.c
@@ -12,6 +12,7 @@
 #include <linux/filter.h>
 #include <linux/if_vlan.h>
 #include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <linux/bpf.h>
 
 int bpf_jit_enable __read_mostly;
diff -puN arch/x86/pci/pcbios.c~x86-use-set_memoryh-header arch/x86/pci/pcbios.c
--- a/arch/x86/pci/pcbios.c~x86-use-set_memoryh-header
+++ a/arch/x86/pci/pcbios.c
@@ -11,7 +11,7 @@
 #include <asm/pci_x86.h>
 #include <asm/e820/types.h>
 #include <asm/pci-functions.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
diff -puN arch/x86/platform/efi/efi.c~x86-use-set_memoryh-header arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~x86-use-set_memoryh-header
+++ a/arch/x86/platform/efi/efi.c
@@ -49,7 +49,7 @@
 #include <asm/efi.h>
 #include <asm/e820/api.h>
 #include <asm/time.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
 #include <asm/uv/uv.h>
diff -puN arch/x86/realmode/init.c~x86-use-set_memoryh-header arch/x86/realmode/init.c
--- a/arch/x86/realmode/init.c~x86-use-set_memoryh-header
+++ a/arch/x86/realmode/init.c
@@ -2,7 +2,7 @@
 #include <linux/slab.h>
 #include <linux/memblock.h>
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/pgtable.h>
 #include <asm/realmode.h>
 #include <asm/tlbflush.h>
_

Patches currently in -mm which might be from labbott@redhat.com are


