From: akpm@linux-foundation.org
Subject: [merged]
 drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:37 -0800
Message-ID: <52e2b855.kuJeigjXkhUvqMO0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, florian@openwrt.org, dan.carpenter@oracle.com

Subject: [merged] drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch removed from -mm tree
To: dan.carpenter@oracle.com,florian@openwrt.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:37 -0800


The patch titled
     Subject: drivers/vlynq/vlynq.c: fix another resource size off by 1 error
has been removed from the -mm tree.  Its filename was
     drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/vlynq/vlynq.c: fix another resource size off by 1 error

We fixed the call to request_mem_region() patch 3354f73
("drivers/vlynq/vlynq.c: fix resource size off by 1 error").  But we need
to fix the call the release_mem_region() as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vlynq/vlynq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/vlynq/vlynq.c~drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error drivers/vlynq/vlynq.c
--- a/drivers/vlynq/vlynq.c~drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error
+++ a/drivers/vlynq/vlynq.c
@@ -762,7 +762,8 @@ static int vlynq_remove(struct platform_
 
 	device_unregister(&dev->dev);
 	iounmap(dev->local);
-	release_mem_region(dev->regs_start, dev->regs_end - dev->regs_start);
+	release_mem_region(dev->regs_start,
+			   dev->regs_end - dev->regs_start + 1);
 
 	kfree(dev);
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
linux-next.patch
zram-fix-race-between-reset-and-flushing-pending-work.patch

