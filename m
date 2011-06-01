From: akpm@linux-foundation.org
Subject: + cris-fix-a-build-error-in-sync_serial_open.patch added to -mm tree
Date: Wed, 01 Jun 2011 15:09:42 -0700
Message-ID: <201106012209.p51M9gnS012554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633Ab1FAWKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 18:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, geert@linux-m68k.org, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: fix a build error in sync_serial_open()
has been added to the -mm tree.  Its filename is
     cris-fix-a-build-error-in-sync_serial_open.patch

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
Subject: cris: fix a build error in sync_serial_open()
From: WANG Cong <xiyou.wangcong@gmail.com>

arch/cris/arch-v10/drivers/sync_serial.c:628: error: 'ret' undeclared (first use in this function)

'ret' should be 'err'.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/sync_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/cris/arch-v10/drivers/sync_serial.c~cris-fix-a-build-error-in-sync_serial_open arch/cris/arch-v10/drivers/sync_serial.c
--- a/arch/cris/arch-v10/drivers/sync_serial.c~cris-fix-a-build-error-in-sync_serial_open
+++ a/arch/cris/arch-v10/drivers/sync_serial.c
@@ -625,11 +625,11 @@ static int sync_serial_open(struct inode
 			*R_IRQ_MASK1_SET = 1 << port->data_avail_bit;
 		DEBUG(printk(KERN_DEBUG "sser%d rec started\n", dev));
 	}
-	ret = 0;
+	err = 0;
 	
 out:
 	mutex_unlock(&sync_serial_mutex);
-	return ret;
+	return err;
 }
 
 static int sync_serial_release(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
cris-fix-a-build-error-in-sync_serial_open.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

