From: akpm@linux-foundation.org
Subject: - drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:46:22 -0700
Message-ID: <200809130746.m8D7kMmO026848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753394AbYIMHq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:46:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brunel@diku.dk, greg@kroah.com, julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/misc: Use an IS_ERR test rather than a NULL test
has been removed from the -mm tree.  Its filename was
     drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/misc: Use an IS_ERR test rather than a NULL test
From: Julien Brunel <brunel@diku.dk>

In case of error, the function backlight_device_register returns an
ERR pointer, but never returns a NULL pointer. So a NULL test that may
come after a call to this function should be strengthened by an IS_ERR
test.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match_bad_null_test@
expression x, E;
statement S1,S2;
@@
x = backlight_device_register(...)
... when != x = E
* if (x != NULL)
S1 else S2
// </smpl>

Signed-off-by: Julien Brunel <brunel@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/appledisplay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/misc/appledisplay.c~drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test drivers/usb/misc/appledisplay.c
--- a/drivers/usb/misc/appledisplay.c~drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test
+++ a/drivers/usb/misc/appledisplay.c
@@ -314,7 +314,7 @@ error:
 					pdata->urbdata, pdata->urb->transfer_dma);
 			usb_free_urb(pdata->urb);
 		}
-		if (pdata->bd)
+		if (pdata->bd && !IS_ERR(pdata->bd))
 			backlight_device_unregister(pdata->bd);
 		kfree(pdata->msgdata);
 	}
_

Patches currently in -mm which might be from brunel@diku.dk are

linux-next.patch
fs-9p-use-an-is_err-test-rather-than-a-null-test.patch
checkpatch-suppress-errors-triggered-by-short-patch.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

