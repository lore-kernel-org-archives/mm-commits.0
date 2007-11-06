From: akpm@linux-foundation.org
Subject: + w1-fix-memset-size-error.patch added to -mm tree
Date: Mon, 05 Nov 2007 17:12:09 -0800
Message-ID: <200711060112.lA61C98w029308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497AbXKFBM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 20:12:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, johnpol@2ka.mipt.ru


The patch titled
     W1: fix memset size error
has been added to the -mm tree.  Its filename is
     w1-fix-memset-size-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: W1: fix memset size error
From: Li Zefan <lizf@cn.fujitsu.com>

The size arguments passing to memset is wrong.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2490.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/masters/ds2490.c~w1-fix-memset-size-error drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~w1-fix-memset-size-error
+++ a/drivers/w1/masters/ds2490.c
@@ -233,7 +233,7 @@ static int ds_recv_status_nodump(struct 
 {
 	int count, err;
 
-	memset(st, 0, sizeof(st));
+	memset(st, 0, sizeof(*st));
 
 	count = 0;
 	err = usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_STATUS]), buf, size, &count, 100);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

time-fix-inconsistent-function-names-in-comments.patch
git-drm.patch
arm-fix-memset-size-error.patch
ia64-fix-memset-size-error.patch
powerpc-fix-memset-size-error.patch
drivers-video-ps3fb-fix-memset-size-error.patch
w1-fix-memset-size-error.patch
