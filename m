From: akpm@linux-foundation.org
Subject: + fix-2624-rc7-regression-in-asixc.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:02:00 -0800
Message-ID: <200801151001.m0FA1eUn009970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293AbYAOKBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:01:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: russ.dill@gmail.com, Russ.Dill@gmail.com, greg@kroah.com, viro@zeniv.linux.org.uk


The patch titled
     Fix 2.6.24-rc7 regression in asix.c
has been added to the -mm tree.  Its filename is
     fix-2624-rc7-regression-in-asixc.patch

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

fix-2624-rc7-regression-in-asixc.patch
