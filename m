From: akpm@linux-foundation.org
Subject: [merged]
 drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:59:55 -0800
Message-ID: <52e2b82b.roq9ap59FLMi1oUp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, s-anna@ti.com, omar.ramirez@copitl.com, gregkh@linuxfoundation.org, dan.carpenter@oracle.com

Subject: [merged] drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch removed from -mm tree
To: dan.carpenter@oracle.com,gregkh@linuxfoundation.org,omar.ramirez@copitl.com,s-anna@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:55 -0800


The patch titled
     Subject: drivers/mailbox/omap: make mbox->irq signed for error handling
has been removed from the -mm tree.  Its filename was
     drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/mailbox/omap: make mbox->irq signed for error handling

There is a bug in omap2_mbox_probe() where we try do:

		mbox->irq = platform_get_irq(pdev, info->irq_id);
		if (mbox->irq < 0) {

The problem is that mbox->irq is unsigned so the error handling doesn't
work.  I've changed it to a signed integer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Suman Anna <s-anna@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mailbox/omap-mbox.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mailbox/omap-mbox.h~drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling drivers/mailbox/omap-mbox.h
--- a/drivers/mailbox/omap-mbox.h~drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling
+++ a/drivers/mailbox/omap-mbox.h
@@ -52,7 +52,7 @@ struct omap_mbox_queue {
 
 struct omap_mbox {
 	const char		*name;
-	unsigned int		irq;
+	int			irq;
 	struct omap_mbox_queue	*txq, *rxq;
 	struct omap_mbox_ops	*ops;
 	struct device		*dev;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
linux-next.patch
zram-fix-race-between-reset-and-flushing-pending-work.patch

