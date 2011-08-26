From: akpm@linux-foundation.org
Subject: + drivers-media-dvb-dvb-usb-usb-urbc-adjust-array-index.patch added to -mm tree
Date: Fri, 26 Aug 2011 16:24:12 -0700
Message-ID: <201108262324.p7QNOC2t018557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab1HZXYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 19:24:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mchehab@infradead.org


The patch titled
     drivers/media/dvb/dvb-usb/usb-urb.c: adjust array index
has been added to the -mm tree.  Its filename is
     drivers-media-dvb-dvb-usb-usb-urbc-adjust-array-index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/dvb/dvb-usb/usb-urb.c: adjust array index
From: Julia Lawall <julia@diku.dk>

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
linux-next.patch
drivers-gpu-vga-vgaarbc-add-missing-kfree.patch
drivers-media-dvb-dvb-usb-usb-urbc-adjust-array-index.patch

