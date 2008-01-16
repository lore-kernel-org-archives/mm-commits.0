From: akpm@linux-foundation.org
Subject: - usbfs-struct-async-is-a-fixed-size-structure.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:44 -0800
Message-ID: <200801160139.m0G1diXX014027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036AbYAPBt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     usbfs: struct async is a fixed size structure
has been removed from the -mm tree.  Its filename was
     usbfs-struct-async-is-a-fixed-size-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usbfs: struct async is a fixed size structure
From: Pete Zaitcev <zaitcev@redhat.com>

The ISO descriptors are allocated separately in proc_submiturb for a fetch
from user mode, then tucked at the end of URB. This seems like a dead code.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/devio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/core/devio.c~usbfs-struct-async-is-a-fixed-size-structure drivers/usb/core/devio.c
--- a/drivers/usb/core/devio.c~usbfs-struct-async-is-a-fixed-size-structure
+++ a/drivers/usb/core/devio.c
@@ -210,9 +210,9 @@ err:
 
 static struct async *alloc_async(unsigned int numisoframes)
 {
-        unsigned int assize = sizeof(struct async) + numisoframes * sizeof(struct usb_iso_packet_descriptor);
-        struct async *as = kzalloc(assize, GFP_KERNEL);
+	struct async *as;
 
+	as = kzalloc(sizeof(struct async), GFP_KERNEL);
         if (!as)
                 return NULL;
 	as->urb = usb_alloc_urb(numisoframes, GFP_KERNEL);
_

Patches currently in -mm which might be from zaitcev@redhat.com are

usb-libusual-locking-cleanup.patch
