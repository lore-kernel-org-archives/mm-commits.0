From: akpm@linux-foundation.org
Subject: [merged]
 drivers-memstick-core-ms_blockc-fix-unreachable-state-in-h_msb_read_page.patch removed from -mm tree
Date: Thu, 14 Nov 2013 16:57:14 -0800
Message-ID: <5285716a.xttn47jhwjKveeZy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3KOAzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Nov 2013 19:55:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, maximlevitsky@gmail.com, rogerable@realtek.com

Subject: [merged] drivers-memstick-core-ms_blockc-fix-unreachable-state-in-h_msb_read_page.patch removed from -mm tree
To: rogerable@realtek.com,maximlevitsky@gmail.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 14 Nov 2013 16:57:13 -0800


The patch titled
     Subject: drivers/memstick/core/ms_block.c: fix unreachable state in h_msb_read_page()
has been removed from the -mm tree.  Its filename was
     drivers-memstick-core-ms_blockc-fix-unreachable-state-in-h_msb_read_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roger Tseng <rogerable@realtek.com>
Subject: drivers/memstick/core/ms_block.c: fix unreachable state in h_msb_read_page()

In h_msb_read_page() in ms_block.c, flow never reaches case
MSB_RP_RECIVE_STATUS_REG.  This causes error when MEMSTICK_INT_ERR is
encountered and status error bits are going to be examined, but the status
will never be copied back.

Fix it by transitioning to MSB_RP_RECIVE_STATUS_REG right after
MSB_RP_SEND_READ_STATUS_REG.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
Acked-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/ms_block.c~drivers-memstick-core-ms_blockc-fix-unreachable-state-in-h_msb_read_page drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~drivers-memstick-core-ms_blockc-fix-unreachable-state-in-h_msb_read_page
+++ a/drivers/memstick/core/ms_block.c
@@ -401,7 +401,7 @@ again:
 			sizeof(struct ms_status_register)))
 			return 0;
 
-		msb->state = MSB_RP_RECEIVE_OOB_READ;
+		msb->state = MSB_RP_RECIVE_STATUS_REG;
 		return 0;
 
 	case MSB_RP_RECIVE_STATUS_REG:
_

Patches currently in -mm which might be from rogerable@realtek.com are

origin.patch

