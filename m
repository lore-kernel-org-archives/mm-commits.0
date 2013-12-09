From: akpm@linux-foundation.org
Subject: [merged]
 drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch removed from -mm tree
Date: Mon, 09 Dec 2013 13:53:51 -0800
Message-ID: <52a63bef.BYDi4dhmjyzNW2P9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab3LIVxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 16:53:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, michael.opdenacker@free-electrons.com

Subject: [merged] drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch removed from -mm tree
To: michael.opdenacker@free-electrons.com,axboe@kernel.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 13:53:51 -0800


The patch titled
     Subject: drivers/cdrom/gdrom.c: remove deprecated IRQF_DISABLED
has been removed from the -mm tree.  Its filename was
     drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: drivers/cdrom/gdrom.c: remove deprecated IRQF_DISABLED

Remove the IRQF_DISABLED flag from drivers/cdrom/gdrom.c.

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/gdrom.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/cdrom/gdrom.c~drivers-cdrom-gdromc-remove-deprecated-irqf_disabled drivers/cdrom/gdrom.c
--- a/drivers/cdrom/gdrom.c~drivers-cdrom-gdromc-remove-deprecated-irqf_disabled
+++ a/drivers/cdrom/gdrom.c
@@ -561,11 +561,11 @@ static int gdrom_set_interrupt_handlers(
 	int err;
 
 	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt,
-		IRQF_DISABLED, "gdrom_command", &gd);
+		0, "gdrom_command", &gd);
 	if (err)
 		return err;
 	err = request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt,
-		IRQF_DISABLED, "gdrom_dma", &gd);
+		0, "gdrom_dma", &gd);
 	if (err)
 		free_irq(HW_EVENT_GDROM_CMD, &gd);
 	return err;
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

origin.patch
linux-next.patch

