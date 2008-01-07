From: akpm@linux-foundation.org
Subject: + usbfs-struct-async-is-a-fixed-size-structure.patch added to -mm tree
Date: Mon, 07 Jan 2008 15:55:09 -0800
Message-ID: <200801072355.m07Nt9rE018680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755642AbYAGX4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 18:56:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zaitcev@redhat.com


The patch titled
     usbfs: struct async is a fixed size structure
has been added to the -mm tree.  Its filename is
     usbfs-struct-async-is-a-fixed-size-structure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
usbfs-struct-async-is-a-fixed-size-structure.patch
