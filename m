From: akpm@linux-foundation.org
Subject: + sound-pci-remove-unused-variable.patch added to -mm tree
Date: Mon, 17 Mar 2008 16:29:05 -0700
Message-ID: <200803172329.m2HNT5lE003778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755532AbYCQX3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 19:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, perex@suse.cz, tiwai@suse.de


The patch titled
     sound/pci: remove unused variable
has been added to the -mm tree.  Its filename is
     sound-pci-remove-unused-variable.patch

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
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-dvb.patch
git-hid.patch
git-udf.patch
git-net.patch
git-ocfs2.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
net-9p-trans_fdc-remove-unused-variable.patch
net-ipv6-ndiscc-remove-unused-variable.patch
sound-pci-remove-unused-variable.patch
drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch

