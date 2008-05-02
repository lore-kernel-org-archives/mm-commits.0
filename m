From: akpm@linux-foundation.org
Subject: - pcmcia-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:45 -0700
Message-ID: <200805021942.m42JgjJ7011220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932191AbYEBTmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     pcmcia-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -354,7 +354,7 @@ soc_common_pcmcia_set_io_map(struct pcmc
 		(map->flags&MAP_PREFETCH)?"PREFETCH ":"");
 
 	if (map->map >= MAX_IO_WIN) {
-		printk(KERN_ERR "%s(): map (%d) out of range\n", __FUNCTION__,
+		printk(KERN_ERR "%s(): map (%d) out of range\n", __func__,
 		       map->map);
 		return -1;
 	}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
misc-fix-integer-as-null-pointer-warnings.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
git-net.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
video-fix-integer-as-null-pointer-warnings.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch

