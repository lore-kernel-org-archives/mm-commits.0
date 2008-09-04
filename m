From: akpm@linux-foundation.org
Subject: + drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test.patch added to -mm tree
Date: Thu, 04 Sep 2008 13:13:54 -0700
Message-ID: <200809042013.m84KDsbQ028597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754254AbYIDUPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 16:15:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brunel@diku.dk, greg@kroah.com, julia@diku.dk


The patch titled
     drivers/usb/misc: Use an IS_ERR test rather than a NULL test
has been added to the -mm tree.  Its filename is
     drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test.patch

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

origin.patch
linux-next.patch
fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch
checkpatch-suppress-errors-triggered-by-short-patch.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch
drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test.patch

