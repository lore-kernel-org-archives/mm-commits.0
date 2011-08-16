From: akpm@linux-foundation.org
Subject: [merged] cris-fix-the-prototype-of-sync_serial_ioctl.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:52 -0700
Message-ID: <201108161847.p7GIlxM3015203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281Ab1HPSyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, geert@linux-m68k.org, jesper.nilsson@axis.com, stable@kernel.org, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: fix the prototype of sync_serial_ioctl()
has been removed from the -mm tree.  Its filename was
     cris-fix-the-prototype-of-sync_serial_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: fix the prototype of sync_serial_ioctl()
From: WANG Cong <xiyou.wangcong@gmail.com>

arch/cris/arch-v10/drivers/sync_serial.c:961: error: conflicting types for 'sync_serial_ioctl'

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: <stable@kernel.org>
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

origin.patch
kexec-remove-kmsg_dump_kexec.patch

