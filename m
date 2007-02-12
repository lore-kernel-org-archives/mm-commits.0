From: akpm@linux-foundation.org
Subject: - oss-use-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:43 -0800
Message-ID: <200702122243.l1CMhhhx013523@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030243AbXBLWnp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, mm-commits@vger.kernel.org


The patch titled
     OSS: Use ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     oss-use-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OSS: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/es1371.c    |    3 ++-
 sound/oss/soundcard.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN sound/oss/es1371.c~oss-use-array_size-macro-when-appropriate sound/oss/es1371.c
--- a/sound/oss/es1371.c~oss-use-array_size-macro-when-appropriate
+++ a/sound/oss/es1371.c
@@ -131,6 +131,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/mutex.h>
 #include <linux/mm.h>
+#include <linux/kernel.h>
 
 #include <asm/io.h>
 #include <asm/page.h>
@@ -2998,7 +2999,7 @@ static int __devinit es1371_probe(struct
 	set_fs(KERNEL_DS);
 	val = SOUND_MASK_LINE;
 	mixdev_ioctl(s->codec, SOUND_MIXER_WRITE_RECSRC, (unsigned long)&val);
-	for (i = 0; i < sizeof(initvol)/sizeof(initvol[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(initvol); i++) {
 		val = initvol[i].vol;
 		mixdev_ioctl(s->codec, initvol[i].mixch, (unsigned long)&val);
 	}
diff -puN sound/oss/soundcard.c~oss-use-array_size-macro-when-appropriate sound/oss/soundcard.c
--- a/sound/oss/soundcard.c~oss-use-array_size-macro-when-appropriate
+++ a/sound/oss/soundcard.c
@@ -32,6 +32,7 @@
 #include <linux/ctype.h>
 #include <linux/stddef.h>
 #include <linux/kmod.h>
+#include <linux/kernel.h>
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <linux/wait.h>
@@ -557,7 +558,7 @@ static int __init oss_init(void)
 	/* Protecting the innocent */
 	sound_dmap_flag = (dmabuf > 0 ? 1 : 0);
 
-	for (i = 0; i < sizeof (dev_list) / sizeof *dev_list; i++) {
+	for (i = 0; i < ARRAY_SIZE(dev_list); i++) {
 		device_create(sound_class, NULL,
 			      MKDEV(SOUND_MAJOR, dev_list[i].minor),
 			      "%s", dev_list[i].name);
@@ -581,7 +582,7 @@ static void __exit oss_cleanup(void)
 {
 	int i, j;
 
-	for (i = 0; i < sizeof (dev_list) / sizeof *dev_list; i++) {
+	for (i = 0; i < ARRAY_SIZE(dev_list); i++) {
 		device_destroy(sound_class, MKDEV(SOUND_MAJOR, dev_list[i].minor));
 		if (!dev_list[i].num)
 			continue;
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-avr32.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-mips.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
