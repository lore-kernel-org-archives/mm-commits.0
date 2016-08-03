From: akpm@linux-foundation.org
Subject: [merged] w1-omap_hdq-fix-regression.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:14:50 -0700
Message-ID: <57a2349a.+pjJSjtE+bZiwRuE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbcHCSOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:14:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hns@goldelico.com, gregkh@linuxfoundation.org, stable@vger.kernel.org, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: w1:omap_hdq: fix regression
has been removed from the -mm tree.  Its filename was
     w1-omap_hdq-fix-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: w1:omap_hdq: fix regression

commit e93762bbf681 ("w1: masters: omap_hdq: add support for 1-wire mode")
added a statement to clear the hdq_irqstatus flags in hdq_read_byte().

If the hdq reading process is scheduled slowly or interrupts are disabled
for a while the hardware read activity might already be finished on entry
of hdq_read_byte().  And hdq_isr() already has set the hdq_irqstatus to
0x6 (can be seen in debug mode) denoting that both, the TXCOMPLETE and
RXCOMPLETE interrupts occurred in parallel.

This means there is no need to wait and the hdq_read_byte() can just read
the byte from the hdq controller.

By resetting hdq_irqstatus to 0 the read process is forced to be always
waiting again (because the if statement always succeeds) but the hardware
will not issue another RXCOMPLETE interrupt.  This results in a false
timeout.

After such a situation the hdq bus hangs.

Link: http://lkml.kernel.org/r/b724765f87ad276a69625bc19806c8c8844c4590.1469513669.git.hns@goldelico.com
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/w1/masters/omap_hdq.c~w1-omap_hdq-fix-regression drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-omap_hdq-fix-regression
+++ a/drivers/w1/masters/omap_hdq.c
@@ -390,8 +390,6 @@ static int hdq_read_byte(struct hdq_data
 		goto out;
 	}
 
-	hdq_data->hdq_irqstatus = 0;
