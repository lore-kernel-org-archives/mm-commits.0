From: akpm@osdl.org
Subject: + ib-ipath-use-memcpy_uncached_read-in-rdma-interrupt.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:11:00 -0800
Message-ID: <200612140011.kBE0B0h2025617@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60485 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbWLNALa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:11:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bos@pathscale.com, ak@suse.de, bryan.osullivan@qlogic.com, rolandd@cisco.com


The patch titled
     IB/ipath: use memcpy_uncached_read() in RDMA interrupt handler to reduce packet loss
has been added to the -mm tree.  Its filename is
     ib-ipath-use-memcpy_uncached_read-in-rdma-interrupt.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IB/ipath: use memcpy_uncached_read() in RDMA interrupt handler to reduce packet loss
From: "Bryan O'Sullivan" <bos@pathscale.com>

In cases where a large incoming RDMA is being received, we have to copy data
inside the interrupt handler before we can ACK each packet.  The source is
DMAed to by the hardware, which means that the CPU won't have it cached.  We
only read the source this one time; using normal load instructions pollutes
the dcache with useless data, reducing performance to the point where we can
lose a significant number of packets.

We use memcpy_uncached_read to try to not fill the dcache with useless data. 
Avoiding the cache refill penalty lets us keep up better with the sender,
resulting in many fewer dropped packets.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/hw/ipath/ipath_verbs.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/hw/ipath/ipath_verbs.c~ib-ipath-use-memcpy_uncached_read-in-rdma-interrupt drivers/infiniband/hw/ipath/ipath_verbs.c
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c~ib-ipath-use-memcpy_uncached_read-in-rdma-interrupt
+++ a/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -167,7 +167,7 @@ void ipath_copy_sge(struct ipath_sge_sta
 		BUG_ON(len == 0);
 		if (len > length)
 			len = length;
-		memcpy(sge->vaddr, data, len);
+		memcpy_uncached_read(sge->vaddr, data, len);
 		sge->vaddr += len;
 		sge->length -= len;
 		sge->sge_length -= len;
_

Patches currently in -mm which might be from bos@pathscale.com are

add-memcpy_uncached_read.patch
ib-ipath-use-memcpy_uncached_read-in-rdma-interrupt.patch

