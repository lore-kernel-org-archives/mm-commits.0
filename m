From: akpm@linux-foundation.org
Subject: [folded-merged] rapidio-idtcps-constify-rio_device_id.patch
 removed from -mm tree
Date: Fri, 17 Nov 2017 14:27:30 -0800
Message-ID: <5a0f6252.kMPjkWjblWGdNyUc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936888AbdKQW1b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 17:27:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: idtcps: constify rio_device_id
has been removed from the -mm tree.  Its filename was
     rapidio-idtcps-constify-rio_device_id.patch

This patch was dropped because it was folded into rapidio-idt_gen2-constify-rio_device_id.patch

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: rapidio: idtcps: constify rio_device_id

rio_device_id are not supposed to change at runtime.  rio driver is
working with const 'id_table'.  So mark the non-const rio_device_id
structs as const.

Link: http://lkml.kernel.org/r/1503734627-6058-4-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idtcps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/switches/idtcps.c~rapidio-idtcps-constify-rio_device_id drivers/rapidio/switches/idtcps.c
--- a/drivers/rapidio/switches/idtcps.c~rapidio-idtcps-constify-rio_device_id
+++ a/drivers/rapidio/switches/idtcps.c
@@ -168,7 +168,7 @@ static void idtcps_remove(struct rio_dev
 	spin_unlock(&rdev->rswitch->lock);
 }
 
-static struct rio_device_id idtcps_id_table[] = {
+static const struct rio_device_id idtcps_id_table[] = {
 	{RIO_DEVICE(RIO_DID_IDTCPS6Q, RIO_VID_IDT)},
 	{RIO_DEVICE(RIO_DID_IDTCPS8, RIO_VID_IDT)},
 	{RIO_DEVICE(RIO_DID_IDTCPS10Q, RIO_VID_IDT)},
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are

rapidio-idt_gen2-constify-rio_device_id.patch
rapidio-tsi568-constify-rio_device_id.patch
rapidio-tsi57x-constify-rio_device_id.patch

