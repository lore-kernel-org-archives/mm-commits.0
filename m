From: akpm@linux-foundation.org
Subject: + char-vt-use-kzalloc.patch added to -mm tree
Date: Tue, 29 May 2007 20:09:03 -0700
Message-ID: <200705300309.l4U3923v018111@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbXE3DJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 23:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: vt, use kzalloc
has been added to the -mm tree.  Its filename is
     char-vt-use-kzalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: vt, use kzalloc
From: Jiri Slaby <jirislaby@gmail.com>

vt, use kzalloc

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/vt.c~char-vt-use-kzalloc drivers/char/vt.c
--- a/drivers/char/vt.c~char-vt-use-kzalloc
+++ a/drivers/char/vt.c
@@ -729,10 +729,9 @@ int vc_allocate(unsigned int currcons)	/
 	    /* although the numbers above are not valid since long ago, the
 	       point is still up-to-date and the comment still has its value
 	       even if only as a historical artifact.  --mj, July 1998 */
-	    vc = kmalloc(sizeof(struct vc_data), GFP_KERNEL);
+	    vc = kzalloc(sizeof(struct vc_data), GFP_KERNEL);
 	    if (!vc)
 		return -ENOMEM;
-	    memset(vc, 0, sizeof(*vc));
 	    vc_cons[currcons].d = vc;
 	    INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 	    visual_init(vc, currcons, 1);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-mxser_new-fix-sparse-warning.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
char-genrtc-use-wait_event_interruptible.patch
char-n_r3964-use-wait_event_interruptible.patch
char-ip2-use-msleep-for-sleeping.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
shrink_slab-handle-bad-shrinkers.patch
