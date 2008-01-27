From: akpm@linux-foundation.org
Subject: + sound-fix-cs5535-section-mismatch.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:07:06 -0800
Message-ID: <200801270507.m0R573Vg030715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbYA0FHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:07:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, perex@suse.cz, sam@ravnborg.org, tiwai@suse.de


The patch titled
     sound: fix cs5535 section mismatch
has been added to the -mm tree.  Its filename is
     sound-fix-cs5535-section-mismatch.patch

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
hrtimer-fix-section-mismatch.patch
timer-fix-section-mismatch.patch
rcu-fix-section-mismatch.patch
git-alsa.patch
sound-fix-cs5535-section-mismatch.patch
git-dvb.patch
radio-fix-sf16fmi-section-mismatch.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
scsi-fix-ncr5380-section-mismatch.patch
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
sound-fix-opti9xx-miro-section-mismatch.patch
profile-likely-unlikely-macros.patch
