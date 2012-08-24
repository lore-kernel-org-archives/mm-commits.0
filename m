From: akpm@linux-foundation.org
Subject: + rapidio-apply-rx-tx-enable-to-active-switch-ports-only.patch added to -mm tree
Date: Fri, 24 Aug 2012 14:05:14 -0700
Message-ID: <20120824210515.3083F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:48525 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030424Ab2HXVFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 17:05:16 -0400
Received: by yenq13 with SMTP id q13so330764yen.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 14:05:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio: apply RX/TX enable to active switch ports only
has been added to the -mm tree.  Its filename is
     rapidio-apply-rx-tx-enable-to-active-switch-ports-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: apply RX/TX enable to active switch ports only

Modify RIO enumeration to apply RX/TX enable operations only to active
switch ports.  This will leave inactive ports in condition consistent with
their state.

This patch is applicable to kernel versions starting from v2.6.35.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-apply-rx-tx-enable-to-active-switch-ports-only drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-apply-rx-tx-enable-to-active-switch-ports-only
+++ a/drivers/rapidio/rio-scan.c
@@ -839,12 +839,10 @@ static int __devinit rio_enum_peer(struc
 		for (port_num = 0;
 		     port_num < RIO_GET_TOTAL_PORTS(rdev->swpinfo);
 		     port_num++) {
-			/*Enable Input Output Port (transmitter reviever)*/
-			rio_enable_rx_tx_port(port, 0,
+			if (sw_inport == port_num) {
+				rio_enable_rx_tx_port(port, 0,
 					      RIO_ANY_DESTID(port->sys_size),
 					      hopcount, port_num);
