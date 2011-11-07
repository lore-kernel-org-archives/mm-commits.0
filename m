From: akpm@linux-foundation.org
Subject: [merged] w1-disable-irqs-in-critical-section.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:47 -0800
Message-ID: <201111072029.pA7KTlPH013738@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5929 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1KGU3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: j.weitzel@phytec.de, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: w1: disable irqs in critical section
has been removed from the -mm tree.  Its filename was
     w1-disable-irqs-in-critical-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jan Weitzel <j.weitzel@phytec.de>
Subject: w1: disable irqs in critical section

Interrupting w1_delay() in w1_read_bit() results in missing the low level
on the w1 line and receiving "1" instead of "0".

Add local_irq_save()/local_irq_restore() around the critical section

Signed-off-by: Jan Weitzel <j.weitzel@phytec.de>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_io.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/w1/w1_io.c~w1-disable-irqs-in-critical-section drivers/w1/w1_io.c
--- a/drivers/w1/w1_io.c~w1-disable-irqs-in-critical-section
+++ a/drivers/w1/w1_io.c
@@ -158,13 +158,18 @@ EXPORT_SYMBOL_GPL(w1_write_8);
 static u8 w1_read_bit(struct w1_master *dev)
 {
 	int result;
+	unsigned long flags;
 
+	/* sample timing is critical here */
+	local_irq_save(flags);
 	dev->bus_master->write_bit(dev->bus_master->data, 0);
 	w1_delay(6);
 	dev->bus_master->write_bit(dev->bus_master->data, 1);
 	w1_delay(9);
 
 	result = dev->bus_master->read_bit(dev->bus_master->data);
+	local_irq_restore(flags);
+
 	w1_delay(55);
 
 	return result & 0x1;
_

Patches currently in -mm which might be from j.weitzel@phytec.de are

origin.patch
linux-next.patch

