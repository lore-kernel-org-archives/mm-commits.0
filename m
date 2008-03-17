From: akpm@linux-foundation.org
Subject: - au1550_spi-fix-prototype-of-irq-handler.patch removed from -mm tree
Date: Mon, 17 Mar 2008 13:57:27 -0700
Message-ID: <200803172057.m2HKvR12030628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754378AbYCQU6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 16:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.nikitenko@gmail.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     au1550_spi: fix prototype of irq handler
has been removed from the -mm tree.  Its filename was
     au1550_spi-fix-prototype-of-irq-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: au1550_spi: fix prototype of irq handler
From: Jan Nikitenko <jan.nikitenko@gmail.com>

Remove struct pt_regs *regs from prototype of au1550_spi_irq handler to avoid
warning in request_irq().  Also fix comment type leadin.

Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>
Signed-off-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/au1550_spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/au1550_spi.c~au1550_spi-fix-prototype-of-irq-handler drivers/spi/au1550_spi.c
--- a/drivers/spi/au1550_spi.c~au1550_spi-fix-prototype-of-irq-handler
+++ a/drivers/spi/au1550_spi.c
@@ -99,7 +99,7 @@ static dbdev_tab_t au1550_spi_mem_dbdev 
 static void au1550_spi_bits_handlers_set(struct au1550_spi *hw, int bpw);
 
 
-/**
+/*
  *  compute BRG and DIV bits to setup spi clock based on main input clock rate
  *  that was specified in platform data structure
  *  according to au1550 datasheet:
@@ -650,7 +650,7 @@ static int au1550_spi_txrx_bufs(struct s
 	return hw->txrx_bufs(spi, t);
 }
 
-static irqreturn_t au1550_spi_irq(int irq, void *dev, struct pt_regs *regs)
+static irqreturn_t au1550_spi_irq(int irq, void *dev)
 {
 	struct au1550_spi *hw = dev;
 	return hw->irq_callback(hw);
_

Patches currently in -mm which might be from jan.nikitenko@gmail.com are


