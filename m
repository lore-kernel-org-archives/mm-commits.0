From: akpm@linux-foundation.org
Subject: - ppc-replace-remaining-__function__-occurences.patch removed from -mm tree
Date: Tue, 01 Apr 2008 14:37:45 -0700
Message-ID: <200804012137.m31LbjJV014858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761109AbYDAVht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ppc: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     ppc-replace-remaining-__function__-occurences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ppc: replace remaining __FUNCTION__ occurrences
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
git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
power-replace-remaining-__function__-occurrences.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
git-mips.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
git-s390.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-chc-fix-sparse-shadowed-variable-warnings.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
mac80211-michaelc-replace-macro-with-function.patch
mac80211-michaelc-use-unaligned-byteorder-helpers.patch
mac80211-michaelc-fold-initial-xor-into-block-helper.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

