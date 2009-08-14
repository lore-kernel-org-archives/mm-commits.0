From: akpm@linux-foundation.org
Subject: [merged] net-cs89x0-includecheck-fix-for-cs89x0c.patch removed from -mm tree
Date: Fri, 14 Aug 2009 12:56:23 -0700
Message-ID: <200908141956.n7EJuN0K005830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755830AbZHNT50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Aug 2009 15:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     net: cs89x0: includecheck fix for cs89x0.c
has been removed from the -mm tree.  Its filename was
     net-cs89x0-includecheck-fix-for-cs89x0c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: cs89x0: includecheck fix for cs89x0.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following 'make includecheck' warning:

  drivers/net/cs89x0.c: asm/irq.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cs89x0.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/net/cs89x0.c~net-cs89x0-includecheck-fix-for-cs89x0c drivers/net/cs89x0.c
--- a/drivers/net/cs89x0.c~net-cs89x0-includecheck-fix-for-cs89x0c
+++ a/drivers/net/cs89x0.c
@@ -177,13 +177,10 @@ static unsigned int cs8900_irq_map[] = {
 #elif defined(CONFIG_MACH_IXDP2351)
 static unsigned int netcard_portlist[] __used __initdata = {IXDP2351_VIRT_CS8900_BASE, 0};
 static unsigned int cs8900_irq_map[] = {IRQ_IXDP2351_CS8900, 0, 0, 0};
-#include <asm/irq.h>
 #elif defined(CONFIG_ARCH_IXDP2X01)
-#include <asm/irq.h>
 static unsigned int netcard_portlist[] __used __initdata = {IXDP2X01_CS8900_VIRT_BASE, 0};
 static unsigned int cs8900_irq_map[] = {IRQ_IXDP2X01_CS8900, 0, 0, 0};
 #elif defined(CONFIG_ARCH_PNX010X)
-#include <asm/irq.h>
 #include <mach/gpio.h>
 #define CIRRUS_DEFAULT_BASE	IO_ADDRESS(EXT_STATIC2_s0_BASE + 0x200000)	/* = Physical address 0x48200000 */
 #define CIRRUS_DEFAULT_IRQ	VH_INTC_INT_NUM_CASCADED_INTERRUPT_1 /* Event inputs bank 1 - ID 35/bit 3 */
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-includecheck-fix-for-mm-nommuc.patch
includecheck-fix-drivers-char-vtc.patch
includecheck-fix-documentation-cfag12864b-examplec.patch

