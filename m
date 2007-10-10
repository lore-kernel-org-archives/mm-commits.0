From: akpm@linux-foundation.org
Subject: - sound-snd_register_device_for_dev-fix.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:31 -0700
Message-ID: <200710102110.l9ALAVlb025940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755848AbXJJVLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound: snd_register_device_for_dev fix
has been removed from the -mm tree.  Its filename was
     sound-snd_register_device_for_dev-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sound: snd_register_device_for_dev fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

snd_register_device_for_dev() can oops when device_create() returns
ERR_PTR(err).

Scenario:

preg->dev = device_create(...); /* fails */
if (preg->dev) /* contains ERR_PTR(err) */
	dev_set_drvdata(preg->dev, private_data);

and dev_set_drvdata() looks like this:

static inline void
dev_set_drvdata (struct device *dev, void *data)
{
	dev->driver_data = data; <--- boom
}

This patch should prevent that.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/sound.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN sound/core/sound.c~sound-snd_register_device_for_dev-fix sound/core/sound.c
--- a/sound/core/sound.c~sound-snd_register_device_for_dev-fix
+++ a/sound/core/sound.c
@@ -266,6 +266,14 @@ int snd_register_device_for_dev(int type
 	snd_minors[minor] = preg;
 	preg->dev = device_create(sound_class, device, MKDEV(major, minor),
 				  "%s", name);
+	if (IS_ERR(preg->dev)) {
+		snd_minors[minor] = NULL;
+		mutex_unlock(&sound_mutex);
+		minor = PTR_ERR(preg->dev);
+		kfree(preg);
+		return minor;
+	}
+
 	if (preg->dev)
 		dev_set_drvdata(preg->dev, private_data);
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa.patch
git-arm.patch
git-cifs.patch
git-powerpc.patch
git-dvb.patch
git-hid.patch
git-mmc.patch
git-mtd.patch
git-net.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
