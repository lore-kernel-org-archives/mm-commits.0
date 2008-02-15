From: akpm@linux-foundation.org
Subject: - dont-touch-fs_struct-in-drivers.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:34 -0500
Message-ID: <200802150719.m1F7JuEU025747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755625AbYBOHUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, bjorn.helgaas@hp.com, hch@lst.de, perex@suse.cz, tiwai@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Dont touch fs_struct in drivers
has been removed from the -mm tree.  Its filename was
     dont-touch-fs_struct-in-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Dont touch fs_struct in drivers
From: Jan Blunck <jblunck@suse.de>

The sound drivers and the pnpbios core test for current->root != NULL.  This
test seems to be unnecessary since we always have rootfs mounted before
initializing the drivers.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/core.c     |    2 --
 sound/core/seq/seq_clientmgr.c |    4 ++--
 sound/core/seq/seq_device.c    |    3 ---
 sound/core/sound.c             |    4 ----
 sound/core/timer.c             |    2 --
 sound/ppc/daca.c               |    5 ++---
 sound/ppc/tumbler.c            |    5 ++---
 7 files changed, 6 insertions(+), 19 deletions(-)

diff -puN drivers/pnp/pnpbios/core.c~dont-touch-fs_struct-in-drivers drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~dont-touch-fs_struct-in-drivers
+++ a/drivers/pnp/pnpbios/core.c
@@ -105,8 +105,6 @@ static int pnp_dock_event(int dock, stru
 	char *argv[3], **envp, *buf, *scratch;
 	int i = 0, value;
 
-	if (!current->fs->root)
-		return -EAGAIN;
 	if (!(envp = kcalloc(20, sizeof(char *), GFP_KERNEL)))
 		return -ENOMEM;
 	if (!(buf = kzalloc(256, GFP_KERNEL))) {
diff -puN sound/core/seq/seq_clientmgr.c~dont-touch-fs_struct-in-drivers sound/core/seq/seq_clientmgr.c
--- a/sound/core/seq/seq_clientmgr.c~dont-touch-fs_struct-in-drivers
+++ a/sound/core/seq/seq_clientmgr.c
@@ -149,13 +149,13 @@ struct snd_seq_client *snd_seq_client_us
 	}
 	spin_unlock_irqrestore(&clients_lock, flags);
 #ifdef CONFIG_KMOD
-	if (!in_interrupt() && current->fs->root) {
+	if (!in_interrupt()) {
 		static char client_requested[SNDRV_SEQ_GLOBAL_CLIENTS];
 		static char card_requested[SNDRV_CARDS];
 		if (clientid < SNDRV_SEQ_GLOBAL_CLIENTS) {
 			int idx;
 			
-			if (! client_requested[clientid] && current->fs->root) {
+			if (!client_requested[clientid]) {
 				client_requested[clientid] = 1;
 				for (idx = 0; idx < 15; idx++) {
 					if (seq_client_load[idx] < 0)
diff -puN sound/core/seq/seq_device.c~dont-touch-fs_struct-in-drivers sound/core/seq/seq_device.c
--- a/sound/core/seq/seq_device.c~dont-touch-fs_struct-in-drivers
+++ a/sound/core/seq/seq_device.c
@@ -149,9 +149,6 @@ void snd_seq_device_load_drivers(void)
 	if (snd_seq_in_init)
 		return;
 
-	if (! current->fs->root)
-		return;
-
 	mutex_lock(&ops_mutex);
 	list_for_each_entry(ops, &opslist, list) {
 		if (! (ops->driver & DRIVER_LOADED) &&
diff -puN sound/core/sound.c~dont-touch-fs_struct-in-drivers sound/core/sound.c
--- a/sound/core/sound.c~dont-touch-fs_struct-in-drivers
+++ a/sound/core/sound.c
@@ -71,8 +71,6 @@ static DEFINE_MUTEX(sound_mutex);
  */
 void snd_request_card(int card)
 {
-	if (! current->fs->root)
-		return;
 	if (snd_card_locked(card))
 		return;
 	if (card < 0 || card >= cards_limit)
@@ -86,8 +84,6 @@ static void snd_request_other(int minor)
 {
 	char *str;
 
-	if (! current->fs->root)
-		return;
 	switch (minor) {
 	case SNDRV_MINOR_SEQUENCER:	str = "snd-seq";	break;
 	case SNDRV_MINOR_TIMER:		str = "snd-timer";	break;
diff -puN sound/core/timer.c~dont-touch-fs_struct-in-drivers sound/core/timer.c
--- a/sound/core/timer.c~dont-touch-fs_struct-in-drivers
+++ a/sound/core/timer.c
@@ -150,8 +150,6 @@ static struct snd_timer *snd_timer_find(
 
 static void snd_timer_request(struct snd_timer_id *tid)
 {
-	if (! current->fs->root)
-		return;
 	switch (tid->dev_class) {
 	case SNDRV_TIMER_CLASS_GLOBAL:
 		if (tid->device < timer_limit)
diff -puN sound/ppc/daca.c~dont-touch-fs_struct-in-drivers sound/ppc/daca.c
--- a/sound/ppc/daca.c~dont-touch-fs_struct-in-drivers
+++ a/sound/ppc/daca.c
@@ -250,9 +250,8 @@ int __init snd_pmac_daca_init(struct snd
 	struct pmac_daca *mix;
 
 #ifdef CONFIG_KMOD
-	if (current->fs->root)
-		request_module("i2c-powermac");
-#endif /* CONFIG_KMOD */	
+	request_module("i2c-powermac");
+#endif /* CONFIG_KMOD */
 
 	mix = kzalloc(sizeof(*mix), GFP_KERNEL);
 	if (! mix)
diff -puN sound/ppc/tumbler.c~dont-touch-fs_struct-in-drivers sound/ppc/tumbler.c
--- a/sound/ppc/tumbler.c~dont-touch-fs_struct-in-drivers
+++ a/sound/ppc/tumbler.c
@@ -1351,9 +1351,8 @@ int __init snd_pmac_tumbler_init(struct 
 	char *chipname;
 
 #ifdef CONFIG_KMOD
-	if (current->fs->root)
-		request_module("i2c-powermac");
-#endif /* CONFIG_KMOD */	
+	request_module("i2c-powermac");
+#endif /* CONFIG_KMOD */
 
 	mix = kzalloc(sizeof(*mix), GFP_KERNEL);
 	if (! mix)
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch
introduce-path_put-unionfs.patch
