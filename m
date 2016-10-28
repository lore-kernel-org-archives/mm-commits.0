From: akpm@linux-foundation.org
Subject: [patch 17/20] block: DAC960: print a hex number after a 0x prefix
Date: Thu, 27 Oct 2016 17:47:04 -0700
Message-ID: <5812a008.nYJfI9h7cpIyTeGL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943135AbcJ1ArF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 20:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: block: DAC960: print a hex number after a 0x prefix

It makes the message hard to interpret correctly if a base 10 number is
prefixed by 0x.  So change to a hex number.

Link: http://lkml.kernel.org/r/20161026125658.25728-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/DAC960.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/DAC960.c~block-dac960-print-a-hex-number-after-a-0x-prefix drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~block-dac960-print-a-hex-number-after-a-0x-prefix
+++ a/drivers/block/DAC960.c
@@ -2954,7 +2954,7 @@ DAC960_DetectController(struct pci_dev *
 	case DAC960_PD_Controller:
 	  if (!request_region(Controller->IO_Address, 0x80,
 			      Controller->FullModelName)) {
-		DAC960_Error("IO port 0x%d busy for Controller at\n",
+		DAC960_Error("IO port 0x%lx busy for Controller at\n",
 			     Controller, Controller->IO_Address);
 		goto Failure;
 	  }
@@ -2990,7 +2990,7 @@ DAC960_DetectController(struct pci_dev *
 	case DAC960_P_Controller:
 	  if (!request_region(Controller->IO_Address, 0x80,
 			      Controller->FullModelName)){
-		DAC960_Error("IO port 0x%d busy for Controller at\n",
+		DAC960_Error("IO port 0x%lx busy for Controller at\n",
 		   	     Controller, Controller->IO_Address);
 		goto Failure;
 	  }
_
