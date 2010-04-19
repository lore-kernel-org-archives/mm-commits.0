From: akpm@linux-foundation.org
Subject: + uv_irqc-fix-all-sparse-warnings.patch added to -mm tree
Date: Mon, 19 Apr 2010 15:06:43 -0700
Message-ID: <201004192206.o3JM6hWf012331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319Ab0DSWHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, cpw@sgi.com, holt@sgi.com, hpa@zytor.com, mingo@elte.hu, rja@sgi.com, sivanich@sgi.com, steiner@sgi.com, tglx@linutronix.de, travis@sgi.com


The patch titled
     uv_irq.c: fix all sparse warnings
has been added to the -mm tree.  Its filename is
     uv_irqc-fix-all-sparse-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uv_irq.c: fix all sparse warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix all sparse warnings in building uv_irq.c.

arch/x86/kernel/uv_irq.c:46:17: warning: symbol 'uv_irq_chip' was not declared. Should it be static?
arch/x86/kernel/uv_irq.c:143:50: error: no identifier for function argument
arch/x86/kernel/uv_irq.c:162:13: error: typename in expression
arch/x86/kernel/uv_irq.c:162:13: error: undefined identifier 'restrict'
arch/x86/kernel/uv_irq.c:250:44: error: no identifier for function argument
arch/x86/kernel/uv_irq.c:260:17: error: typename in expression
arch/x86/kernel/uv_irq.c:260:17: error: undefined identifier 'restrict'
arch/x86/kernel/uv_irq.c:233:50: warning: incorrect type in argument 3 (different signedness)
arch/x86/kernel/uv_irq.c:233:50:    expected int *pnode
arch/x86/kernel/uv_irq.c:233:50:    got unsigned int *<noident>
arch/x86/include/asm/uv/uv_hub.h:318:44: warning: incorrect type in argument 2 (different address spaces)
arch/x86/include/asm/uv/uv_hub.h:318:44:    expected void volatile [noderef] <asn:2>*addr
arch/x86/include/asm/uv/uv_hub.h:318:44:    got unsigned long *

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv_hub.h |    2 +-
 arch/x86/kernel/uv_irq.c         |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/x86/include/asm/uv/uv_hub.h~uv_irqc-fix-all-sparse-warnings arch/x86/include/asm/uv/uv_hub.h
--- a/arch/x86/include/asm/uv/uv_hub.h~uv_irqc-fix-all-sparse-warnings
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -307,7 +307,7 @@ static inline unsigned long uv_read_glob
  * Access Global MMR space using the MMR space located at the top of physical
  * memory.
  */
-static inline unsigned long *uv_global_mmr64_address(int pnode, unsigned long offset)
+static inline volatile void __iomem *uv_global_mmr64_address(int pnode, unsigned long offset)
 {
 	return __va(UV_GLOBAL_MMR64_BASE |
 		    UV_GLOBAL_MMR64_PNODE_BITS(pnode) | offset);
diff -puN arch/x86/kernel/uv_irq.c~uv_irqc-fix-all-sparse-warnings arch/x86/kernel/uv_irq.c
--- a/arch/x86/kernel/uv_irq.c~uv_irqc-fix-all-sparse-warnings
+++ a/arch/x86/kernel/uv_irq.c
@@ -44,7 +44,7 @@ static void uv_ack_apic(unsigned int irq
 	ack_APIC_irq();
 }
 
-struct irq_chip uv_irq_chip = {
+static struct irq_chip uv_irq_chip = {
 	.name		= "UV-CORE",
 	.startup	= uv_noop_ret,
 	.shutdown	= uv_noop,
@@ -141,7 +141,7 @@ int uv_irq_2_mmr_info(int irq, unsigned 
  */
 static int
 arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
-		       unsigned long mmr_offset, int restrict)
+		       unsigned long mmr_offset, int limit)
 {
 	const struct cpumask *eligible_cpu = cpumask_of(cpu);
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -160,7 +160,7 @@ arch_enable_uv_irq(char *irq_name, unsig
 	if (err != 0)
 		return err;
 
-	if (restrict == UV_AFFINITY_CPU)
+	if (limit == UV_AFFINITY_CPU)
 		desc->status |= IRQ_NO_BALANCING;
 	else
 		desc->status |= IRQ_MOVE_PCNTXT;
@@ -214,7 +214,7 @@ static int uv_set_irq_affinity(unsigned 
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
 	unsigned long mmr_offset;
-	unsigned mmr_pnode;
+	int mmr_pnode;
 
 	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
@@ -248,7 +248,7 @@ static int uv_set_irq_affinity(unsigned 
  * interrupt is raised.
  */
 int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
-		 unsigned long mmr_offset, int restrict)
+		 unsigned long mmr_offset, int limit)
 {
 	int irq, ret;
 
@@ -258,7 +258,7 @@ int uv_setup_irq(char *irq_name, int cpu
 		return -EBUSY;
 
 	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset,
-		restrict);
+		limit);
 	if (ret == irq)
 		uv_set_irq_2_mmr_info(irq, mmr_offset, mmr_blade);
 	else
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
uv_irqc-fix-all-sparse-warnings.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
usb-fix-serial-build-when-sysrq-is-disabled.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled-checkpatch-fixes.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

