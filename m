From: akpm@linux-foundation.org
Subject: + usb-mass-storage-limit-rockchip-rock-mp3-device-071b3203-max-i-o-to-64-sectors-per-command.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:10:11 -0700
Message-ID: <200709110510.l8B5ABEx026707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36362 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755904AbXIKFKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:10:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: massimiliano.ghilardi@gmail.com, greg@kroah.com, mdharm-usb@one-eyed-alien.net


The patch titled
     USB Mass Storage: limit "Rockchip ROCK MP3" device (071b:3203) max I/O to 64 sectors per command
has been added to the -mm tree.  Its filename is
     usb-mass-storage-limit-rockchip-rock-mp3-device-071b3203-max-i-o-to-64-sectors-per-command.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB Mass Storage: limit "Rockchip ROCK MP3" device (071b:3203) max I/O to 64 sectors per command
From: Massimiliano Ghilardi <massimiliano.ghilardi@gmail.com>

The MP3/MP4/AVI player "Rockchip ROCK MP3" is seen as a USB disk, but fails
if more than 128 sectors (64kB) are sent or requested in a single read or write
command, and disconnects from the USB bus.

Typical kernel log showing the problem is:

usb 3-1: reset high speed USB device using ehci_hcd and address 6
usb 3-1: reset high speed USB device using ehci_hcd and address 6
sd 14:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sdb, sector 32
sd 14:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sdb, sector 32
usb 3-1: USB disconnect, address 6

This patch works around the device limitation by adding "Rockchip ROCK MP3"
to unusual USB devices list and limiting data transfers to 64 sectors (32kB)
per command.
Tested on 2.6.23-rc5 (amd64).

Signed-off-by: Massimiliano Ghilardi <massimiliano.ghilardi@gmail.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/unusual_devs.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/usb/storage/unusual_devs.h~usb-mass-storage-limit-rockchip-rock-mp3-device-071b3203-max-i-o-to-64-sectors-per-command drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-mass-storage-limit-rockchip-rock-mp3-device-071b3203-max-i-o-to-64-sectors-per-command
+++ a/drivers/usb/storage/unusual_devs.h
@@ -897,6 +897,22 @@ UNUSUAL_DEV(  0x069b, 0x3004, 0x0001, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Massimiliano Ghilardi <massimiliano.ghilardi@gmail.com>
+ * This USB MP3/AVI player device fails and disconnects if more than 128 sectors (64kB)
+ * are read/written in a single command, and may be present at least in the following products:
+ *
+ * "Magnex Digital Video Panel DVP 1800"
+ * "MP4 AIGO 4GB SLOT SD"
+ * "Teclast TL-C260 MP3"
+ * "i.Meizu PMP MP3/MP4"
+ * "Speed MV8 MP4 Audio Player"
+ */
+UNUSUAL_DEV(  0x071b, 0x3203, 0x0100, 0x0100,
+		"RockChip",
+		"ROCK MP3",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64),
+
 /* Reported by Olivier Blondeau <zeitoun@gmail.com> */
 UNUSUAL_DEV(  0x0727, 0x0306, 0x0100, 0x0100,
 		"ATMEL",
_

Patches currently in -mm which might be from massimiliano.ghilardi@gmail.com are

usb-mass-storage-limit-rockchip-rock-mp3-device-071b3203-max-i-o-to-64-sectors-per-command.patch
