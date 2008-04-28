From: akpm@linux-foundation.org
Subject: - m68k-replace-remaining-__function__-occurences.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:38 -0700
Message-ID: <200804282154.m3SLsc5n018026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935674AbYD1Vys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     m68k-replace-remaining-__function__-occurences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/ints.c |   10 +++++-----
 arch/m68k/mac/oss.c     |    4 ++--
 arch/m68k/q40/q40ints.c |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/m68k/kernel/ints.c~m68k-replace-remaining-__function__-occurences arch/m68k/kernel/ints.c
--- a/arch/m68k/kernel/ints.c~m68k-replace-remaining-__function__-occurences
+++ a/arch/m68k/kernel/ints.c
@@ -186,7 +186,7 @@ int setup_irq(unsigned int irq, struct i
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
 		printk("%s: Incorrect IRQ %d from %s\n",
-		       __FUNCTION__, irq, node->devname);
+		       __func__, irq, node->devname);
 		return -ENXIO;
 	}
 
@@ -249,7 +249,7 @@ void free_irq(unsigned int irq, void *de
 	unsigned long flags;
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
-		printk("%s: Incorrect IRQ %d\n", __FUNCTION__, irq);
+		printk("%s: Incorrect IRQ %d\n", __func__, irq);
 		return;
 	}
 
@@ -267,7 +267,7 @@ void free_irq(unsigned int irq, void *de
 		node->handler = NULL;
 	} else
 		printk("%s: Removing probably wrong IRQ %d\n",
-		       __FUNCTION__, irq);
+		       __func__, irq);
 
 	if (!irq_list[irq]) {
 		if (contr->shutdown)
@@ -288,7 +288,7 @@ void enable_irq(unsigned int irq)
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
 		printk("%s: Incorrect IRQ %d\n",
-		       __FUNCTION__, irq);
+		       __func__, irq);
 		return;
 	}
 
@@ -312,7 +312,7 @@ void disable_irq(unsigned int irq)
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
 		printk("%s: Incorrect IRQ %d\n",
-		       __FUNCTION__, irq);
+		       __func__, irq);
 		return;
 	}
 
diff -puN arch/m68k/mac/oss.c~m68k-replace-remaining-__function__-occurences arch/m68k/mac/oss.c
--- a/arch/m68k/mac/oss.c~m68k-replace-remaining-__function__-occurences
+++ a/arch/m68k/mac/oss.c
@@ -190,7 +190,7 @@ void oss_irq_enable(int irq) {
 			break;
 #ifdef DEBUG_IRQUSE
 		default:
-			printk("%s unknown irq %d\n",__FUNCTION__, irq);
+			printk("%s unknown irq %d\n", __func__, irq);
 			break;
 #endif
 	}
@@ -230,7 +230,7 @@ void oss_irq_disable(int irq) {
 			break;
 #ifdef DEBUG_IRQUSE
 		default:
-			printk("%s unknown irq %d\n", __FUNCTION__, irq);
+			printk("%s unknown irq %d\n", __func__, irq);
 			break;
 #endif
 	}
diff -puN arch/m68k/q40/q40ints.c~m68k-replace-remaining-__function__-occurences arch/m68k/q40/q40ints.c
--- a/arch/m68k/q40/q40ints.c~m68k-replace-remaining-__function__-occurences
+++ a/arch/m68k/q40/q40ints.c
@@ -47,7 +47,7 @@ static int q40_irq_startup(unsigned int 
 	switch (irq) {
 	case 1: case 2: case 8: case 9:
 	case 11: case 12: case 13:
-		printk("%s: ISA IRQ %d not implemented by HW\n", __FUNCTION__, irq);
+		printk("%s: ISA IRQ %d not implemented by HW\n", __func__, irq);
 		return -ENXIO;
 	}
 	return 0;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
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
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

