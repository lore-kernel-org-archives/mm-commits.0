From: akpm@linux-foundation.org
Subject: [merged] arm-use-set_memoryh-header.patch removed from -mm
 tree
Date: Tue, 09 May 2017 11:03:09 -0700
Message-ID: <20170509180309.uvFSayOgi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754293AbdEISDK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, mm-commits@vger.kernel.org, rmk+kernel@armlinux.org.uk


The patch titled
     Subject: arm: use set_memory.h header
has been removed from the -mm tree.  Its filename was
     arm-use-set_memoryh-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: arm: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly

Link: http://lkml.kernel.org/r/1488920133-27229-3-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/ftrace.c        |    1 +
 arch/arm/kernel/machine_kexec.c |    1 +
 arch/arm/mm/pageattr.c          |    1 +
 arch/arm/net/bpf_jit_32.c       |    1 +
 4 files changed, 4 insertions(+)

diff -puN arch/arm/kernel/ftrace.c~arm-use-set_memoryh-header arch/arm/kernel/ftrace.c
--- a/arch/arm/kernel/ftrace.c~arm-use-set_memoryh-header
+++ a/arch/arm/kernel/ftrace.c
@@ -21,6 +21,7 @@
 #include <asm/opcodes.h>
 #include <asm/ftrace.h>
 #include <asm/insn.h>
+#include <asm/set_memory.h>
 
 #ifdef CONFIG_THUMB2_KERNEL
 #define	NOP		0xf85deb04	/* pop.w {lr} */
diff -puN arch/arm/kernel/machine_kexec.c~arm-use-set_memoryh-header arch/arm/kernel/machine_kexec.c
--- a/arch/arm/kernel/machine_kexec.c~arm-use-set_memoryh-header
+++ a/arch/arm/kernel/machine_kexec.c
@@ -18,6 +18,7 @@
 #include <asm/mach-types.h>
 #include <asm/smp_plat.h>
 #include <asm/system_misc.h>
+#include <asm/set_memory.h>
 
 extern void relocate_new_kernel(void);
 extern const unsigned int relocate_new_kernel_size;
diff -puN arch/arm/mm/pageattr.c~arm-use-set_memoryh-header arch/arm/mm/pageattr.c
--- a/arch/arm/mm/pageattr.c~arm-use-set_memoryh-header
+++ a/arch/arm/mm/pageattr.c
@@ -15,6 +15,7 @@
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm/set_memory.h>
 
 struct page_change_data {
 	pgprot_t set_mask;
diff -puN arch/arm/net/bpf_jit_32.c~arm-use-set_memoryh-header arch/arm/net/bpf_jit_32.c
--- a/arch/arm/net/bpf_jit_32.c~arm-use-set_memoryh-header
+++ a/arch/arm/net/bpf_jit_32.c
@@ -18,6 +18,7 @@
 #include <linux/if_vlan.h>
 
 #include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/hwcap.h>
 #include <asm/opcodes.h>
 
_

Patches currently in -mm which might be from labbott@redhat.com are


