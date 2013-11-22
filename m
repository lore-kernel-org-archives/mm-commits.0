From: akpm@linux-foundation.org
Subject: +
 drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch added to -mm tree
Date: Fri, 22 Nov 2013 15:29:33 -0800
Message-ID: <528fe8dd.lICzHXd4E5iOBRuc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3KVX3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 18:29:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, s-anna@ti.com, omar.ramirez@copitl.com, gregkh@linuxfoundation.org, dan.carpenter@oracle.com

Subject: + drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch added to -mm tree
To: dan.carpenter@oracle.com,gregkh@linuxfoundation.org,omar.ramirez@copitl.com,s-anna@ti.com
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 15:29:33 -0800


The patch titled
     Subject: drivers/mailbox/omap: make mbox->irq signed for error handling
has been added to the -mm tree.  Its filename is
     drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
xfs-underflow-bug-in-xfs_attrlist_by_handle.patch
drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch
linux-next.patch

