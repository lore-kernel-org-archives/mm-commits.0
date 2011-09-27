From: akpm@google.com
Subject: [merged] drivers-media-dvb-dvb-usb-usb-urbc-adjust-array-index.patch removed from -mm tree
Date: Tue, 27 Sep 2011 12:11:33 -0700
Message-ID: <201109271911.p8RJBX09019631@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:45576 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1I0TLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 15:11:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/dvb/dvb-usb/usb-urb.c: adjust array index
has been removed from the -mm tree.  Its filename was
     drivers-media-dvb-dvb-usb-usb-urbc-adjust-array-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Julia Lawall <julia@diku.dk>
Subject: drivers/media/dvb/dvb-usb/usb-urb.c: adjust array index

Convert array index from the loop bound to the loop index.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,ar;
@@

for(e1 = 0; e1 < e2; e1++) { <...
  ar[
- e2
+ e1
  ]
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/media/dvb/dvb-usb/usb-urb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/usb-urb.c~drivers-media-dvb-dvb-usb-usb-urbc-adjust-array-index drivers/media/dvb/dvb-usb/usb-urb.c
--- a/drivers/media/dvb/dvb-usb/usb-urb.c~drivers-media-dvb-dvb-usb-usb-urbc-adjust-array-index
+++ a/drivers/media/dvb/dvb-usb/usb-urb.c
@@ -148,7 +148,7 @@ static int usb_bulk_urb_init(struct usb_
 		if (!stream->urb_list[i]) {
 			deb_mem("not enough memory for urb_alloc_urb!.\n");
 			for (j = 0; j < i; j++)
-				usb_free_urb(stream->urb_list[i]);
+				usb_free_urb(stream->urb_list[j]);
 			return -ENOMEM;
 		}
 		usb_fill_bulk_urb( stream->urb_list[i], stream->udev,
@@ -181,7 +181,7 @@ static int usb_isoc_urb_init(struct usb_
 		if (!stream->urb_list[i]) {
 			deb_mem("not enough memory for urb_alloc_urb!\n");
 			for (j = 0; j < i; j++)
-				usb_free_urb(stream->urb_list[i]);
+				usb_free_urb(stream->urb_list[j]);
 			return -ENOMEM;
 		}
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-gpu-vga-vgaarbc-add-missing-kfree.patch

