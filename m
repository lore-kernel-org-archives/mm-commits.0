From: akpm@linux-foundation.org
Subject: - w1-fix-memset-size-error.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:08 -0800
Message-ID: <200711152108.lAFL88sd015330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757732AbXKOVIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:08:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: fix memset size error
has been removed from the -mm tree.  Its filename was
     w1-fix-memset-size-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
arm-fix-memset-size-error.patch
git-hid.patch
ia64-efi-make-full-use-of-macro-efi_md_size.patch
