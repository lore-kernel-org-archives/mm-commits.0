From: akpm@linux-foundation.org
Subject: - phonedev-remove-bkl.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:46 -0700
Message-ID: <200810202035.m9KKZkEh011221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbYJTUpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:45:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aciddeath@gmail.com, mm-commits@vger.kernel.org


The patch titled
     phonedev: remove BKL
has been removed from the -mm tree.  Its filename was
     phonedev-remove-bkl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: phonedev: remove BKL
From: Richard Holden <aciddeath@gmail.com>

The phone_device array is covered by the phone_lock mutex in all cases and
request_module no longer needs the BKL so we can remove the only remaining
instance of the BKL from phonedev.

Signed-off-by: Richard Holden <aciddeath@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/phonedev.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/telephony/phonedev.c~phonedev-remove-bkl drivers/telephony/phonedev.c
--- a/drivers/telephony/phonedev.c~phonedev-remove-bkl
+++ a/drivers/telephony/phonedev.c
@@ -54,7 +54,6 @@ static int phone_open(struct inode *inod
 	if (minor >= PHONE_NUM_DEVICES)
 		return -ENODEV;
 
-	lock_kernel();
 	mutex_lock(&phone_lock);
 	p = phone_device[minor];
 	if (p)
@@ -81,7 +80,6 @@ static int phone_open(struct inode *inod
 	fops_put(old_fops);
 end:
 	mutex_unlock(&phone_lock);
-	unlock_kernel();
 	return err;
 }
 
_

Patches currently in -mm which might be from aciddeath@gmail.com are

origin.patch

