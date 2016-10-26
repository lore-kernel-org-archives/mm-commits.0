From: akpm@linux-foundation.org
Subject: + block-dac960-print-a-hex-number-after-a-0x-prefix.patch added
 to -mm tree
Date: Wed, 26 Oct 2016 12:50:32 -0700
Message-ID: <58110908.AQRT0gtQGhpisOz2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37404 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932910AbcJZTud (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 15:50:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: block: DAC960: print a hex number after a 0x prefix
has been added to the -mm tree.  Its filename is
     block-dac960-print-a-hex-number-after-a-0x-prefix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-dac960-print-a-hex-number-after-a-0x-prefix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-dac960-print-a-hex-number-after-a-0x-prefix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de are

fs-exofs-print-a-hex-number-after-a-0x-prefix.patch
block-dac960-print-a-hex-number-after-a-0x-prefix.patch
ipack-print-a-hex-number-after-a-0x-prefix.patch
misc-sgi-gru-print-a-hex-number-after-a-0x-prefix.patch
cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch

