From: akpm@linux-foundation.org
Subject: + routines-for-effect-processor-fx8010-use-list_for_each_entry.patch added to -mm tree
Date: Fri, 14 Sep 2007 04:27:53 -0700
Message-ID: <200709141127.l8EBRruu002516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539AbXINL2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 07:28:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, perex@suse.cz, tiwai@suse.de


The patch titled
     Routines for effect processor FX8010: use list_for_each_entry
has been added to the -mm tree.  Its filename is
     routines-for-effect-processor-fx8010-use-list_for_each_entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Routines for effect processor FX8010: use list_for_each_entry
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Routines for effect processor FX8010: Use list_for_each_entry instead of
list_for_each

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/sound/emu10k1.h   |    2 --
 sound/pci/emu10k1/emufx.c |   10 +++-------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff -puN include/sound/emu10k1.h~routines-for-effect-processor-fx8010-use-list_for_each_entry include/sound/emu10k1.h
--- a/include/sound/emu10k1.h~routines-for-effect-processor-fx8010-use-list_for_each_entry
+++ a/include/sound/emu10k1.h
@@ -1408,8 +1408,6 @@ struct snd_emu10k1_fx8010 {
 	struct snd_emu10k1_fx8010_irq *irq_handlers;
 };
 
-#define emu10k1_gpr_ctl(n) list_entry(n, struct snd_emu10k1_fx8010_ctl, list)
-
 struct snd_emu10k1_midi {
 	struct snd_emu10k1 *emu;
 	struct snd_rawmidi *rmidi;
diff -puN sound/pci/emu10k1/emufx.c~routines-for-effect-processor-fx8010-use-list_for_each_entry sound/pci/emu10k1/emufx.c
--- a/sound/pci/emu10k1/emufx.c~routines-for-effect-processor-fx8010-use-list_for_each_entry
+++ a/sound/pci/emu10k1/emufx.c
@@ -642,10 +642,8 @@ snd_emu10k1_look_for_ctl(struct snd_emu1
 {
 	struct snd_emu10k1_fx8010_ctl *ctl;
 	struct snd_kcontrol *kcontrol;
-	struct list_head *list;
-	
-	list_for_each(list, &emu->fx8010.gpr_ctl) {
-		ctl = emu10k1_gpr_ctl(list);
+
+	list_for_each_entry(ctl, &emu->fx8010.gpr_ctl, list) {
 		kcontrol = ctl->kcontrol;
 		if (kcontrol->id.iface == id->iface &&
 		    !strcmp(kcontrol->id.name, id->name) &&
@@ -895,14 +893,12 @@ static int snd_emu10k1_list_controls(str
 	struct snd_emu10k1_fx8010_control_gpr *gctl;
 	struct snd_emu10k1_fx8010_ctl *ctl;
 	struct snd_ctl_elem_id *id;
-	struct list_head *list;
 
 	gctl = kmalloc(sizeof(*gctl), GFP_KERNEL);
 	if (! gctl)
 		return -ENOMEM;
 
-	list_for_each(list, &emu->fx8010.gpr_ctl) {
-		ctl = emu10k1_gpr_ctl(list);
+	list_for_each_entry(ctl, &emu->fx8010.gpr_ctl, list) {
 		total++;
 		if (icode->gpr_list_controls &&
 		    i < icode->gpr_list_control_count) {
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
ess-maestro-1-2-2e-sound-card-use-list_for_each_entry.patch
routines-for-effect-processor-fx8010-use-list_for_each_entry.patch
git-dvb.patch
git-mtd.patch
git-netdev-all.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
