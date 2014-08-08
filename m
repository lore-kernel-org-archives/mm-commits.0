From: akpm@linux-foundation.org
Subject: + rtsx_usb-export-device-table.patch added to -mm tree
Date: Fri, 08 Aug 2014 15:20:36 -0700
Message-ID: <53e54d34.4eotJwQVdb+WWvYw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:39840 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbaHHWUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 18:20:37 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so1119694oac.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 15:20:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, rogerable@realtek.com, stable@vger.kernel.org, wittemar@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/mfd/rtsx_usb.c: export device table
has been added to the -mm tree.  Its filename is
     rtsx_usb-export-device-table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtsx_usb-export-device-table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtsx_usb-export-device-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Mahoney <jeffm@suse.com>
Subject: drivers/mfd/rtsx_usb.c: export device table

The rtsx_usb driver contains the table for the devices it supports but
doesn't export it.  As a result, no alias is generated and it doesn't get
loaded automatically.

Via https://bugzilla.novell.com/show_bug.cgi?id=890096

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reported-by: Marcel Witte <wittemar@googlemail.com>
Cc: Roger Tseng <rogerable@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/rtsx_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mfd/rtsx_usb.c~rtsx_usb-export-device-table drivers/mfd/rtsx_usb.c
--- a/drivers/mfd/rtsx_usb.c~rtsx_usb-export-device-table
+++ a/drivers/mfd/rtsx_usb.c
@@ -744,6 +744,7 @@ static struct usb_device_id rtsx_usb_usb
 	{ USB_DEVICE(0x0BDA, 0x0140) },
 	{ }
 };
+MODULE_DEVICE_TABLE(usb, rtsx_usb_usb_ids);
 
 static struct usb_driver rtsx_usb_driver = {
 	.name			= "rtsx_usb",
_

Patches currently in -mm which might be from jeffm@suse.com are

fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
rtsx_usb-export-device-table.patch
linux-next.patch

