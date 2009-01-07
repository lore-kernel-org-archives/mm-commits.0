From: akpm@linux-foundation.org
Subject: - check-fops_get-return-value.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:09 -0800
Message-ID: <200901072215.n07MF9jG014985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761860AbZAGWPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laurent.pinchart@skynet.be, airlied@linux.ie, alan-jenkins@tuffmail.co.uk, mchehab@infradead.org, tiwai@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Check fops_get() return value
has been removed from the -mm tree.  Its filename was
     check-fops_get-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Check fops_get() return value
From: Laurent Pinchart <laurent.pinchart@skynet.be>

Several subsystem open handlers dereference the fops_get() return value
without checking it for nullness.  This opens a race condition between the
open handler and module unloading.

A module can be marked as being unloaded (MODULE_STATE_GOING) before its
exit function is called and gets the chance to unregister the driver. 
During that window open handlers can still be called, and fops_get() will
fail in try_module_get() and return a NULL pointer.

This change checks the fops_get() return value and returns -ENODEV if NULL.

Reported-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Airlie <airlied@linux.ie>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_fops.c          |    4 ++++
 drivers/media/dvb/dvb-core/dvbdev.c |    5 +++++
 sound/core/sound.c                  |    4 ++++
 3 files changed, 13 insertions(+)

diff -puN drivers/gpu/drm/drm_fops.c~check-fops_get-return-value drivers/gpu/drm/drm_fops.c
--- a/drivers/gpu/drm/drm_fops.c~check-fops_get-return-value
+++ a/drivers/gpu/drm/drm_fops.c
@@ -183,6 +183,10 @@ int drm_stub_open(struct inode *inode, s
 
 	old_fops = filp->f_op;
 	filp->f_op = fops_get(&dev->driver->fops);
+	if (filp->f_op == NULL) {
+		filp->f_op = old_fops;
+		goto out;
+	}
 	if (filp->f_op->open && (err = filp->f_op->open(inode, filp))) {
 		fops_put(filp->f_op);
 		filp->f_op = fops_get(old_fops);
diff -puN drivers/media/dvb/dvb-core/dvbdev.c~check-fops_get-return-value drivers/media/dvb/dvb-core/dvbdev.c
--- a/drivers/media/dvb/dvb-core/dvbdev.c~check-fops_get-return-value
+++ a/drivers/media/dvb/dvb-core/dvbdev.c
@@ -79,6 +79,10 @@ static int dvb_device_open(struct inode 
 		file->private_data = dvbdev;
 		old_fops = file->f_op;
 		file->f_op = fops_get(dvbdev->fops);
+		if (file->f_op == NULL) {
+			file->f_op = old_fops;
+			goto fail;
+		}
 		if(file->f_op->open)
 			err = file->f_op->open(inode,file);
 		if (err) {
@@ -90,6 +94,7 @@ static int dvb_device_open(struct inode 
 		unlock_kernel();
 		return err;
 	}
+fail:
 	up_read(&minor_rwsem);
 	unlock_kernel();
 	return -ENODEV;
diff -puN sound/core/sound.c~check-fops_get-return-value sound/core/sound.c
--- a/sound/core/sound.c~check-fops_get-return-value
+++ a/sound/core/sound.c
@@ -152,6 +152,10 @@ static int __snd_open(struct inode *inod
 	}
 	old_fops = file->f_op;
 	file->f_op = fops_get(mptr->f_ops);
+	if (file->f_op == NULL) {
+		file->f_op = old_fops;
+		return -ENODEV;
+	}
 	if (file->f_op->open)
 		err = file->f_op->open(inode, file);
 	if (err) {
_

Patches currently in -mm which might be from laurent.pinchart@skynet.be are

origin.patch

