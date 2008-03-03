From: akpm@linux-foundation.org
Subject: + mips-replace-remaining-__function__-occurences.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:28:18 -0800
Message-ID: <200803032128.m23LSItf007466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763230AbYCCV21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:28:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, ralf@linux-mips.org


The patch titled
     mips: replace remaining __FUNCTION__ occurences
has been added to the -mm tree.  Its filename is
     mips-replace-remaining-__function__-occurences.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/au1000/common/power.c                            |    2 +-
 arch/mips/kernel/signal-common.h                           |    2 +-
 arch/mips/pci/ops-pnx8550.c                                |    4 ++--
 arch/mips/sgi-ip32/ip32-reset.c                            |    2 +-
 arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c   |    2 +-
 arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/mips/au1000/common/power.c~mips-replace-remaining-__function__-occurences arch/mips/au1000/common/power.c
--- a/arch/mips/au1000/common/power.c~mips-replace-remaining-__function__-occurences
+++ a/arch/mips/au1000/common/power.c
@@ -47,7 +47,7 @@
 
 #define DEBUG 1
 #ifdef DEBUG
-#  define DPRINTK(fmt, args...)	printk("%s: " fmt, __FUNCTION__ , ## args)
+#  define DPRINTK(fmt, args...)	printk("%s: " fmt, __func__, ## args)
 #else
 #  define DPRINTK(fmt, args...)
 #endif
diff -puN arch/mips/kernel/signal-common.h~mips-replace-remaining-__function__-occurences arch/mips/kernel/signal-common.h
--- a/arch/mips/kernel/signal-common.h~mips-replace-remaining-__function__-occurences
+++ a/arch/mips/kernel/signal-common.h
@@ -14,7 +14,7 @@
 /* #define DEBUG_SIG */
 
 #ifdef DEBUG_SIG
-#  define DEBUGP(fmt, args...) printk("%s: " fmt, __FUNCTION__ , ##args)
+#  define DEBUGP(fmt, args...) printk("%s: " fmt, __func__, ##args)
 #else
 #  define DEBUGP(fmt, args...)
 #endif
diff -puN arch/mips/pci/ops-pnx8550.c~mips-replace-remaining-__function__-occurences arch/mips/pci/ops-pnx8550.c
--- a/arch/mips/pci/ops-pnx8550.c~mips-replace-remaining-__function__-occurences
+++ a/arch/mips/pci/ops-pnx8550.c
@@ -90,14 +90,14 @@ config_access(unsigned int pci_cmd, stru
 
 		loops--;
 		if (loops == 0) {
-			printk("%s : Arbiter Locked.\n", __FUNCTION__);
+			printk("%s : Arbiter Locked.\n", __func__);
 		}
 	}
 
 	clear_status();
 	if ((pci_cmd == PCI_CMD_IOR) || (pci_cmd == PCI_CMD_IOW)) {
 		printk("%s timeout (GPPM_CTRL=%X) ioaddr %lX pci_cmd %X\n",
-		       __FUNCTION__, inl(PCI_BASE | PCI_GPPM_CTRL), ioaddr,
+		       __func__, inl(PCI_BASE | PCI_GPPM_CTRL), ioaddr,
 		       pci_cmd);
 	}
 
diff -puN arch/mips/sgi-ip32/ip32-reset.c~mips-replace-remaining-__function__-occurences arch/mips/sgi-ip32/ip32-reset.c
--- a/arch/mips/sgi-ip32/ip32-reset.c~mips-replace-remaining-__function__-occurences
+++ a/arch/mips/sgi-ip32/ip32-reset.c
@@ -142,7 +142,7 @@ static irqreturn_t ip32_rtc_int(int irq,
 	reg_c = CMOS_READ(RTC_INTR_FLAGS);
 	if (!(reg_c & RTC_IRQF)) {
 		printk(KERN_WARNING
-			"%s: RTC IRQ without RTC_IRQF\n", __FUNCTION__);
+			"%s: RTC IRQ without RTC_IRQF\n", __func__);
 	}
 	/* Wait until interrupt goes away */
 	disable_irq(MACEISA_RTC_IRQ);
diff -puN arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c~mips-replace-remaining-__function__-occurences arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c
--- a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c~mips-replace-remaining-__function__-occurences
+++ a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c
@@ -173,7 +173,7 @@ static const u32 toshiba_rbtx4927_irq_de
         { \
            char tmp[100]; \
            sprintf( tmp, str ); \
-           printk( "%s(%s:%u)::%s", __FUNCTION__, __FILE__, __LINE__, tmp ); \
+           printk( "%s(%s:%u)::%s", __func__, __FILE__, __LINE__, tmp ); \
         }
 #else
 #define TOSHIBA_RBTX4927_IRQ_DPRINTK(flag, str...)
diff -puN arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c~mips-replace-remaining-__function__-occurences arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
--- a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c~mips-replace-remaining-__function__-occurences
+++ a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
@@ -93,7 +93,7 @@ static const u32 toshiba_rbtx4927_setup_
         { \
            char tmp[100]; \
            sprintf( tmp, str ); \
-           printk( "%s(%s:%u)::%s", __FUNCTION__, __FILE__, __LINE__, tmp ); \
+           printk( "%s(%s:%u)::%s", __func__, __FILE__, __LINE__, tmp ); \
         }
 #else
 #define TOSHIBA_RBTX4927_SETUP_DPRINTK(flag, str...)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
specialixc-fix-possible-double-unlock.patch
git-x86.patch
git-alsa.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-introduce-kprobe_handle_fault-ia64-fix.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
mips-replace-remaining-__function__-occurences.patch

