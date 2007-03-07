From: akpm@linux-foundation.org
Subject: + null-pointer-in-ia64-irq_chip-mask-unmask-function-v2.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:35:45 -0800
Message-ID: <200703072235.l27MZjuH011399@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35096 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965716AbXCGWft (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 17:35:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, tony.luck@intel.com


The patch titled
     NULL pointer in ia64/irq_chip-mask/unmask function (V2)
has been added to the -mm tree.  Its filename is
     null-pointer-in-ia64-irq_chip-mask-unmask-function-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NULL pointer in ia64/irq_chip-mask/unmask function (V2)
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch fixes boot failure because irq_desc->mask() is NULL.

- Added mask/unmask functions to ia64's irq desc function table.
- rename hw_interrupt_type to irq_chip. hw_interrupt_type is old name.
- Tony: Added same change to arch/ia64/sn/kernel/irq.c as pointed out
  by Eric Biederman

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/iosapic.c |   12 ++++++++----
 arch/ia64/sn/kernel/irq.c  |    5 ++++-
 include/asm-ia64/iosapic.h |    4 ++++
 3 files changed, 16 insertions(+), 5 deletions(-)

diff -puN arch/ia64/kernel/iosapic.c~null-pointer-in-ia64-irq_chip-mask-unmask-function-v2 arch/ia64/kernel/iosapic.c
--- a/arch/ia64/kernel/iosapic.c~null-pointer-in-ia64-irq_chip-mask-unmask-function-v2
+++ a/arch/ia64/kernel/iosapic.c
@@ -309,7 +309,7 @@ kexec_disable_iosapic(void)
 }
 #endif
 
-static void
+void
 mask_irq (unsigned int irq)
 {
 	unsigned long flags;
@@ -336,7 +336,7 @@ mask_irq (unsigned int irq)
 	spin_unlock_irqrestore(&iosapic_lock, flags);
 }
 
-static void
+void
 unmask_irq (unsigned int irq)
 {
 	unsigned long flags;
@@ -446,7 +446,7 @@ iosapic_end_level_irq (unsigned int irq)
 #define iosapic_disable_level_irq	mask_irq
 #define iosapic_ack_level_irq		nop
 
-struct hw_interrupt_type irq_type_iosapic_level = {
+struct irq_chip irq_type_iosapic_level = {
 	.name =		"IO-SAPIC-level",
 	.startup =	iosapic_startup_level_irq,
 	.shutdown =	iosapic_shutdown_level_irq,
@@ -454,6 +454,8 @@ struct hw_interrupt_type irq_type_iosapi
 	.disable =	iosapic_disable_level_irq,
 	.ack =		iosapic_ack_level_irq,
 	.end =		iosapic_end_level_irq,
+	.mask =		mask_irq,
+	.unmask =	unmask_irq,
 	.set_affinity =	iosapic_set_affinity
 };
 
@@ -493,7 +495,7 @@ iosapic_ack_edge_irq (unsigned int irq)
 #define iosapic_disable_edge_irq	nop
 #define iosapic_end_edge_irq		nop
 
-struct hw_interrupt_type irq_type_iosapic_edge = {
+struct irq_chip irq_type_iosapic_edge = {
 	.name =		"IO-SAPIC-edge",
 	.startup =	iosapic_startup_edge_irq,
 	.shutdown =	iosapic_disable_edge_irq,
@@ -501,6 +503,8 @@ struct hw_interrupt_type irq_type_iosapi
 	.disable =	iosapic_disable_edge_irq,
 	.ack =		iosapic_ack_edge_irq,
 	.end =		iosapic_end_edge_irq,
+	.mask =		mask_irq,
+	.unmask =	unmask_irq,
 	.set_affinity =	iosapic_set_affinity
 };
 
diff -puN arch/ia64/sn/kernel/irq.c~null-pointer-in-ia64-irq_chip-mask-unmask-function-v2 arch/ia64/sn/kernel/irq.c
--- a/arch/ia64/sn/kernel/irq.c~null-pointer-in-ia64-irq_chip-mask-unmask-function-v2
+++ a/arch/ia64/sn/kernel/irq.c
@@ -11,6 +11,7 @@
 #include <linux/irq.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <asm/iosapic.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/intr.h>
@@ -205,7 +206,7 @@ static void sn_set_affinity_irq(unsigned
 		(void)sn_retarget_vector(sn_irq_info, nasid, slice);
 }
 
-struct hw_interrupt_type irq_type_sn = {
+struct irq_chip irq_type_sn = {
 	.name		= "SN hub",
 	.startup	= sn_startup_irq,
 	.shutdown	= sn_shutdown_irq,
@@ -213,6 +214,8 @@ struct hw_interrupt_type irq_type_sn = {
 	.disable	= sn_disable_irq,
 	.ack		= sn_ack_irq,
 	.end		= sn_end_irq,
+	.mask		= mask_irq,
+	.unmask		= unmask_irq,
 	.set_affinity	= sn_set_affinity_irq
 };
 
diff -puN include/asm-ia64/iosapic.h~null-pointer-in-ia64-irq_chip-mask-unmask-function-v2 include/asm-ia64/iosapic.h
--- a/include/asm-ia64/iosapic.h~null-pointer-in-ia64-irq_chip-mask-unmask-function-v2
+++ a/include/asm-ia64/iosapic.h
@@ -73,6 +73,10 @@ static inline void iosapic_eoi(char __io
 extern void __init iosapic_system_init (int pcat_compat);
 extern int __devinit iosapic_init (unsigned long address,
 				    unsigned int gsi_base);
+
+extern void mask_irq (unsigned int irq);
+extern void unmask_irq (unsigned int irq);
+
 #ifdef CONFIG_HOTPLUG
 extern int iosapic_remove (unsigned int gsi_base);
 #else
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

null-pointer-in-ia64-irq_chip-mask-unmask-function-v2.patch
