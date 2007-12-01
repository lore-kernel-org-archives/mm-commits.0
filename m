From: akpm@linux-foundation.org
Subject: - isdn-bootup-crash-fix-2624-rc3-git1.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:22:20 -0800
Message-ID: <200712010022.lB10MKqN031884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757664AbXLAA1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, kai@germaschewski.name, kkeil@suse.de, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     isdn: bootup crash fix
has been removed from the -mm tree.  Its filename was
     isdn-bootup-crash-fix-2624-rc3-git1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isdn: bootup crash fix
From: Ingo Molnar <mingo@elte.hu>

got this HiSax bootup crash on a "make randconfig" bzImage bootup:

 Calling initcall 0xc0bb1320: HiSax_init+0x0/0x380()
 HiSax: Linux Driver for passive ISDN cards
 HiSax: Version 3.5 (kernel)
 HiSax: Layer1 Revision 2.46.2.5
 HiSax: Layer2 Revision 2.30.2.4
 HiSax: TeiMgr Revision 2.20.2.3
 HiSax: Layer3 Revision 2.22.2.3
 HiSax: LinkLayer Revision 2.59.2.4
 HiSax: Total 1 card defined
 HiSax: Card 1 Protocol EDSS1 Id=HiSax (0)
 HiSax: HFC-S driver Rev. 1.10.2.4
 HFCS: defined at 0x500 IRQ 5 HZ 250
 Teles 16.3c: IRQ 5 count 0
 HFCS: resetting card
 Teles 16.3c: IRQ 5 count 0
 Teles 16.3c: IRQ(5) getting no interrupts during init 1
 HFCS: resetting card
 ------------[ cut here ]------------
 kernel BUG at include/linux/timer.h:145!
 invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
 Modules linked in:

 Pid: 1, comm: swapper Not tainted (2.6.24-rc3 #2045)
 EIP: 0060:[<c063afbf>] EFLAGS: 00010286 CPU: 0
 EIP is at hfcs_card_msg+0x15f/0x180
 EAX: c0cf2e5c EBX: 000000f2 ECX: 00000000 EDX: ffff1193
 ESI: f76e8000 EDI: f76e8000 EBP: f7c23ec4 ESP: f7c23eac
  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
 Process swapper (pid: 1, ti=f7c22000 task=f7c0e000 task.ti=f7c22000)
 Stack: 00000000 f7c23ec4 c011703b 00000002 f76e8000 00000000 f7c23ef8 c060c3e5
        c0a7c9c0 c0a315dc 00000005 00000001 00000000 f7c23f34 00000000 c0b5c9c0
        f7c23f34 00000000 c0f5a8e0 f7c23f80 c0bb154f 00000000 00000001 c0a9b5b9
 Call Trace:
  [<c010339a>] show_trace_log_lvl+0x1a/0x40
  [<c0103469>] show_stack_log_lvl+0xa9/0xe0
  [<c010355f>] show_registers+0xbf/0x200
  [<c01037a4>] die+0x104/0x220
  [<c0103943>] do_trap+0x83/0xc0
  [<c0103ca8>] do_invalid_op+0x88/0xa0
  [<c083621a>] error_code+0x6a/0x70
  [<c060c3e5>] checkcard+0x4a5/0x620
  [<c0bb154f>] HiSax_init+0x22f/0x380
  [<c0b867b7>] kernel_init+0x97/0x2a0
  [<c0102f87>] kernel_thread_helper+0x7/0x20
  =======================
 Code: e8 43 ae ff 8b 57 3c 85 d2 0f 84 ef fe ff ff b8 a0 99 ad c0 b9 02 00 00 00 e8 ce 11 ae ff 83 c4 0c b8 00 00 00 00 5b 5e 5f c9 c3 <0f> 0b eb fe 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
 EIP: [<c063afbf>] hfcs_card_msg+0x15f/0x180 SS:ESP 0068:f7c23eac
 Kernel panic - not syncing: Attempted to kill init!

The box has no HiSax card installed.

the reason for the crash is add_timer() done on an already running
timer. This happens because for some reason CARD_INIT is called twice.

this patch works this problem around by using mod_timer() - this gets
a booting system - but it would be nice to figure out why CARD_INIT
is done twice.

the ISDN config section (generated via make randconfig) is this:

#
# ISDN feature submodules
#
# CONFIG_ISDN_DRV_LOOP is not set
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
# CONFIG_HISAX_NO_SENDCOMPLETE is not set
# CONFIG_HISAX_NO_LLC is not set
# CONFIG_HISAX_NO_KEYPAD is not set
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_0=y
# CONFIG_HISAX_16_3 is not set
# CONFIG_HISAX_TELESPCI is not set
CONFIG_HISAX_S0BOX=y
# CONFIG_HISAX_AVM_A1 is not set
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_IX1MICROR2=y
CONFIG_HISAX_DIEHLDIVA=y
# CONFIG_HISAX_ASUSCOM is not set
# CONFIG_HISAX_TELEINT is not set
CONFIG_HISAX_HFCS=y
# CONFIG_HISAX_SEDLBAUER is not set
CONFIG_HISAX_SPORTSTER=y
# CONFIG_HISAX_MIC is not set
# CONFIG_HISAX_NETJET is not set
# CONFIG_HISAX_NETJET_U is not set
# CONFIG_HISAX_NICCY is not set
# CONFIG_HISAX_ISURF is not set
# CONFIG_HISAX_HSTSAPHIR is not set
# CONFIG_HISAX_BKM_A4T is not set
# CONFIG_HISAX_SCT_QUADRO is not set
# CONFIG_HISAX_GAZEL is not set
# CONFIG_HISAX_HFC_PCI is not set
# CONFIG_HISAX_W6692 is not set
# CONFIG_HISAX_HFC_SX is not set
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=y
CONFIG_HISAX_HFCUSB=y
# CONFIG_HISAX_HFC4S8S is not set
CONFIG_HISAX_FRITZ_PCIPNP=y
CONFIG_HISAX_HDLC=y

#
# Active cards
#
CONFIG_ISDN_DRV_ICN=m
CONFIG_ISDN_DRV_PCBIT=m
CONFIG_ISDN_DRV_SC=y
# CONFIG_ISDN_DRV_ACT2000 is not set
CONFIG_HYSDN=m
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_PHONE=y
CONFIG_PHONE_IXJ=m

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Kai Germaschewski <kai@germaschewski.name>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/hfcscard.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/isdn/hisax/hfcscard.c~isdn-bootup-crash-fix-2624-rc3-git1 drivers/isdn/hisax/hfcscard.c
--- a/drivers/isdn/hisax/hfcscard.c~isdn-bootup-crash-fix-2624-rc3-git1
+++ a/drivers/isdn/hisax/hfcscard.c
@@ -118,8 +118,7 @@ hfcs_card_msg(struct IsdnCardState *cs, 
 			return(0);
 		case CARD_INIT:
 			delay = (75*HZ)/100 +1;
-			cs->hw.hfcD.timer.expires = jiffies + delay;
-			add_timer(&cs->hw.hfcD.timer);
+			mod_timer(&cs->hw.hfcD.timer, jiffies + delay);
 			spin_lock_irqsave(&cs->lock, flags);
 			reset_hfcs(cs);
 			init2bds0(cs);
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
git-acpi.patch
git-alsa.patch
git-hrt.patch
revert-git-hrt.patch
git-kvm.patch
git-sched.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
merge-multiple-error-paths-in-alloc_uid-into-one.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
git-x86.patch
uml-add-asm-um-asmh.patch
x86_64-add-acpi-reboot-option.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
git-cryptodev-fixup.patch
fix-proc-net-breakage.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
fix-proc-dcache-deadlock-in-do_exit.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
avoid-overflows-in-kernel-timec.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
proc-fix-the-threaded-proc-self.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
