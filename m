From: akpm@linux-foundation.org
Subject: + osst-update-ppos-instead-of-using-file-f_pos.patch added to -mm tree
Date: Fri, 09 Apr 2010 16:15:15 -0700
Message-ID: <201004092315.o39NFFas017169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753236Ab0DIXP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 19:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, James.Bottomley@HansenPartnership.com, fweisbec@gmail.com, osst@riede.org


The patch titled
     osst: update ppos instead of using file->f_pos
has been added to the -mm tree.  Its filename is
     osst-update-ppos-instead-of-using-file-f_pos.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: osst: update ppos instead of using file->f_pos
From: Jan Blunck <jblunck@suse.de>

osst_read()/osst_write() modify file->f_pos directly instead of the ppos
given to them.  The VFS later updates the file->f_pos and overwrites it
with the value of ppos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Willem Riede <osst@riede.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/osst.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/osst.c~osst-update-ppos-instead-of-using-file-f_pos drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~osst-update-ppos-instead-of-using-file-f_pos
+++ a/drivers/scsi/osst.c
@@ -3587,7 +3587,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not su
 		if (i == (-ENOSPC)) {
 			transfer = STp->buffer->writing;	/* FIXME -- check this logic */
 			if (transfer <= do_count) {
-				filp->f_pos += do_count - transfer;
+				*ppos += do_count - transfer;
 				count -= do_count - transfer;
 				if (STps->drv_block >= 0) {
 					STps->drv_block += (do_count - transfer) / STp->block_size;
@@ -3625,7 +3625,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not su
 			goto out;
 		}
 
-		filp->f_pos += do_count;
+		*ppos += do_count;
 		b_point += do_count;
 		count -= do_count;
 		if (STps->drv_block >= 0) {
@@ -3647,7 +3647,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not su
 		if (STps->drv_block >= 0) {
 			STps->drv_block += blks;
 		}
-		filp->f_pos += count;
+		*ppos += count;
 		count = 0;
 	}
 
@@ -3823,7 +3823,7 @@ static ssize_t osst_read(struct file * f
 			}
 			STp->logical_blk_num += transfer / STp->block_size;
 			STps->drv_block      += transfer / STp->block_size;
-			filp->f_pos          += transfer;
+			*ppos          += transfer;
 			buf                  += transfer;
 			total                += transfer;
 		}
_

Patches currently in -mm which might be from jblunck@suse.de are

osst-update-ppos-instead-of-using-file-f_pos.patch
drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos.patch
arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
misdn-remove-unnecessary-test-on-f_pos.patch
zcrypt-use-nonseekable_open.patch
rtc-m41t80-use-nonseekable_open.patch
vfs-introduce-noop_llseek.patch
osst-use-noop_llseek-instead-of-default_llseek.patch
st-use-noop_llseek-instead-of-default_llseek.patch
fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch
documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch

