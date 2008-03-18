From: akpm@linux-foundation.org
Subject: - sound-pci-remove-unused-variable.patch removed from -mm tree
Date: Tue, 18 Mar 2008 09:33:22 -0700
Message-ID: <200803181633.m2IGXMNY006432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063AbYCST12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound/pci: remove unused variable
has been removed from the -mm tree.  Its filename was
     sound-pci-remove-unused-variable.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound/pci: remove unused variable
From: Julia Lawall <julia@diku.dk>

The variables change and is_capture are initialized but never used otherwise.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier i;
constant C;
@@

(
extern T i;
|
- T i;
  <+... when != i
- i = C;
  ...+>
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/ice1712/pontis.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN sound/pci/ice1712/pontis.c~sound-pci-remove-unused-variable sound/pci/ice1712/pontis.c
--- a/sound/pci/ice1712/pontis.c~sound-pci-remove-unused-variable
+++ a/sound/pci/ice1712/pontis.c
@@ -440,14 +440,12 @@ static int cs_source_put(struct snd_kcon
 {
 	struct snd_ice1712 *ice = snd_kcontrol_chip(kcontrol);
 	unsigned char val;
-	int change = 0;
 
 	mutex_lock(&ice->gpio_mutex);
 	if (ucontrol->value.enumerated.item[0] != ice->gpio.saved[0]) {
 		ice->gpio.saved[0] = ucontrol->value.enumerated.item[0] & 3;
 		val = 0x80 | (ice->gpio.saved[0] << 3);
 		spi_write(ice, CS_DEV, 0x04, val);
-		change = 1;
 	}
 	mutex_unlock(&ice->gpio_mutex);
 	return change;
_

Patches currently in -mm which might be from julia@diku.dk are

git-acpi.patch
git-alsa-tiwai.patch
sound-pci-remove-unused-variable.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-dvb.patch
git-hid.patch
git-udf.patch
git-net.patch
net-ipv6-ndiscc-remove-unused-variable.patch
drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch
git-ocfs2.patch
net-9p-trans_fdc-remove-unused-variable.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

