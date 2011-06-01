From: akpm@linux-foundation.org
Subject: + cris-fix-the-prototype-of-sync_serial_ioctl.patch added to -mm tree
Date: Wed, 01 Jun 2011 15:11:30 -0700
Message-ID: <201106012211.p51MBUBj012629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604Ab1FAWLg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 18:11:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, geert@linux-m68k.org, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: fix the prototype of sync_serial_ioctl()
has been added to the -mm tree.  Its filename is
     cris-fix-the-prototype-of-sync_serial_ioctl.patch

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
Subject: cris: fix the prototype of sync_serial_ioctl()
From: WANG Cong <xiyou.wangcong@gmail.com>

arch/cris/arch-v10/drivers/sync_serial.c:961: error: conflicting types for 'sync_serial_ioctl'

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/sync_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/cris/arch-v10/drivers/sync_serial.c~cris-fix-the-prototype-of-sync_serial_ioctl arch/cris/arch-v10/drivers/sync_serial.c
--- a/arch/cris/arch-v10/drivers/sync_serial.c~cris-fix-the-prototype-of-sync_serial_ioctl
+++ a/arch/cris/arch-v10/drivers/sync_serial.c
@@ -158,7 +158,7 @@ static int sync_serial_open(struct inode
 static int sync_serial_release(struct inode *inode, struct file *file);
 static unsigned int sync_serial_poll(struct file *filp, poll_table *wait);
 
-static int sync_serial_ioctl(struct file *file,
+static long sync_serial_ioctl(struct file *file,
 	unsigned int cmd, unsigned long arg);
 static ssize_t sync_serial_write(struct file *file, const char *buf,
 	size_t count, loff_t *ppos);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

