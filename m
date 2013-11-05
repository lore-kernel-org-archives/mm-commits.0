From: akpm@linux-foundation.org
Subject: [merged]
 drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1.patch removed from -mm tree
Date: Tue, 05 Nov 2013 11:29:03 -0800
Message-ID: <527946ff.OaFZmLYt5N/rASz7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3KET3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 14:29:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, scameron@beardog.cce.hp.com

Subject: [merged] drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1.patch removed from -mm tree
To: scameron@beardog.cce.hp.com,axboe@kernel.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 11:29:03 -0800


The patch titled
     Subject: drivers/block/cciss.c: return 0 from driver probe function on success, not 1
has been removed from the -mm tree.  Its filename was
     drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Subject: drivers/block/cciss.c: return 0 from driver probe function on success, not 1

A return value of 1 is interpreted as an error.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1 drivers/block/cciss.c
--- a/drivers/block/cciss.c~drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1
+++ a/drivers/block/cciss.c
@@ -5183,7 +5183,7 @@ reinit_after_soft_reset:
 	rebuild_lun_table(h, 1, 0);
 	cciss_engage_scsi(h);
 	h->busy_initializing = 0;
-	return 1;
+	return 0;
 
 clean4:
 	cciss_free_cmd_pool(h);
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

linux-next.patch
drivers-pci-pci-driverc-warn-on-driver-probe-return-value-greater-than-zero.patch
hpsa-return-0-from-driver-probe-function-on-success-not-1.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch

