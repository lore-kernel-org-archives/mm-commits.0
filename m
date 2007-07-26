From: akpm@linux-foundation.org
Subject: + fix-a-potential-null-pointer-dereference-in-write_bulk_callback.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:23:57 -0700
Message-ID: <200707262023.l6QKNv0n019161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51573 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbXGZUYQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:24:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: micah.gruber@gmail.com, petkan@nucleusys.com


The patch titled
     Fix a potential NULL pointer dereference in write_bulk_callback() in drivers/net/usb/pegasus.c
has been added to the -mm tree.  Its filename is
     fix-a-potential-null-pointer-dereference-in-write_bulk_callback.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix a potential NULL pointer dereference in write_bulk_callback() in drivers/net/usb/pegasus.c
From: Micah Gruber <micah.gruber@gmail.com>

This patch fixes a potential null dereference bug where we dereference
pegasus before a null check.  This patch simply moves the dereferencing
after the null check.

Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
Acked-by: Petko Manolov <petkan@nucleusys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/pegasus.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/usb/pegasus.c~fix-a-potential-null-pointer-dereference-in-write_bulk_callback drivers/net/usb/pegasus.c
--- a/drivers/net/usb/pegasus.c~fix-a-potential-null-pointer-dereference-in-write_bulk_callback
+++ a/drivers/net/usb/pegasus.c
@@ -768,11 +768,13 @@ done:
 static void write_bulk_callback(struct urb *urb)
 {
 	pegasus_t *pegasus = urb->context;
-	struct net_device *net = pegasus->net;
+	struct net_device *net;
 
 	if (!pegasus)
 		return;
 
+	net = pegasus->net;
+
 	if (!netif_device_present(net) || !netif_running(net))
 		return;
 
_

Patches currently in -mm which might be from micah.gruber@gmail.com are

fix-a-potential-null-pointer-dereference-in-write_bulk_callback.patch
