From: akpm@linux-foundation.org
Subject: - rfcomm-tty-destroy-before-tty_close.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:39:52 -0800
Message-ID: <200802052239.m15MdXiD013064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54716 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762294AbYBEWlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     rfcomm tty: destroy before tty_close()
has been removed from the -mm tree.  Its filename was
     rfcomm-tty-destroy-before-tty_close.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rfcomm tty: destroy before tty_close()
From: Dave Young <hidave.darkstar@gmail.com>

rfcomm dev could be deleted in tty_hangup, so we must not call
rfcomm_dev_del again to prevent from destroying rfcomm dev before tty
close.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/rfcomm/tty.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/bluetooth/rfcomm/tty.c~rfcomm-tty-destroy-before-tty_close net/bluetooth/rfcomm/tty.c
--- a/net/bluetooth/rfcomm/tty.c~rfcomm-tty-destroy-before-tty_close
+++ a/net/bluetooth/rfcomm/tty.c
@@ -429,7 +429,8 @@ static int rfcomm_release_dev(void __use
 	if (dev->tty)
 		tty_vhangup(dev->tty);
 
-	rfcomm_dev_del(dev);
+	if (!test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags))
+		rfcomm_dev_del(dev);
 	rfcomm_dev_put(dev);
 	return 0;
 }
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
git-cpufreq.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-isofs-from-using-read_inode-fix-2.patch
iget-stop-isofs-from-using-read_inode-fix-2-update.patch
