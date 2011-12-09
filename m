From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-fix-mailbox-resource-reporting.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:48 -0800
Message-ID: <201112092008.pB9K8mu2021103@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53004 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1LIUIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:51 -0500
Received: by eaad1 with SMTP id d1so18853eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:08:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix mailbox resource reporting
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-fix-mailbox-resource-reporting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: fix mailbox resource reporting

Bug fix for Tsi721 RapidIO mport driver: Tsi721 supports four RapidIO
mailboxes (MBOX0 - MBOX3) as defined by RapidIO specification.  Mailbox
resources has to be properly reported to allow use of all available
mailboxes (initial version reports only MBOX0).

This patch is applicable to kernel versions staring from 3.2-rc1.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-mailbox-resource-reporting drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-mailbox-resource-reporting
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2107,8 +2107,8 @@ static int __devinit tsi721_setup_mport(
 	INIT_LIST_HEAD(&mport->dbells);
 
 	rio_init_dbell_res(&mport->riores[RIO_DOORBELL_RESOURCE], 0, 0xffff);
-	rio_init_mbox_res(&mport->riores[RIO_INB_MBOX_RESOURCE], 0, 0);
-	rio_init_mbox_res(&mport->riores[RIO_OUTB_MBOX_RESOURCE], 0, 0);
+	rio_init_mbox_res(&mport->riores[RIO_INB_MBOX_RESOURCE], 0, 3);
+	rio_init_mbox_res(&mport->riores[RIO_OUTB_MBOX_RESOURCE], 0, 3);
 	strcpy(mport->name, "Tsi721 mport");
 
 	/* Hook up interrupt handler */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
linux-next.patch

