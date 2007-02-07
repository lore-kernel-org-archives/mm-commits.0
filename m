From: akpm@linux-foundation.org
Subject: + oss-use-array_size-macro-when-appropriate-2.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:05:24 -0800
Message-ID: <200702070005.l1705PH9001161@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56093 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030228AbXBGAFr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:05:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com


The patch titled
     OSS: Use ARRAY_SIZE macro when appropriate (2)
has been added to the -mm tree.  Its filename is
     oss-use-array_size-macro-when-appropriate-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OSS: Use ARRAY_SIZE macro when appropriate (2)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/au1550_ac97.c   |    4 ++--
 sound/oss/nec_vrc5477.c   |    4 ++--
 sound/oss/swarm_cs4297a.c |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN sound/oss/au1550_ac97.c~oss-use-array_size-macro-when-appropriate-2 sound/oss/au1550_ac97.c
--- a/sound/oss/au1550_ac97.c~oss-use-array_size-macro-when-appropriate-2
+++ a/sound/oss/au1550_ac97.c
@@ -1354,11 +1354,11 @@ au1550_ioctl(struct inode *inode, struct
 		((file->f_mode & FMODE_READ) && s->dma_adc.mapped);
 
 #ifdef DEBUG
-	for (count=0; count<sizeof(ioctl_str)/sizeof(ioctl_str[0]); count++) {
+	for (count = 0; count < ARRAY_SIZE(ioctl_str); count++) {
 		if (ioctl_str[count].cmd == cmd)
 			break;
 	}
-	if (count < sizeof(ioctl_str) / sizeof(ioctl_str[0]))
+	if (count < ARRAY_SIZE(ioctl_str))
 		pr_debug("ioctl %s, arg=0x%lxn", ioctl_str[count].str, arg);
 	else
 		pr_debug("ioctl 0x%x unknown, arg=0x%lx\n", cmd, arg);
diff -puN sound/oss/nec_vrc5477.c~oss-use-array_size-macro-when-appropriate-2 sound/oss/nec_vrc5477.c
--- a/sound/oss/nec_vrc5477.c~oss-use-array_size-macro-when-appropriate-2
+++ a/sound/oss/nec_vrc5477.c
@@ -1381,11 +1381,11 @@ static int vrc5477_ac97_ioctl(struct ino
 	int val, ret;
 
 #ifdef VRC5477_AC97_DEBUG
-	for (count=0; count<sizeof(ioctl_str)/sizeof(ioctl_str[0]); count++) {
+	for (count = 0; count < ARRAY_SIZE(ioctl_str); count++) {
 		if (ioctl_str[count].cmd == cmd)
 			break;
 	}
-	if (count < sizeof(ioctl_str)/sizeof(ioctl_str[0]))
+	if (count < ARRAY_SIZE(ioctl_str))
 		printk(KERN_INFO PFX "ioctl %s\n", ioctl_str[count].str);
 	else
 		printk(KERN_INFO PFX "ioctl unknown, 0x%x\n", cmd);
diff -puN sound/oss/swarm_cs4297a.c~oss-use-array_size-macro-when-appropriate-2 sound/oss/swarm_cs4297a.c
--- a/sound/oss/swarm_cs4297a.c~oss-use-array_size-macro-when-appropriate-2
+++ a/sound/oss/swarm_cs4297a.c
@@ -77,6 +77,7 @@
 #include <linux/poll.h>
 #include <linux/smp_lock.h>
 #include <linux/mutex.h>
+#include <linux/kernel.h>
 
 #include <asm/byteorder.h>
 #include <asm/dma.h>
@@ -2673,7 +2674,7 @@ static int __init cs4297a_init(void)
 #if 0
                 val = SOUND_MASK_LINE;
                 mixer_ioctl(s, SOUND_MIXER_WRITE_RECSRC, (unsigned long) &val);
-                for (i = 0; i < sizeof(initvol) / sizeof(initvol[0]); i++) {
+                for (i = 0; i < ARRAY_SIZE(initvol); i++) {
                         val = initvol[i].vol;
                         mixer_ioctl(s, initvol[i].mixch, (unsigned long) &val);
                 }
_

Patches currently in -mm which might be from darwish.07@gmail.com are

arch-arm-use-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
git-dvb.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
dvb-use-array_size-macro-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
atm-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
intel-agp-use-array_size-macro-when-appropriate.patch
reiserfs-use-array_size-macro-when-appropriate.patch
toshiba-acpi-use-array_size-macro-when-appropriate.patch
drm-use-array_size-macro-when-appropriate.patch
