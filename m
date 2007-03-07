From: akpm@linux-foundation.org
Subject: + fix-null-pointer-in-ia64-irq_chip-mask-unmask.patch added to -mm tree
Date: Tue, 06 Mar 2007 23:46:45 -0800
Message-ID: <200703070746.l277kjEr023359@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54840 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161309AbXCGHqu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 02:46:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com, tony.luck@intel.com


The patch titled
     ia64: fix NULL pointer in ia64/irq_chip-mask/unmask function
has been added to the -mm tree.  Its filename is
     fix-null-pointer-in-ia64-irq_chip-mask-unmask.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: fix NULL pointer in ia64/irq_chip-mask/unmask function
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch fixes boot failure because irq_desc->mask() is NULL.

- Added mask/unmask functions to ia64's irq desc function table.
  But I'm not sure this fix is correct or not. please review.

- rename hw_interrupt_type to irq_chip. hw_interrupt_type is old name.


Original BUG I met (following) was caused at irq 57:uhci_hcd:usb3.
 xxBUG DESCRIPTIONxx
 Unable to handle kernel NULL pointer dereference (address 0000000000000000)
yum-updatesd[3461]: Oops 11012296146944 [1]
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 vfat fat dm_mirror dm_mod button parport_pc lp parport sg tg3 e100 shpchp mii usb_storage lpfc scsi_transport_fc mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd

Pid: 3461, CPU 5, comm:         yum-updatesd
psr : 0000121008022018 ifs : 8000000000000286 ip  : [<a0000001000e02b1>]    Not tainted
ip is at move_native_irq+0x91/0x140
unat: 0000000000000000 pfs : 0000000000000205 rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 00000000005a56a9
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000100050430 b6  : a00000021b49d0c0 b7  : a000000100050400
f6  : 1003e0000000000000de0 f7  : 1003e0000000000000060
f8  : 1003e0000000000000025 f9  : 1003e00000000000022e0
f10 : 1003e0000000000000060 f11 : 1003e000000000000005d
r1  : a000000100d8d230 r2  : a0000001009f8c30 r3  : 0000000000005580
r8  : a000000100b8e178 r9  : 00000000000000ab r10 : 0000000000000039
r11 : 0000000000200000 r12 : e00001404b6f7e30 r13 : e00001404b6f0000
r14 : 0000000000200000 r15 : a0000001009f8c00 r16 : a000000100b5b160
r17 : 00000000dead4ead r18 : a0000001009f8c4c r19 : 0000000000000000
r20 : a000000100b5b110 r21 : a000000100b5b140 r22 : a000000100b5b110
r23 : 0050200500000874 r24 : a000000100ba98c0 r25 : a00000021b53d768
r26 : e00000018007e030 r27 : a000000100786238 r28 : e000000040004ae0
r29 : a0000001009f8c50 r30 : 0000000000000005 r31 : a0000001009f8c58

Call Trace:
 [<a000000100013e20>] show_stack+0x40/0xa0
                                sp=e00001404b6f79c0 bsp=e00001404b6f1030
 [<a0000001000147e0>] show_regs+0x840/0x880
                                sp=e00001404b6f7b90 bsp=e00001404b6f0fd0
 [<a000000100037de0>] die+0x1c0/0x2a0
                                sp=e00001404b6f7b90 bsp=e00001404b6f0f88
 [<a000000100647630>] ia64_do_page_fault+0x8d0/0xa00
                                sp=e00001404b6f7bb0 bsp=e00001404b6f0f38
 [<a00000010000bf80>] ia64_leave_kernel+0x0/0x270
                                sp=e00001404b6f7c60 bsp=e00001404b6f0f38
 [<a0000001000e02b0>] move_native_irq+0x90/0x140
                                sp=e00001404b6f7e30 bsp=e00001404b6f0f08
 [<a000000100050430>] iosapic_end_level_irq+0x30/0xe0
                                sp=e00001404b6f7e30 bsp=e00001404b6f0ee8
 [<a0000001000dac30>] __do_IRQ+0x390/0x3c0
                                sp=e00001404b6f7e30 bsp=e00001404b6f0ea8
 [<a000000100011620>] ia64_handle_irq+0x1e0/0x2e0
                                sp=e00001404b6f7e30 bsp=e00001404b6f0e78
 [<a00000010000bf80>] ia64_leave_kernel+0x0/0x270
                                sp=e00001404b6f7e30 bsp=e00001404b6f0e78
Kernel panic - not syncing: Aiee, killing interrupt handler!

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/iosapic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kernel/iosapic.c~fix-null-pointer-in-ia64-irq_chip-mask-unmask arch/ia64/kernel/iosapic.c
--- a/arch/ia64/kernel/iosapic.c~fix-null-pointer-in-ia64-irq_chip-mask-unmask
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
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

fix-null-pointer-in-ia64-irq_chip-mask-unmask.patch
