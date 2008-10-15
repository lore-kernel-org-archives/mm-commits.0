From: akpm@linux-foundation.org
Subject: - w1-be-able-to-manually-add-and-remove-slaves-fix.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:58:06 -0700
Message-ID: <200810152358.m9FNw6pp024589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbYJPAKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 20:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1-be-able-to-manually-add-and-remove-slaves-fix
has been removed from the -mm tree.  Its filename was
     w1-be-able-to-manually-add-and-remove-slaves-fix.patch

This patch was dropped because it was folded into w1-be-able-to-manually-add-and-remove-slaves.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1-be-able-to-manually-add-and-remove-slaves-fix
From: Andrew Morton <akpm@linux-foundation.org>

s390:

drivers/w1/w1.c: In function 'w1_atoreg_num':
drivers/w1/w1.c:401: warning: format '%012llx' expects type 'long long unsigned int *', but argument 4 has type 'u64 *'
drivers/w1/w1.c:401: warning: format '%012llx' expects type 'long long unsigned int *', but argument 4 has type 'u64 *'

We cannot pass uncast u64 into scanf() or printf() functions - we don't know
what type it is!

Cc: David Fries <david@fries.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/w1/w1.c~w1-be-able-to-manually-add-and-remove-slaves-fix drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-be-able-to-manually-add-and-remove-slaves-fix
+++ a/drivers/w1/w1.c
@@ -398,9 +398,10 @@ static int w1_atoreg_num(struct device *
 	struct w1_reg_num *rn)
 {
 	unsigned int family;
-	u64 id;
+	unsigned long long id;
 	int i;
 	u64 rn64_le;
+
 	/* The CRC value isn't read from the user because the sysfs directory
 	 * doesn't include it and most messages from the bus search don't
 	 * print it either.  It would be unreasonable for the user to then
@@ -424,10 +425,10 @@ static int w1_atoreg_num(struct device *
 	rn64_le = cpu_to_le64(*(u64 *)rn);
 	rn->crc = w1_calc_crc8((u8 *)&rn64_le, 7);
 
-	#if 0
+#if 0
 	dev_info(dev, "With CRC device is %02x.%012llx.%02x.\n",
 		  rn->family, (unsigned long long)rn->id, rn->crc);
-	#endif
+#endif
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-viafbdevc-viafbdevh.patch
fbdev-kconfig-update.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

