From: akpm@linux-foundation.org
Subject: - sound-fix-cs5535-section-mismatch.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:48:08 -0800
Message-ID: <200801290148.m0T1m8CN027328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755920AbYA2B7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:59:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, perex@suse.cz, sam@ravnborg.org, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound: fix cs5535 section mismatch
has been removed from the -mm tree.  Its filename was
     sound-fix-cs5535-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound: fix cs5535 section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

snd_cs5535audio_mixer() is only called by __devinit
snd_cs5535audio_probe(), so the mixer function can also be __devinit.

WARNING: vmlinux.o(.text+0xfdbba0): Section mismatch: reference to .init.data:ac97_quirks (between 'snd_cs5535audio_mixer' and 'process_bm0_irq')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/cs5535audio/cs5535audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/pci/cs5535audio/cs5535audio.c~sound-fix-cs5535-section-mismatch sound/pci/cs5535audio/cs5535audio.c
--- a/sound/pci/cs5535audio/cs5535audio.c~sound-fix-cs5535-section-mismatch
+++ a/sound/pci/cs5535audio/cs5535audio.c
@@ -144,7 +144,7 @@ static unsigned short snd_cs5535audio_ac
 	return snd_cs5535audio_codec_read(cs5535au, reg);
 }
 
-static int snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
+static int __devinit snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
 {
 	struct snd_card *card = cs5535au->card;
 	struct snd_ac97_bus *pbus;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
profile-likely-unlikely-macros.patch
