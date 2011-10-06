From: akpm@google.com
Subject: + w1-disable-irqs-in-critical-section.patch added to -mm tree
Date: Thu, 06 Oct 2011 16:19:38 -0700
Message-ID: <201110062319.p96NJccr005789@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:13655 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab1JFXTy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 19:19:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: j.weitzel@phytec.de, zbr@ioremap.net


The patch titled
     Subject: w1: disable irqs in critical section
has been added to the -mm tree.  Its filename is
     w1-disable-irqs-in-critical-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jan Weitzel <j.weitzel@phytec.de>
Subject: w1: disable irqs in critical section

Interrupting w1_delay() in w1_read_bit() results in missing the low level
on the w1 line and receiving "1" instead of "0".

Add local_irq_save()/local_irq_restore() around the critical section

Signed-off-by: Jan Weitzel <j.weitzel@phytec.de>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: w1: disable irqs in critical section

Patches currently in -mm which might be from j.weitzel@phytec.de are

linux-next.patch
w1-disable-irqs-in-critical-section.patch

