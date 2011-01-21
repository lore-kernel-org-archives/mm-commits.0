From: akpm@linux-foundation.org
Subject: [alternative-merged] sigma-firmware-loader-for-analog-devices-sigmastudio-fix.patch removed from -mm tree
Date: Thu, 20 Jan 2011 16:11:10 -0800
Message-ID: <201101210011.p0L0BA6e010816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab1AUALl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 19:11:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     sigma-firmware-loader-for-analog-devices-sigmastudio-fix
has been removed from the -mm tree.  Its filename was
     sigma-firmware-loader-for-analog-devices-sigmastudio-fix.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: sigma-firmware-loader-for-analog-devices-sigmastudio-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/sigma.c |   53 +++++++++++++++++++------------------
 include/linux/sigma.h    |   10 +++---
 2 files changed, 33 insertions(+), 30 deletions(-)

diff -puN drivers/firmware/sigma.c~sigma-firmware-loader-for-analog-dev=
ices-sigmastudio-fix drivers/firmware/sigma.c
--- a/drivers/firmware/sigma.c~sigma-firmware-loader-for-analog-devices=
-sigmastudio-fix
+++ a/drivers/firmware/sigma.c
@@ -1,9 +1,9 @@
 /*
  * Load Analog Devices SigmaStudio firmware files
  *
-=C2=A0* Copyright 2009 Analog Devices Inc.
-=C2=A0*
-=C2=A0* Licensed under the GPL-2 or later.
+=A0* Copyright 2009 Analog Devices Inc.
+=A0*
+=A0* Licensed under the GPL-2 or later.
  */
=20
 #include <linux/crc32.h>
@@ -14,7 +14,8 @@
 #include <linux/sigma.h>
=20
 /* Return: 0=3D=3DOK, <0=3D=3Derror, =3D1 =3D=3Dno more actions */
-int process_sigma_action(struct i2c_client *client, struct sigma_firmw=
are *ssfw)
+static int process_sigma_action(struct i2c_client *client,
+				struct sigma_firmware *ssfw)
 {
 	struct sigma_action *sa =3D (void *)(ssfw->fw->data + ssfw->pos);
 	size_t len =3D sigma_action_len(sa);
@@ -24,27 +25,27 @@ int process_sigma_action(struct i2c_clie
 		sa->instr, sa->addr, len);
=20
 	switch (sa->instr) {
-		case SIGMA_ACTION_WRITEXBYTES:
-		case SIGMA_ACTION_WRITESINGLE:
-		case SIGMA_ACTION_WRITESAFELOAD:
-			if (ssfw->fw->size < ssfw->pos + len)
-				return -EINVAL;
-			ret =3D i2c_master_send(client, (void *)&sa->addr, len);
-			if (ret < 0)
-				return -EINVAL;
-			break;
-
-		case SIGMA_ACTION_DELAY:
-			ret =3D 0;
-			udelay(len);
-			len =3D 0;
-			break;
+	case SIGMA_ACTION_WRITEXBYTES:
+	case SIGMA_ACTION_WRITESINGLE:
+	case SIGMA_ACTION_WRITESAFELOAD:
+		if (ssfw->fw->size < ssfw->pos + len)
+			return -EINVAL;
+		ret =3D i2c_master_send(client, (void *)&sa->addr, len);
+		if (ret < 0)
+			return -EINVAL;
+		break;
=20
-		case SIGMA_ACTION_END:
-			return 1;
+	case SIGMA_ACTION_DELAY:
+		ret =3D 0;
+		udelay(len);
+		len =3D 0;
+		break;
=20
-		default:
-			return -EINVAL;
+	case SIGMA_ACTION_END:
+		return 1;
+
+	default:
+		return -EINVAL;
 	}
=20
 	/* when arrive here ret=3D0 or sent data */
@@ -52,7 +53,8 @@ int process_sigma_action(struct i2c_clie
 	return ssfw->pos =3D=3D ssfw->fw->size;
 }
=20
-int process_sigma_actions(struct i2c_client *client, struct sigma_firm=
ware *ssfw)
+static int process_sigma_actions(struct i2c_client *client,
+				 struct sigma_firmware *ssfw)
 {
 	pr_debug("%s: processing %p\n", __func__, ssfw);
=20
@@ -78,7 +80,8 @@ int process_sigma_firmware(struct i2c_cl
 	/* first load the blob */
 	ret =3D request_firmware(&fw, name, &client->dev);
 	if (ret) {
-		pr_debug("%s: request_firmware() failed with %i\n", __func__, ret);
+		pr_debug("%s: request_firmware() failed with %i\n",
+			 __func__, ret);
 		return ret;
 	}
 	ssfw.fw =3D fw;
diff -puN include/linux/sigma.h~sigma-firmware-loader-for-analog-device=
s-sigmastudio-fix include/linux/sigma.h
--- a/include/linux/sigma.h~sigma-firmware-loader-for-analog-devices-si=
gmastudio-fix
+++ a/include/linux/sigma.h
@@ -1,9 +1,9 @@
 /*
  * Load firmware files from Analog Devices SigmaStudio
  *
-=C2=A0* Copyright 2009 Analog Devices Inc.
-=C2=A0*
-=C2=A0* Licensed under the GPL-2 or later.
+=A0* Copyright 2009 Analog Devices Inc.
+=A0*
+=A0* Licensed under the GPL-2 or later.
  */
=20
 #ifndef __SIGMA_FIRMWARE_H__
@@ -12,6 +12,8 @@
 #include <linux/firmware.h>
 #include <linux/types.h>
=20
+struct i2c_client;
+
 #define SIGMA_MAGIC "ADISIGM"
=20
 struct sigma_firmware {
@@ -53,8 +55,6 @@ static inline size_t sigma_action_size(s
 	return sizeof(*sa) + payload_len + (payload_len % 2);
 }
=20
-struct i2c_client;
-
 extern int process_sigma_firmware(struct i2c_client *client, const cha=
r *name);
=20
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

mm-compaction-prevent-division-by-zero-during-user-requested-compaction=
=2Epatch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio.pat=
ch
memcg-fix-used-bit-handling-at-uncharge-in-thp.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fi=
xes.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
