From: akpm@linux-foundation.org
Subject: [merged] cris-fix-a-build-error-in-sync_serial_open.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:50 -0700
Message-ID: <201108161847.p7GIlv01015195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1HPSso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, geert@linux-m68k.org, jesper.nilsson@axis.com, stable@kernel.org, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: fix a build error in sync_serial_open()
has been removed from the -mm tree.  Its filename was
     cris-fix-a-build-error-in-sync_serial_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@kernel.org>
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

origin.patch
kexec-remove-kmsg_dump_kexec.patch

