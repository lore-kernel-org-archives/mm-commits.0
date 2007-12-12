From: akpm@linux-foundation.org
Subject: + virtio_net-remove-double-ether_setup.patch added to -mm tree
Date: Tue, 11 Dec 2007 23:56:53 -0800
Message-ID: <200712120756.lBC7urwA032326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50739 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbXLLH5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 02:57:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borntraeger@de.ibm.com, rusty@rustcorp.com.au


The patch titled
     virtio_net: remove double ether_setup
has been added to the -mm tree.  Its filename is
     virtio_net-remove-double-ether_setup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: virtio_net: remove double ether_setup
From: Christian Borntraeger <borntraeger@de.ibm.com>

this is a CA small fix for virtio_net.  virtnet_probe already calls
alloc_etherdev, which calls ether_setup.  There is no need to do that
again.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/virtio_net.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/virtio_net.c~virtio_net-remove-double-ether_setup drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c~virtio_net-remove-double-ether_setup
+++ a/drivers/net/virtio_net.c
@@ -331,7 +331,6 @@ static int virtnet_probe(struct virtio_d
 		return -ENOMEM;
 
 	/* Set up network device as normal. */
-	ether_setup(dev);
 	dev->open = virtnet_open;
 	dev->stop = virtnet_close;
 	dev->hard_start_xmit = start_xmit;
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are

git-kvm.patch
virtio_net-remove-double-ether_setup.patch
git-s390.patch
