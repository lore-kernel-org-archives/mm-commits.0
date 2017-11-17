From: akpm@linux-foundation.org
Subject: [folded-merged] rapidio-tsi568-constify-rio_device_id.patch
 removed from -mm tree
Date: Fri, 17 Nov 2017 14:27:33 -0800
Message-ID: <5a0f6255.cKZzgh5+ylewgvcH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936888AbdKQW1e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 17:27:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: tsi568: constify rio_device_id
has been removed from the -mm tree.  Its filename was
     rapidio-tsi568-constify-rio_device_id.patch

This patch was dropped because it was folded into rapidio-idt_gen2-constify-rio_device_id.patch

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: rapidio: tsi568: constify rio_device_id

rio_device_id are not supposed to change at runtime.  rio driver is
working with const 'id_table'.  So mark the non-const rio_device_id
structs as const.

Link: http://lkml.kernel.org/r/1503734627-6058-5-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/tsi568.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/switches/tsi568.c~rapidio-tsi568-constify-rio_device_id drivers/rapidio/switches/tsi568.c
--- a/drivers/rapidio/switches/tsi568.c~rapidio-tsi568-constify-rio_device_id
+++ a/drivers/rapidio/switches/tsi568.c
@@ -169,7 +169,7 @@ static void tsi568_remove(struct rio_dev
 	spin_unlock(&rdev->rswitch->lock);
 }
 
-static struct rio_device_id tsi568_id_table[] = {
+static const struct rio_device_id tsi568_id_table[] = {
 	{RIO_DEVICE(RIO_DID_TSI568, RIO_VID_TUNDRA)},
 	{ 0, }	/* terminate list */
 };
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are

rapidio-idt_gen2-constify-rio_device_id.patch
rapidio-tsi57x-constify-rio_device_id.patch

