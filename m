From: akpm@linux-foundation.org
Subject: [merged] uvcvideo-add-fix_bandwidth-quirk-to-hp-webcam-found-on-hp-mini-5103-netbook.patch removed from -mm tree
Date: Mon, 01 Aug 2011 11:49:18 -0700
Message-ID: <201108011847.p71IlA45005621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856Ab1HASr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 14:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirr@mns.spb.ru, laurent.pinchart@ideasonboard.com, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     uvcvideo: add FIX_BANDWIDTH quirk to HP Webcam found on HP Mini 5103 netbook
has been removed from the -mm tree.  Its filename was
     uvcvideo-add-fix_bandwidth-quirk-to-hp-webcam-found-on-hp-mini-5103-netbook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uvcvideo: add FIX_BANDWIDTH quirk to HP Webcam found on HP Mini 5103 netbook
From: Kirill Smelkov <kirr@mns.spb.ru>

The camera there identifies itself as being manufactured by Cheng Uei
Precision Industry Co., Ltd (Foxlink), and product is titled as "HP Webcam
[2 MP Fixed]".

I was trying to get 2 USB video capture devices to work simultaneously,
and noticed that the above mentioned webcam always requires packet size =
3072 bytes per micro frame (~= 23.4 MB/s isoc bandwidth), which is far
more than enough to get standard NTSC 640x480x2x30 = ~17.6 MB/s isoc
bandwidth.

As there are alt interfaces with smaller MxPS

    T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
    D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
    P:  Vendor=05c8 ProdID=0403 Rev= 1.06
    S:  Manufacturer=Foxlink
    S:  Product=HP Webcam [2 MP Fixed]
    S:  SerialNumber=200909240102
    C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
    A:  FirstIf#= 0 IfCount= 2 Cls=0e(video) Sub=03 Prot=00
    I:* If#= 0 Alt= 0 #EPs= 1 Cls=0e(video) Sub=01 Prot=00 Driver=uvcvideo
    E:  Ad=83(I) Atr=03(Int.) MxPS=  16 Ivl=4ms
    I:* If#= 1 Alt= 0 #EPs= 0 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    I:  If#= 1 Alt= 1 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS= 128 Ivl=125us
    I:  If#= 1 Alt= 2 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS= 512 Ivl=125us
    I:  If#= 1 Alt= 3 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS=1024 Ivl=125us
    I:  If#= 1 Alt= 4 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS=1536 Ivl=125us
    I:  If#= 1 Alt= 5 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS=2048 Ivl=125us
    I:  If#= 1 Alt= 6 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS=2688 Ivl=125us
    I:  If#= 1 Alt= 7 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS=3072 Ivl=125us

UVC_QUIRK_FIX_BANDWIDTH helps here and NTSC video can be served with
MxPS=2688 i.e. 20.5 MB/s isoc bandwidth.

In terms of microframe time allocation, before the quirk NTSC video
required 60 usecs / microframe and 53 usecs / microframe after.

Now with tweaked ehci-hcd to allow up to 90% isoc bandwidth (cc62a7eb
"USB: EHCI: Allow users to override 80% max periodic bandwidth") I can
capture two video sources -- PAL 720x576 YUV422 @25fps + NTSC 640x480
YUV422 @30fps simultaneously.  Hooray!

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/uvc/uvc_driver.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/media/video/uvc/uvc_driver.c~uvcvideo-add-fix_bandwidth-quirk-to-hp-webcam-found-on-hp-mini-5103-netbook drivers/media/video/uvc/uvc_driver.c
--- a/drivers/media/video/uvc/uvc_driver.c~uvcvideo-add-fix_bandwidth-quirk-to-hp-webcam-found-on-hp-mini-5103-netbook
+++ a/drivers/media/video/uvc/uvc_driver.c
@@ -2131,6 +2131,15 @@ static struct usb_device_id uvc_ids[] = 
 	  .bInterfaceProtocol	= 0,
 	  .driver_info 		= UVC_QUIRK_PROBE_MINMAX
 				| UVC_QUIRK_BUILTIN_ISIGHT },
+	/* Foxlink ("HP Webcam" on HP Mini 5103) */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x05c8,
+	  .idProduct		= 0x0403,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
 	/* Genesys Logic USB 2.0 PC Camera */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
_

Patches currently in -mm which might be from kirr@mns.spb.ru are

origin.patch

