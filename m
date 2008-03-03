From: akpm@linux-foundation.org
Subject: + ppc-replace-remaining-__function__-occurences.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:34:47 -0800
Message-ID: <200803032134.m23LYlHk007738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbYCCVfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:35:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     ppc: replace remaining __FUNCTION__ occurences
has been added to the -mm tree.  Its filename is
     ppc-replace-remaining-__function__-occurences.patch

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
Subject: ppc: replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/8xx_io/fec.c               |    4 ++--
 arch/ppc/platforms/radstone_ppc7d.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/ppc/8xx_io/fec.c~ppc-replace-remaining-__function__-occurences arch/ppc/8xx_io/fec.c
--- a/arch/ppc/8xx_io/fec.c~ppc-replace-remaining-__function__-occurences
+++ a/arch/ppc/8xx_io/fec.c
@@ -520,7 +520,7 @@ fec_enet_interrupt(int irq, void * dev_i
 #ifdef	CONFIG_USE_MDIO
 			fec_enet_mii(dev);
 #else
-printk("%s[%d] %s: unexpected FEC_ENET_MII event\n", __FILE__,__LINE__,__FUNCTION__);
+printk("%s[%d] %s: unexpected FEC_ENET_MII event\n", __FILE__, __LINE__, __func__);
 #endif	/* CONFIG_USE_MDIO */
 		}
 
@@ -1441,7 +1441,7 @@ irqreturn_t mii_link_interrupt(int irq, 
 		fecp->fec_ecntrl = ecntrl;	/* restore old settings */
 	}
 #else
-printk("%s[%d] %s: unexpected Link interrupt\n", __FILE__,__LINE__,__FUNCTION__);
+printk("%s[%d] %s: unexpected Link interrupt\n", __FILE__, __LINE__, __func__);
 #endif	/* CONFIG_USE_MDIO */
 
 #ifndef CONFIG_RPXCLASSIC
diff -puN arch/ppc/platforms/radstone_ppc7d.c~ppc-replace-remaining-__function__-occurences arch/ppc/platforms/radstone_ppc7d.c
--- a/arch/ppc/platforms/radstone_ppc7d.c~ppc-replace-remaining-__function__-occurences
+++ a/arch/ppc/platforms/radstone_ppc7d.c
@@ -512,7 +512,7 @@ static void __init ppc7d_init_irq(void)
 {
 	int irq;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 	i8259_init(0, 0);
 	mv64360_init_irq();
 
@@ -569,7 +569,7 @@ static int __init ppc7d_map_irq(struct p
 	};
 	const long min_idsel = 10, max_idsel = 14, irqs_per_slot = 4;
 
-	pr_debug("%s: %04x/%04x/%x: idsel=%hx pin=%hu\n", __FUNCTION__,
+	pr_debug("%s: %04x/%04x/%x: idsel=%hx pin=%hu\n", __func__,
 		 dev->vendor, dev->device, PCI_FUNC(dev->devfn), idsel, pin);
 
 	return PCI_IRQ_TABLE_LOOKUP;
@@ -1300,7 +1300,7 @@ static void ppc7d_init2(void)
 	u32 data;
 	u8 data8;
 
-	pr_debug("%s: enter\n", __FUNCTION__);
+	pr_debug("%s: enter\n", __func__);
 
 	/* Wait for debugger? */
 	if (ppc7d_wait_debugger) {
@@ -1333,7 +1333,7 @@ static void ppc7d_init2(void)
         ppc_md.set_rtc_time = ppc7d_set_rtc_time;
         ppc_md.get_rtc_time = ppc7d_get_rtc_time;
 
-	pr_debug("%s: exit\n", __FUNCTION__);
+	pr_debug("%s: exit\n", __func__);
 }
 
 /* Called from machine_init(), early, before any of the __init functions
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
specialixc-fix-possible-double-unlock.patch
git-x86.patch
git-alsa.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
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
sh-replace-remaining-__function__-occurences.patch
xtensa-replace-remaining-__function__-occueance.patch
uml-replace-remaining-__function__-occueance.patch

