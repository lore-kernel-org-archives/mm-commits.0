From: akpm@linux-foundation.org
Subject: - i2c-cs8427c-use-put_unaligned-helper.patch removed from -mm tree
Date: Mon, 12 May 2008 14:53:24 -0700
Message-ID: <200805122153.m4CLrOPT011067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365AbYELVyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 17:54:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     i2c: cs8427.c use put_unaligned helper
has been removed from the -mm tree.  Its filename was
     i2c-cs8427c-use-put_unaligned-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: cs8427.c use put_unaligned helper
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/i2c/cs8427.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN sound/i2c/cs8427.c~i2c-cs8427c-use-put_unaligned-helper sound/i2c/cs8427.c
--- a/sound/i2c/cs8427.c~i2c-cs8427c-use-put_unaligned-helper
+++ a/sound/i2c/cs8427.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <asm/unaligned.h>
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/pcm.h>
@@ -264,10 +265,7 @@ int snd_cs8427_create(struct snd_i2c_bus
 		goto __fail;
 	}
 	/* write default channel status bytes */
-	buf[0] = ((unsigned char)(SNDRV_PCM_DEFAULT_CON_SPDIF >> 0));
-	buf[1] = ((unsigned char)(SNDRV_PCM_DEFAULT_CON_SPDIF >> 8));
-	buf[2] = ((unsigned char)(SNDRV_PCM_DEFAULT_CON_SPDIF >> 16));
-	buf[3] = ((unsigned char)(SNDRV_PCM_DEFAULT_CON_SPDIF >> 24));
+	put_unaligned_le32(SNDRV_PCM_DEFAULT_CON_SPDIF, buf);
 	memset(buf + 4, 0, 24 - 4);
 	if (snd_cs8427_send_corudata(device, 0, buf, 24) < 0)
 		goto __fail;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

mmc-make-one-bit-signed-bitfields-unsigned.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
i2c-cs8427c-use-put_unaligned-helper.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
lib-add-ascii-hex-helper-functions.patch
lib-add-ascii-hex-helper-functions-update.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

