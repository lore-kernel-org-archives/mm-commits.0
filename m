From: akpm@linux-foundation.org
Subject: - replace-regular-code-with-appropriate-calls-to-container_of.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:54 -0800
Message-ID: <200702112254.l1BMssbe016278@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60598 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932871AbXBKWz0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, davem@davemloft.net, jmorris@namei.org, paulus@samba.org, schwidefsky@de.ibm.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     Replace regular code with appropriate calls to container_of()
has been removed from the -mm tree.  Its filename was
     replace-regular-code-with-appropriate-calls-to-container_of.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Replace regular code with appropriate calls to container_of()
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace a small number of expressions with a call to the "container_of()"
macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ppp_generic.c |    2 +-
 drivers/s390/net/lcs.c    |    6 ++----
 drivers/video/sa1100fb.h  |    4 +---
 include/linux/security.h  |    2 +-
 security/selinux/hooks.c  |    2 +-
 5 files changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/net/ppp_generic.c~replace-regular-code-with-appropriate-calls-to-container_of drivers/net/ppp_generic.c
--- a/drivers/net/ppp_generic.c~replace-regular-code-with-appropriate-calls-to-container_of
+++ a/drivers/net/ppp_generic.c
@@ -83,7 +83,7 @@ struct ppp_file {
 	int		dead;		/* unit/channel has been shut down */
 };
 
-#define PF_TO_X(pf, X)		((X *)((char *)(pf) - offsetof(X, file)))
+#define PF_TO_X(pf, X)		container_of(pf, X, file)
 
 #define PF_TO_PPP(pf)		PF_TO_X(pf, struct ppp)
 #define PF_TO_CHANNEL(pf)	PF_TO_X(pf, struct channel)
diff -puN drivers/s390/net/lcs.c~replace-regular-code-with-appropriate-calls-to-container_of drivers/s390/net/lcs.c
--- a/drivers/s390/net/lcs.c~replace-regular-code-with-appropriate-calls-to-container_of
+++ a/drivers/s390/net/lcs.c
@@ -1511,8 +1511,7 @@ lcs_txbuffer_cb(struct lcs_channel *chan
 	LCS_DBF_TEXT(5, trace, "txbuffcb");
 	/* Put buffer back to pool. */
 	lcs_release_buffer(channel, buffer);
-	card = (struct lcs_card *)
-		((char *) channel - offsetof(struct lcs_card, write));
+	card = container_of(channel, struct lcs_card, write);
 	if (netif_queue_stopped(card->dev) && netif_carrier_ok(card->dev))
 		netif_wake_queue(card->dev);
 	spin_lock(&card->lock);
@@ -1810,8 +1809,7 @@ lcs_get_frames_cb(struct lcs_channel *ch
 		LCS_DBF_TEXT(4, trace, "-eiogpkt");
 		return;
 	}
-	card = (struct lcs_card *)
-		((char *) channel - offsetof(struct lcs_card, read));
+	card = container_of(channel, struct lcs_card, read);
 	offset = 0;
 	while (lcs_hdr->offset != 0) {
 		if (lcs_hdr->offset <= 0 ||
diff -puN drivers/video/sa1100fb.h~replace-regular-code-with-appropriate-calls-to-container_of drivers/video/sa1100fb.h
--- a/drivers/video/sa1100fb.h~replace-regular-code-with-appropriate-calls-to-container_of
+++ a/drivers/video/sa1100fb.h
@@ -110,9 +110,7 @@ struct sa1100fb_info {
 #endif
 };
 
-#define __type_entry(ptr,type,member) ((type *)((char *)(ptr)-offsetof(type,member)))
-
-#define TO_INF(ptr,member)	__type_entry(ptr,struct sa1100fb_info,member)
+#define TO_INF(ptr,member)	container_of(ptr,struct sa1100fb_info,member)
 
 #define SA1100_PALETTE_MODE_VAL(bpp)    (((bpp) & 0x018) << 9)
 
diff -puN include/linux/security.h~replace-regular-code-with-appropriate-calls-to-container_of include/linux/security.h
--- a/include/linux/security.h~replace-regular-code-with-appropriate-calls-to-container_of
+++ a/include/linux/security.h
@@ -492,7 +492,7 @@ struct request_sock;
  *	Note that the fown_struct, @fown, is never outside the context of a
  *	struct file, so the file structure (and associated security information)
  *	can always be obtained:
- *		(struct file *)((long)fown - offsetof(struct file,f_owner));
+ *		container_of(fown, struct file, f_owner)
  * 	@tsk contains the structure of task receiving signal.
  *	@fown contains the file owner information.
  *	@sig is the signal that will be sent.  When 0, kernel sends SIGIO.
diff -puN security/selinux/hooks.c~replace-regular-code-with-appropriate-calls-to-container_of security/selinux/hooks.c
--- a/security/selinux/hooks.c~replace-regular-code-with-appropriate-calls-to-container_of
+++ a/security/selinux/hooks.c
@@ -2654,7 +2654,7 @@ static int selinux_file_send_sigiotask(s
 	struct file_security_struct *fsec;
 
 	/* struct fown_struct is never outside the context of a struct file */
-        file = (struct file *)((long)fown - offsetof(struct file,f_owner));
+        file = container_of(fown, struct file, f_owner);
 
 	tsec = tsk->security;
 	fsec = file->f_security;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
