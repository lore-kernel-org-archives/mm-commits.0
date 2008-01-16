From: akpm@linux-foundation.org
Subject: - fix-2624-rc7-regression-in-asixc.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:40:15 -0800
Message-ID: <200801160140.m0G1eFte014097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036AbYAPBt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: russ.dill@gmail.com, Russ.Dill@gmail.com, greg@kroah.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Fix 2.6.24-rc7 regression in asix.c
has been removed from the -mm tree.  Its filename was
     fix-2624-rc7-regression-in-asixc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix 2.6.24-rc7 regression in asix.c
From: Russ Dill <russ.dill@gmail.com>

51bf2976 caused a regression in the asix usbnet driver.  usb_control_msg
returns the number of bytes read on success, not 0.  Tested with NETGEAR
FA120.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/asix.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/usb/asix.c~fix-2624-rc7-regression-in-asixc drivers/net/usb/asix.c
--- a/drivers/net/usb/asix.c~fix-2624-rc7-regression-in-asixc
+++ a/drivers/net/usb/asix.c
@@ -202,10 +202,10 @@ static int asix_read_cmd(struct usbnet *
 		buf,
 		size,
 		USB_CTRL_GET_TIMEOUT);
-	if (err >= 0 && err < size)
-		err = -EINVAL;
-	if (!err)
+	if (err == size)
 		memcpy(data, buf, size);
+	else if (err >= 0)
+		err = -EINVAL;
 	kfree(buf);
 
 out:
_

Patches currently in -mm which might be from russ.dill@gmail.com are
