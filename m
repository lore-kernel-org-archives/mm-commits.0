From: akpm@linux-foundation.org
Subject: - null-pointer-in-ia64-irq_chip-mask-unmask-function-v2.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:59:58 -0800
Message-ID: <200703152159.l2FLxwku027854@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42646 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXCOWAP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:00:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, jlan@sgi.com, prarit@redhat.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     NULL pointer in ia64/irq_chip-mask/unmask function (V2)
has been removed from the -mm tree.  Its filename was
     null-pointer-in-ia64-irq_chip-mask-unmask-function-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 arch/ia64/kernel/iosapic.c |    8 ++++++--
 arch/ia64/sn/kernel/irq.c  |   14 +++++++++++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/iosapic.c~null-pointer-in-ia64-irq_chip-mask-unmask-function-v2 arch/ia64/kernel/iosapic.c
--- a/arch/ia64/kernel/iosapic.c~null-pointer-in-ia64-irq_chip-mask-unmask-function-v2
+++ a/arch/ia64/kernel/iosapic.c
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
@@ -205,7 +205,17 @@ static void sn_set_affinity_irq(unsigned
 		(void)sn_retarget_vector(sn_irq_info, nasid, slice);
 }
 
-struct hw_interrupt_type irq_type_sn = {
+static void
+sn_mask_irq(unsigned int irq)
+{
+}
+
+static void
+sn_unmask_irq(unsigned int irq)
+{
+}
+
+struct irq_chip irq_type_sn = {
 	.name		= "SN hub",
 	.startup	= sn_startup_irq,
 	.shutdown	= sn_shutdown_irq,
@@ -213,6 +223,8 @@ struct hw_interrupt_type irq_type_sn = {
 	.disable	= sn_disable_irq,
 	.ack		= sn_ack_irq,
 	.end		= sn_end_irq,
+	.mask		= sn_mask_irq,
+	.unmask		= sn_unmask_irq,
 	.set_affinity	= sn_set_affinity_irq
 };
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
