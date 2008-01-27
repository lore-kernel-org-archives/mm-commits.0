From: akpm@linux-foundation.org
Subject: + rfcomm-tty-destroy-before-tty_close.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:10:14 -0800
Message-ID: <200801270510.m0R5AB4M030800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbYA0FKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:10:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, marcel@holtmann.org


The patch titled
     rfcomm tty: destroy before tty_close()
has been added to the -mm tree.  Its filename is
     rfcomm-tty-destroy-before-tty_close.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-cpufreq.patch
tcp-newreno-must-count-every-skb-while-marking-losses.patch
bluetooth-hidp_process_hid_control-remove-unnecessary-parameter-dealing.patch
rfcomm-tty-destroy-before-tty_close.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-isofs-from-using-read_inode-fix-2.patch
iget-stop-isofs-from-using-read_inode-fix-2-update.patch
