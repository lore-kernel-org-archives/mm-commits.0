From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-introduce-missing-kfree.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:33:59 -0800
Message-ID: <200911302033.nAUKXxAM022431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbZK3Uee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:34:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video: introduce missing kfree
has been removed from the -mm tree.  Its filename was
     drivers-media-video-introduce-missing-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data. 
Similarly for usb-alloc urb.

The semantic match that finds the first problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/hdpvr/hdpvr-video.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/hdpvr/hdpvr-video.c~drivers-media-video-introduce-missing-kfree drivers/media/video/hdpvr/hdpvr-video.c
--- a/drivers/media/video/hdpvr/hdpvr-video.c~drivers-media-video-introduce-missing-kfree
+++ a/drivers/media/video/hdpvr/hdpvr-video.c
@@ -139,7 +139,7 @@ int hdpvr_alloc_buffers(struct hdpvr_dev
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
 			v4l2_err(&dev->v4l2_dev, "cannot allocate urb\n");
-			goto exit;
+			goto exit_urb;
 		}
 		buf->urb = urb;
 
@@ -148,7 +148,7 @@ int hdpvr_alloc_buffers(struct hdpvr_dev
 		if (!mem) {
 			v4l2_err(&dev->v4l2_dev,
 				 "cannot allocate usb transfer buffer\n");
-			goto exit;
+			goto exit_urb_buffer;
 		}
 
 		usb_fill_bulk_urb(buf->urb, dev->udev,
@@ -161,6 +161,10 @@ int hdpvr_alloc_buffers(struct hdpvr_dev
 		list_add_tail(&buf->buff_list, &dev->free_buff_list);
 	}
 	return 0;
+exit_urb_buffer:
+	usb_free_urb(urb);
+exit_urb:
+	kfree(buf);
 exit:
 	hdpvr_free_buffers(dev);
 	return retval;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-usb-host-xhci-memc-introduce-missing-kfree.patch
drivers-usb-host-ehci-omapc-introduce-missing-kfree.patch
drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch
drivers-cpuidle-move-dereference-after-null-test.patch
drivers-mmc-move-dereference-after-null-test.patch
drivers-video-move-dereference-after-null-test.patch
drivers-char-ipmi-use-kcs_idle_state.patch
drivers-edac-introduce-missing-kfree.patch

