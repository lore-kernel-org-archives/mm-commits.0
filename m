From: akpm@linux-foundation.org
Subject: + dont-touch-fs_struct-in-drivers.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:01:14 -0800
Message-ID: <200711052101.lA5L1Ecp019451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551AbXKEVBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:01:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, bjorn.helgaas@hp.com, hch@lst.de, perex@suse.cz, tiwai@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Dont touch fs_struct in drivers
has been added to the -mm tree.  Its filename is
     dont-touch-fs_struct-in-drivers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Takashi Iwai <tiwai@suse.de>
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
@@ -152,13 +152,13 @@ struct snd_seq_client *snd_seq_client_us
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
@@ -150,9 +150,6 @@ void snd_seq_device_load_drivers(void)
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
@@ -72,8 +72,6 @@ static DEFINE_MUTEX(sound_mutex);
  */
 void snd_request_card(int card)
 {
-	if (! current->fs->root)
-		return;
 	if (snd_card_locked(card))
 		return;
 	if (card < 0 || card >= cards_limit)
@@ -87,8 +85,6 @@ static void snd_request_other(int minor)
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
@@ -148,8 +148,6 @@ static struct snd_timer *snd_timer_find(
 
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
@@ -246,9 +246,8 @@ int __init snd_pmac_daca_init(struct snd
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
@@ -1327,9 +1327,8 @@ int __init snd_pmac_tumbler_init(struct 
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

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
