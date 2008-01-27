From: akpm@linux-foundation.org
Subject: + sound-fix-opti9xx-miro-section-mismatch.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:18:29 -0800
Message-ID: <200801270518.m0R5IQhR031202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbYA0FSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     sound: fix opti9xx/miro section mismatch
has been added to the -mm tree.  Its filename is
     sound-fix-opti9xx-miro-section-mismatch.patch

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
Subject: sound: fix opti9xx/miro section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

snd_opti93x_mixer() is only called by __devinit snd_opti93x_probe(),
so the former can also be __devinit.

snd_miro_mixer() is only called by __devinit snd_miro_probe(),
so the former can also be __devinit.

sound/isa/opti9xx/opti92x-ad1848.c:
WARNING: vmlinux.o(.text+0xf91cd7): Section mismatch: reference to .init.data:snd_opti93x_controls (between 'snd_opti93x_mixer' and 'snd_card_opti9xx_free')
WARNING: vmlinux.o(.text+0xf91d66): Section mismatch: reference to .init.data:snd_miro_controls (between 'snd_opti93x_mixer' and 'snd_card_opti9xx_free')

opti9xx/miro.c:
WARNING: vmlinux.o(.text+0xf926c2): Section mismatch: reference to .init.data:snd_miro_controls (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf926e5): Section mismatch: reference to .init.data:snd_miro_eq_controls (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf926f9): Section mismatch: reference to .init.data:snd_miro_line_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf92716): Section mismatch: reference to .init.data:snd_miro_amp_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf9273e): Section mismatch: reference to .init.data:snd_miro_preamp_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf92764): Section mismatch: reference to .init.data:snd_miro_capture_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf92783): Section mismatch: reference to .init.data:snd_miro_radio_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf9279a): Section mismatch: reference to .init.data:snd_miro_eq_controls (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf927b9): Section mismatch: reference to .init.data:snd_miro_radio_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/isa/opti9xx/miro.c           |    2 +-
 sound/isa/opti9xx/opti92x-ad1848.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN sound/isa/opti9xx/miro.c~sound-fix-opti9xx-miro-section-mismatch sound/isa/opti9xx/miro.c
--- a/sound/isa/opti9xx/miro.c~sound-fix-opti9xx-miro-section-mismatch
+++ a/sound/isa/opti9xx/miro.c
@@ -669,7 +669,7 @@ static int __devinit snd_set_aci_init_va
 	return 0;
 }
 
-static int snd_miro_mixer(struct snd_miro *miro)
+static int __devinit snd_miro_mixer(struct snd_miro *miro)
 {
 	struct snd_card *card;
 	unsigned int idx;
diff -puN sound/isa/opti9xx/opti92x-ad1848.c~sound-fix-opti9xx-miro-section-mismatch sound/isa/opti9xx/opti92x-ad1848.c
--- a/sound/isa/opti9xx/opti92x-ad1848.c~sound-fix-opti9xx-miro-section-mismatch
+++ a/sound/isa/opti9xx/opti92x-ad1848.c
@@ -1594,7 +1594,7 @@ OPTi93X_DOUBLE("Capture Volume", 0, OPTi
 }
 };
                                         
-static int snd_opti93x_mixer(struct snd_opti93x *chip)
+static int __devinit snd_opti93x_mixer(struct snd_opti93x *chip)
 {
 	struct snd_card *card;
 	struct snd_kcontrol_new knew;
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
