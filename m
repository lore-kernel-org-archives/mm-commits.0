Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832330;
	b=GXzjTO8Yvvow8dJBDnSoAaD/QmYrLUm/aqqGtcqh7IbnyG77a2B7jZGC40im+V0nS+uT
	 PBRXKwrbqfjk5JiHyZJVPPg6Tzdm63tj7mlDe5VbLvRI9VWRfA+20rhgWyFjKjJy0muK/
	 pbR6BdeZjwq/bhKDg5B15k+P3+O2ymFMJ+O4WsCOWFHjtefsUduWu51ZkFJ/PtUDIo/p9
	 rcFBRWKAangj8tQebE7YhGCnHM+bTqD3tGGXUVttXJii0gL5Va3yll6+7g3zR70BjxxRc
	 6ycpajKadyiP82hJQMymjBOcavqpdU2czqVLcOd0YsyAKlR43BW9PHCY4L+wZmXAwpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832330;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=rEUFQB2U4JcG42sWhjx/71ddHNS5XcUGmUToZuaQs1o=;
	b=iXXIpV0kQw/SL1SPf1nERf2DjvTo7yzNwXuhMAmLdx1hfZ+DwA59x0N6LRY7Aqc4gsUx
	 NmjBez3rohA6qPJAog5/vvOn8bqznziH67NMpE2/m60EUSGe5Id8Kwrh0xkIu6ZHHboI4
	 aIG/ip5LLqMGPwyAG8yi9lJX27qAHKBba+pfaWRJA3ozq3AqRPT3/poBaAP2Tg4B3KcGt
	 fknaHWEa/gl2eFFNUtTHbQo+36OeR4za5KleRQ1PqbmSBpG+H9PxS502XZYbWBbShjS/P
	 g/zcT0Ner6JEV6nNuRQ4ydQpHpIyDYdzoCTm0CdjwdoF9vyecn6FwSP1nBRBg78vpcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2EFwy1mj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26009606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2EFwy1mj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DD51F01828;
	Sat, 24 Oct 2026 08:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832330;
	bh=rEUFQB2U4JcG42sWhjx/71ddHNS5XcUGmUToZuaQs1o=;
	h=Date:To:From:Subject;
	b=2EFwy1mjCHoGhMXMAESFRTlzgbI59cdq3zPAQecCAn/Ge+yx9PZFdg2ls4dO0jdrN
	 vV7rEikEFckJeF83zZEsgzH1qUIAsWsKrHhqzFOxy1SLoTS7DYJV8vdFUFL2hwtTuX
	 l5tUwS3WrLKbdsccaHNYwZY2Zp2o7mqvDXDJP2v8=
Date: Sat, 24 Oct 2026 01:58:49 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-drop-include-asm-mmzoneh.patch removed from -mm tree
Message-Id: <20261024085849.E4DD51F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: sh: drop include/asm/mmzone.h
has been removed from the -mm tree.  Its filename was
     sh-drop-include-asm-mmzoneh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: drop include/asm/mmzone.h
Date: Sun, 10 May 2026 16:55:42 +0300

include/asm/mmzone.h was required for declarations of NUMA related
functionality.

The only function declared there that's not related to NUMA is
__add_active_range().

Move __add_active_range() declaration to include/asm/setup.h and drop
include/asm/mmzone.h

Link: https://lore.kernel.org/20260510135546.13554-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/sh/include/asm/mmzone.h           |   42 -----------------------
 arch/sh/include/asm/setup.h            |    3 +
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-shx3.c   |    1 
 arch/sh/kernel/setup.c                 |    2 -
 arch/sh/mm/init.c                      |    1 
 11 files changed, 3 insertions(+), 52 deletions(-)

diff --git a/arch/sh/include/asm/mmzone.h a/arch/sh/include/asm/mmzone.h
deleted file mode 100644
--- a/arch/sh/include/asm/mmzone.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __ASM_SH_MMZONE_H
-#define __ASM_SH_MMZONE_H
-
-#ifdef CONFIG_NUMA
-#include <linux/numa.h>
-
-static inline int pfn_to_nid(unsigned long pfn)
-{
-	int nid;
-
-	for (nid = 0; nid < MAX_NUMNODES; nid++)
-		if (pfn >= node_start_pfn(nid) && pfn <= node_end_pfn(nid))
-			break;
-
-	return nid;
-}
-
-static inline struct pglist_data *pfn_to_pgdat(unsigned long pfn)
-{
-	return NODE_DATA(pfn_to_nid(pfn));
-}
-
-/* arch/sh/mm/numa.c */
-void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end);
-#else
-static inline void
-setup_bootmem_node(int nid, unsigned long start, unsigned long end)
-{
-}
-#endif /* CONFIG_NUMA */
-
-/* Platform specific mem init */
-void __init plat_mem_setup(void);
-
-/* arch/sh/kernel/setup.c */
-void __init __add_active_range(unsigned int nid, unsigned long start_pfn,
-			       unsigned long end_pfn);
-/* arch/sh/mm/init.c */
-void __init allocate_pgdat(unsigned int nid);
-
-#endif /* __ASM_SH_MMZONE_H */
--- a/arch/sh/include/asm/setup.h~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/include/asm/setup.h
@@ -24,4 +24,7 @@ void check_for_initrd(void);
 void per_cpu_trap_init(void);
 void sh_fdt_init(phys_addr_t dt_phys);
 
+void __add_active_range(unsigned int nid, unsigned long start_pfn,
+			unsigned long end_pfn);
+
 #endif /* _SH_SETUP_H */
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
@@ -16,7 +16,6 @@
 #include <linux/usb/m66592.h>
 
 #include <asm/clock.h>
-#include <asm/mmzone.h>
 #include <asm/siu.h>
 #include <asm/platform_early.h>
 
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7723.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
@@ -17,7 +17,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/clock.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 #include <cpu/sh7723.h>
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
@@ -24,7 +24,6 @@
 #include <asm/cacheflush.h>
 #include <asm/suspend.h>
 #include <asm/clock.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 #include <cpu/dma-register.h>
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
@@ -21,7 +21,6 @@
 #include <cpu/dma-register.h>
 #include <cpu/sh7757.h>
 
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 static struct plat_sci_port scif2_platform_data = {
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
@@ -13,7 +13,6 @@
 #include <linux/sh_dma.h>
 #include <linux/sh_timer.h>
 #include <linux/sh_intc.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 #include <cpu/dma-register.h>
 
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
@@ -22,7 +22,6 @@
 #include <linux/sh_intc.h>
 #include <linux/usb/ohci_pdriver.h>
 #include <cpu/dma-register.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 static struct plat_sci_port scif0_platform_data = {
--- a/arch/sh/kernel/cpu/sh4a/setup-shx3.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-shx3.c
@@ -13,7 +13,6 @@
 #include <linux/sh_timer.h>
 #include <linux/sh_intc.h>
 #include <cpu/shx3.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 /*
--- a/arch/sh/kernel/setup.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/setup.c
@@ -23,7 +23,6 @@
 #include <linux/smp.h>
 #include <linux/err.h>
 #include <linux/crash_dump.h>
-#include <linux/mmzone.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
@@ -41,7 +40,6 @@
 #include <asm/clock.h>
 #include <asm/smp.h>
 #include <asm/mmu_context.h>
-#include <asm/mmzone.h>
 #include <asm/processor.h>
 #include <asm/sparsemem.h>
 #include <asm/platform_early.h>
--- a/arch/sh/mm/init.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/mm/init.c
@@ -20,7 +20,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <asm/mmu_context.h>
-#include <asm/mmzone.h>
 #include <asm/kexec.h>
 #include <asm/tlb.h>
 #include <asm/cacheflush.h>
_

Patches currently in -mm which might be from rppt@kernel.org are


