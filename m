From: akpm@linux-foundation.org
Subject: + pcmcia-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 19:50:13 -0800
Message-ID: <200803060350.m263oDrM007338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbYCFD6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 22:58:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     pcmcia: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     pcmcia-replace-remaining-__function__-occurrences.patch

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
Subject: pcmcia: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/au1000_db1x00.c     |    6 +++---
 drivers/pcmcia/au1000_pb1x00.c     |   14 +++++++-------
 drivers/pcmcia/au1000_xxs1500.c    |    2 +-
 drivers/pcmcia/omap_cf.c           |    2 +-
 drivers/pcmcia/pxa2xx_lubbock.c    |    8 ++++----
 drivers/pcmcia/pxa2xx_mainstone.c  |    4 ++--
 drivers/pcmcia/sa1100_assabet.c    |    4 ++--
 drivers/pcmcia/sa1100_badge4.c     |    8 ++++----
 drivers/pcmcia/sa1100_cerf.c       |    2 +-
 drivers/pcmcia/sa1100_jornada720.c |    4 ++--
 drivers/pcmcia/sa1100_neponset.c   |    4 ++--
 drivers/pcmcia/sa1100_shannon.c    |    8 ++++----
 drivers/pcmcia/sa1100_simpad.c     |    2 +-
 drivers/pcmcia/soc_common.c        |    2 +-
 14 files changed, 35 insertions(+), 35 deletions(-)

diff -puN drivers/pcmcia/au1000_db1x00.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/au1000_db1x00.c
--- a/drivers/pcmcia/au1000_db1x00.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/au1000_db1x00.c
@@ -194,7 +194,7 @@ db1x00_pcmcia_configure_socket(struct au
 				default:
 					pwr |= SET_VCC_VPP(0,0,sock);
 					printk("%s: bad Vcc/Vpp (%d:%d)\n",
-							__FUNCTION__,
+							__func__,
 							state->Vcc,
 							state->Vpp);
 					break;
@@ -215,7 +215,7 @@ db1x00_pcmcia_configure_socket(struct au
 				default:
 					pwr |= SET_VCC_VPP(0,0,sock);
 					printk("%s: bad Vcc/Vpp (%d:%d)\n",
-							__FUNCTION__,
+							__func__,
 							state->Vcc,
 							state->Vpp);
 					break;
@@ -224,7 +224,7 @@ db1x00_pcmcia_configure_socket(struct au
 		default: /* what's this ? */
 			pwr |= SET_VCC_VPP(0,0,sock);
 			printk(KERN_ERR "%s: bad Vcc %d\n",
-					__FUNCTION__, state->Vcc);
+					__func__, state->Vcc);
 			break;
 	}
 
diff -puN drivers/pcmcia/au1000_pb1x00.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/au1000_pb1x00.c
--- a/drivers/pcmcia/au1000_pb1x00.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/au1000_pb1x00.c
@@ -244,7 +244,7 @@ pb1x00_pcmcia_configure_socket(const str
 					pcr |= SET_VCC_VPP(VCC_HIZ,VPP_HIZ,
 							configure->sock);
 					printk("%s: bad Vcc/Vpp (%d:%d)\n", 
-							__FUNCTION__, 
+							__func__,
 							configure->vcc, 
 							configure->vpp);
 					break;
@@ -272,7 +272,7 @@ pb1x00_pcmcia_configure_socket(const str
 					pcr |= SET_VCC_VPP(VCC_HIZ,VPP_HIZ,
 							configure->sock);
 					printk("%s: bad Vcc/Vpp (%d:%d)\n", 
-							__FUNCTION__, 
+							__func__,
 							configure->vcc, 
 							configure->vpp);
 					break;
@@ -300,7 +300,7 @@ pb1x00_pcmcia_configure_socket(const str
 					pcr |= SET_VCC_VPP(VCC_HIZ,VPP_HIZ,
 							configure->sock);
 					printk("%s: bad Vcc/Vpp (%d:%d)\n", 
-							__FUNCTION__, 
+							__func__,
 							configure->vcc, 
 							configure->vpp);
 					break;
@@ -309,7 +309,7 @@ pb1x00_pcmcia_configure_socket(const str
 		default: /* what's this ? */
 			pcr |= SET_VCC_VPP(VCC_HIZ,VPP_HIZ,configure->sock);
 			printk(KERN_ERR "%s: bad Vcc %d\n", 
-					__FUNCTION__, configure->vcc);
+					__func__, configure->vcc);
 			break;
 	}
 
@@ -353,7 +353,7 @@ pb1x00_pcmcia_configure_socket(const str
 				default:
 					pcr |= SET_VCC_VPP(0,0);
 					printk("%s: bad Vcc/Vpp (%d:%d)\n", 
-							__FUNCTION__, 
+							__func__,
 							configure->vcc, 
 							configure->vpp);
 					break;
@@ -374,7 +374,7 @@ pb1x00_pcmcia_configure_socket(const str
 				default:
 					pcr |= SET_VCC_VPP(0,0);
 					printk("%s: bad Vcc/Vpp (%d:%d)\n", 
-							__FUNCTION__, 
+							__func__,
 							configure->vcc, 
 							configure->vpp);
 					break;
@@ -383,7 +383,7 @@ pb1x00_pcmcia_configure_socket(const str
 		default: /* what's this ? */
 			pcr |= SET_VCC_VPP(0,0);
 			printk(KERN_ERR "%s: bad Vcc %d\n", 
-					__FUNCTION__, configure->vcc);
+					__func__, configure->vcc);
 			break;
 	}
 
diff -puN drivers/pcmcia/au1000_xxs1500.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/au1000_xxs1500.c
--- a/drivers/pcmcia/au1000_xxs1500.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/au1000_xxs1500.c
@@ -56,7 +56,7 @@
 #define PCMCIA_IRQ		AU1000_GPIO_4
 
 #if 0
-#define DEBUG(x,args...)	printk(__FUNCTION__ ": " x,##args)
+#define DEBUG(x, args...)	printk(__func__ ": " x, ##args)
 #else
 #define DEBUG(x,args...)
 #endif
diff -puN drivers/pcmcia/omap_cf.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/omap_cf.c
--- a/drivers/pcmcia/omap_cf.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/omap_cf.c
@@ -153,7 +153,7 @@ omap_cf_set_socket(struct pcmcia_socket 
 
 static int omap_cf_ss_suspend(struct pcmcia_socket *s)
 {
-	pr_debug("%s: %s\n", driver_name, __FUNCTION__);
+	pr_debug("%s: %s\n", driver_name, __func__);
 	return omap_cf_set_socket(s, &dead_socket);
 }
 
diff -puN drivers/pcmcia/pxa2xx_lubbock.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/pxa2xx_lubbock.c
--- a/drivers/pcmcia/pxa2xx_lubbock.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/pxa2xx_lubbock.c
@@ -87,7 +87,7 @@ lubbock_pcmcia_configure_socket(struct s
 
 		default:
 			printk(KERN_ERR "%s(): unrecognized Vcc %u\n",
-			       __FUNCTION__, state->Vcc);
+			       __func__, state->Vcc);
 			ret = -1;
 		}
 
@@ -104,7 +104,7 @@ lubbock_pcmcia_configure_socket(struct s
 				pa_dwr_set |= GPIO_A0;
 			else {
 				printk(KERN_ERR "%s(): unrecognized Vpp %u\n",
-				       __FUNCTION__, state->Vpp);
+				       __func__, state->Vpp);
 				ret = -1;
 				break;
 			}
@@ -128,14 +128,14 @@ lubbock_pcmcia_configure_socket(struct s
 
 		default:
 			printk(KERN_ERR "%s(): unrecognized Vcc %u\n",
-			       __FUNCTION__, state->Vcc);
+			       __func__, state->Vcc);
 			ret = -1;
 			break;
 		}
 
 		if (state->Vpp != state->Vcc && state->Vpp != 0) {
 			printk(KERN_ERR "%s(): CF slot cannot support Vpp %u\n",
-			       __FUNCTION__, state->Vpp);
+			       __func__, state->Vpp);
 			ret = -1;
 			break;
 		}
diff -puN drivers/pcmcia/pxa2xx_mainstone.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/pxa2xx_mainstone.c
--- a/drivers/pcmcia/pxa2xx_mainstone.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/pxa2xx_mainstone.c
@@ -99,7 +99,7 @@ static int mst_pcmcia_configure_socket(s
 	case 50: power |= MST_PCMCIA_PWR_VCC_50; break;
 	default:
 		 printk(KERN_ERR "%s(): bad Vcc %u\n",
-				 __FUNCTION__, state->Vcc);
+				 __func__, state->Vcc);
 		 ret = -1;
 	}
 
@@ -111,7 +111,7 @@ static int mst_pcmcia_configure_socket(s
 			  power |= MST_PCMCIA_PWR_VPP_VCC;
 		  } else {
 			  printk(KERN_ERR "%s(): bad Vpp %u\n",
-					  __FUNCTION__, state->Vpp);
+					  __func__, state->Vpp);
 			  ret = -1;
 		  }
 	}
diff -puN drivers/pcmcia/sa1100_assabet.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/sa1100_assabet.c
--- a/drivers/pcmcia/sa1100_assabet.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/sa1100_assabet.c
@@ -66,14 +66,14 @@ assabet_pcmcia_configure_socket(struct s
 
 	case 50:
 		printk(KERN_WARNING "%s(): CS asked for 5V, applying 3.3V...\n",
-			__FUNCTION__);
+			__func__);
 
 	case 33:  /* Can only apply 3.3V to the CF slot. */
 		mask = ASSABET_BCR_CF_PWR;
 		break;
 
 	default:
-		printk(KERN_ERR "%s(): unrecognized Vcc %u\n", __FUNCTION__,
+		printk(KERN_ERR "%s(): unrecognized Vcc %u\n", __func__,
 			state->Vcc);
 		return -1;
 	}
diff -puN drivers/pcmcia/sa1100_badge4.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/sa1100_badge4.c
--- a/drivers/pcmcia/sa1100_badge4.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/sa1100_badge4.c
@@ -82,14 +82,14 @@ badge4_pcmcia_configure_socket(struct so
 	case 0:
 		if ((state->Vcc != 0) &&
 		    (state->Vcc != badge4_pcmvcc)) {
-			complain_about_jumpering(__FUNCTION__, "pcmvcc",
+			complain_about_jumpering(__func__, "pcmvcc",
 						 badge4_pcmvcc, state->Vcc);
 			// Apply power regardless of the jumpering.
 			// return -1;
 		}
 		if ((state->Vpp != 0) &&
 		    (state->Vpp != badge4_pcmvpp)) {
-			complain_about_jumpering(__FUNCTION__, "pcmvpp",
+			complain_about_jumpering(__func__, "pcmvpp",
 						 badge4_pcmvpp, state->Vpp);
 			return -1;
 		}
@@ -98,7 +98,7 @@ badge4_pcmcia_configure_socket(struct so
 	case 1:
 		if ((state->Vcc != 0) &&
 		    (state->Vcc != badge4_cfvcc)) {
-			complain_about_jumpering(__FUNCTION__, "cfvcc",
+			complain_about_jumpering(__func__, "cfvcc",
 						 badge4_cfvcc, state->Vcc);
 			return -1;
 		}
@@ -143,7 +143,7 @@ int pcmcia_badge4_init(struct device *de
 	if (machine_is_badge4()) {
 		printk(KERN_INFO
 		       "%s: badge4_pcmvcc=%d, badge4_pcmvpp=%d, badge4_cfvcc=%d\n",
-		       __FUNCTION__,
+		       __func__,
 		       badge4_pcmvcc, badge4_pcmvpp, badge4_cfvcc);
 
 		ret = sa11xx_drv_pcmcia_probe(dev, &badge4_pcmcia_ops, 0, 2);
diff -puN drivers/pcmcia/sa1100_cerf.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/sa1100_cerf.c
--- a/drivers/pcmcia/sa1100_cerf.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/sa1100_cerf.c
@@ -63,7 +63,7 @@ cerf_pcmcia_configure_socket(struct soc_
 
 	default:
 		printk(KERN_ERR "%s(): unrecognized Vcc %u\n",
-			__FUNCTION__, state->Vcc);
+			__func__, state->Vcc);
 		return -1;
 	}
 
diff -puN drivers/pcmcia/sa1100_jornada720.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/sa1100_jornada720.c
--- a/drivers/pcmcia/sa1100_jornada720.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/sa1100_jornada720.c
@@ -42,7 +42,7 @@ jornada720_pcmcia_configure_socket(struc
   unsigned int pa_dwr_mask, pa_dwr_set;
   int ret;
 
-printk("%s(): config socket %d vcc %d vpp %d\n", __FUNCTION__,
+printk("%s(): config socket %d vcc %d vpp %d\n", __func__,
 	skt->nr, state->Vcc, state->Vpp);
 
   switch (skt->nr) {
@@ -74,7 +74,7 @@ printk("%s(): config socket %d vcc %d vp
 
   if (state->Vpp != state->Vcc && state->Vpp != 0) {
     printk(KERN_ERR "%s(): slot cannot support VPP %u\n",
-	   __FUNCTION__, state->Vpp);
+	   __func__, state->Vpp);
     return -1;
   }
 
diff -puN drivers/pcmcia/sa1100_neponset.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/sa1100_neponset.c
--- a/drivers/pcmcia/sa1100_neponset.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/sa1100_neponset.c
@@ -59,7 +59,7 @@ neponset_pcmcia_configure_socket(struct 
 			ncr_set = NCR_A0VPP;
 		else {
 			printk(KERN_ERR "%s(): unrecognized VPP %u\n",
-			       __FUNCTION__, state->Vpp);
+			       __func__, state->Vpp);
 			return -1;
 		}
 		break;
@@ -71,7 +71,7 @@ neponset_pcmcia_configure_socket(struct 
 
 		if (state->Vpp != state->Vcc && state->Vpp != 0) {
 			printk(KERN_ERR "%s(): CF slot cannot support VPP %u\n",
-			       __FUNCTION__, state->Vpp);
+			       __func__, state->Vpp);
 			return -1;
 		}
 		break;
diff -puN drivers/pcmcia/sa1100_shannon.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/sa1100_shannon.c
--- a/drivers/pcmcia/sa1100_shannon.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/sa1100_shannon.c
@@ -73,19 +73,19 @@ shannon_pcmcia_configure_socket(struct s
 {
 	switch (state->Vcc) {
 	case 0:	/* power off */
-		printk(KERN_WARNING "%s(): CS asked for 0V, still applying 3.3V..\n", __FUNCTION__);
+		printk(KERN_WARNING "%s(): CS asked for 0V, still applying 3.3V..\n", __func__);
 		break;
 	case 50:
-		printk(KERN_WARNING "%s(): CS asked for 5V, applying 3.3V..\n", __FUNCTION__);
+		printk(KERN_WARNING "%s(): CS asked for 5V, applying 3.3V..\n", __func__);
 	case 33:
 		break;
 	default:
 		printk(KERN_ERR "%s(): unrecognized Vcc %u\n",
-		       __FUNCTION__, state->Vcc);
+		       __func__, state->Vcc);
 		return -1;
 	}
 
-	printk(KERN_WARNING "%s(): Warning, Can't perform reset\n", __FUNCTION__);
+	printk(KERN_WARNING "%s(): Warning, Can't perform reset\n", __func__);
 	
 	/* Silently ignore Vpp, output enable, speaker enable. */
 
diff -puN drivers/pcmcia/sa1100_simpad.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/sa1100_simpad.c
--- a/drivers/pcmcia/sa1100_simpad.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/sa1100_simpad.c
@@ -90,7 +90,7 @@ simpad_pcmcia_configure_socket(struct so
 
 	default:
 		printk(KERN_ERR "%s(): unrecognized Vcc %u\n",
-			__FUNCTION__, state->Vcc);
+			__func__, state->Vcc);
 		clear_cs3_bit(VCC_3V_EN|VCC_5V_EN|EN0|EN1);
 		local_irq_restore(flags);
 		return -1;
diff -puN drivers/pcmcia/soc_common.c~pcmcia-replace-remaining-__function__-occurrences drivers/pcmcia/soc_common.c
--- a/drivers/pcmcia/soc_common.c~pcmcia-replace-remaining-__function__-occurrences
+++ a/drivers/pcmcia/soc_common.c
@@ -353,7 +353,7 @@ soc_common_pcmcia_set_io_map(struct pcmc
 		(map->flags&MAP_PREFETCH)?"PREFETCH ":"");
 
 	if (map->map >= MAX_IO_WIN) {
-		printk(KERN_ERR "%s(): map (%d) out of range\n", __FUNCTION__,
+		printk(KERN_ERR "%s(): map (%d) out of range\n", __func__,
 		       map->map);
 		return -1;
 	}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
drivers-base-replace-remaining-__function__-occurrences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
jfs-replace-__inline-with-inline.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
mips-replace-__inline-with-inline.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
net-replace-__inline-with-inline.patch
irda-replace-__inline-with-inline.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
sh-replace-remaining-__function__-occurences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
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
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
isdn-replace-__inline-with-inline.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
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
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch
acpi-replace-remaining-__function__-occurrences.patch
ata-replace-remaining-__function__-occurrences.patch
block-replace-remaining-__function__-occurrences.patch
iop-admac-replace-remaining-__function__-occurrences.patch
ieee1394-replace-remaining-__function__-occurrences.patch
firmware-replace-remaining-__function__-occurrences.patch
mtd-replace-remaining-__function__-occurrences.patch
md-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
watchdog-replace-remaining-__function__-occurrences.patch
spi-replace-remaining-__function__-occurrences.patch
power-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

