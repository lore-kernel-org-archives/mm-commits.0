From: akpm@linux-foundation.org
Subject: - virtio_net-remove-double-ether_setup.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:54:10 -0800
Message-ID: <200802050253.m152rp5X031537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbYBECyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:54:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     virtio_net: remove double ether_setup
has been removed from the -mm tree.  Its filename was
     virtio_net-remove-double-ether_setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
git-kvm.patch
