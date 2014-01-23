From: akpm@linux-foundation.org
Subject: [merged] drivers-block-paride-pgc-underflow-bug-in-pg_write.patch removed from -mm tree
Date: Thu, 23 Jan 2014 12:42:42 -0800
Message-ID: <52e17ec2.lO+wb+A9URApdwJk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaAWUmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 15:42:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, dan.carpenter@oracle.com

Subject: [merged] drivers-block-paride-pgc-underflow-bug-in-pg_write.patch removed from -mm tree
To: dan.carpenter@oracle.com,axboe@kernel.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 12:42:42 -0800


The patch titled
     Subject: drivers/block/paride/pg.c: underflow bug in pg_write()
has been removed from the -mm tree.  Its filename was
     drivers-block-paride-pgc-underflow-bug-in-pg_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/block/paride/pg.c: underflow bug in pg_write()

The test here can underflow so we pass bogus lengths to the hardware. 
It's a static checker fix and I don't know the impact.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/paride/pg.c~drivers-block-paride-pgc-underflow-bug-in-pg_write drivers/block/paride/pg.c
--- a/drivers/block/paride/pg.c~drivers-block-paride-pgc-underflow-bug-in-pg_write
+++ a/drivers/block/paride/pg.c
@@ -581,7 +581,7 @@ static ssize_t pg_write(struct file *fil
 
 	if (hdr.magic != PG_MAGIC)
 		return -EINVAL;
-	if (hdr.dlen > PG_MAX_DATA)
+	if (hdr.dlen < 0 || hdr.dlen > PG_MAX_DATA)
 		return -EINVAL;
 	if ((count - hs) > PG_MAX_DATA)
 		return -EINVAL;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch
drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
linux-next.patch
zram-fix-race-between-reset-and-flushing-pending-work.patch

