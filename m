From: akpm@linux-foundation.org
Subject: + x86-use-set_memoryh-header.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:50:09 -0800
Message-ID: <58ba0131.BAyVFWE9URlDeHqs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752151AbdCCXuL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:50:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, airlied@linux.ie, alexander.shishkin@linux.intel.com, arnd@arndb.de, catalin.marinas@arm.com, daniel@iogearbox.net, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, jeyu@redhat.com, keescook@chromium.org, linux@armlinux.org.uk, linux@roeck-us.net, mark.rutland@arm.com, mingo@redhat.com, schwidefsky@de.ibm.com, tglx@linutronix.de, tiwai@suse.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: use set_memory.h header
has been added to the -mm tree.  Its filename is
     x86-use-set_memoryh-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-use-set_memoryh-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-use-set_memoryh-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: x86: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488413706-9739-6-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/amd_gart_64.c      |    2 +-
 arch/x86/kernel/cpu/amd.c          |    2 +-
 arch/x86/kernel/cpu/bugs.c         |    2 +-
 arch/x86/kernel/ftrace.c           |    2 +-
 arch/x86/kernel/machine_kexec_64.c |    1 +
 arch/x86/mm/init.c                 |    2 +-
 arch/x86/mm/init_64.c              |    2 +-
 arch/x86/mm/ioremap.c              |    2 +-
 arch/x86/mm/pageattr.c             |    1 +
 arch/x86/net/bpf_jit_comp.c        |    1 +
 arch/x86/pci/pcbios.c              |    2 +-
 arch/x86/platform/efi/efi.c        |    2 +-
 arch/x86/realmode/init.c           |    2 +-
 13 files changed, 13 insertions(+), 10 deletions(-)

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
 #include <asm/e820.h>
 #include <asm/init.h>
 #include <asm/page.h>
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
@@ -13,7 +13,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mmiotrace.h>
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/e820.h>
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
@@ -9,7 +9,7 @@
 #include <linux/uaccess.h>
 #include <asm/pci_x86.h>
 #include <asm/pci-functions.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
diff -puN arch/x86/platform/efi/efi.c~x86-use-set_memoryh-header arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~x86-use-set_memoryh-header
+++ a/arch/x86/platform/efi/efi.c
@@ -48,7 +48,7 @@
 #include <asm/setup.h>
 #include <asm/efi.h>
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

treewide-move-set_memory_-functions-away-from-cacheflushh.patch
arm-use-set_memoryh-header.patch
arm64-use-set_memoryh-header.patch
s390-use-set_memoryh-header.patch
x86-use-set_memoryh-header.patch
agp-use-set_memoryh-header.patch
drm-use-set_memoryh-header.patch
intel_th-use-set_memoryh-header.patch
watchdog-hpwdt-use-set_memoryh-header.patch
bpf-use-set_memoryh-header.patch
module-use-set_memoryh-header.patch
pm-hibernate-use-set_memoryh-header.patch
alsa-hda-use-set_memoryh-header.patch
treewide-decouple-cacheflushh-and-set_memoryh.patch

