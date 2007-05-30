From: akpm@linux-foundation.org
Subject: + char-vt-use-array_size.patch added to -mm tree
Date: Tue, 29 May 2007 20:09:07 -0700
Message-ID: <200705300309.l4U396Zo018116@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXE3DJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 23:09:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: vt, use ARRAY_SIZE
has been added to the -mm tree.  Its filename is
     char-vt-use-array_size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: vt, use ARRAY_SIZE
From: Jiri Slaby <jirislaby@gmail.com>

vt, use ARRAY_SIZE

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/vt.c~char-vt-use-array_size drivers/char/vt.c
--- a/drivers/char/vt.c~char-vt-use-array_size
+++ a/drivers/char/vt.c
@@ -1990,8 +1990,7 @@ static int is_double_width(uint32_t ucs)
 		{ 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 }, { 0xFFE0, 0xFFE6 },
 		{ 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
 	};
-	return bisearch(ucs, double_width,
-		sizeof(double_width) / sizeof(*double_width) - 1);
+	return bisearch(ucs, double_width, ARRAY_SIZE(double_width) - 1);
 }
 
 /* acquires console_sem */
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
