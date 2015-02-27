From: akpm@linux-foundation.org
Subject: + memstick-mspro_block-add-missing-curly-braces.patch added to
 -mm tree
Date: Fri, 27 Feb 2015 13:51:07 -0800
Message-ID: <54f0e6cb.ZIsOtkQkOG3h01SX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbbB0VvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 16:51:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memstick: mspro_block: add missing curly braces
has been added to the -mm tree.  Its filename is
     memstick-mspro_block-add-missing-curly-braces.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memstick-mspro_block-add-missing-curly-braces.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memstick-mspro_block-add-missing-curly-braces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: memstick: mspro_block: add missing curly braces

Using the indenting we can see the curly braces were obviously intended. 
This is a static checker fix, but my guess is that we don't read enough
bytes, because we don't calculate "t_len" correctly.

Fixes: f1d82698029b ('memstick: use fully asynchronous request processing')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-mspro_block-add-missing-curly-braces drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-mspro_block-add-missing-curly-braces
+++ a/drivers/memstick/core/mspro_block.c
@@ -758,7 +758,7 @@ static int mspro_block_complete_req(stru
 
 		if (error || (card->current_mrq.tpc == MSPRO_CMD_STOP)) {
 			if (msb->data_dir == READ) {
-				for (cnt = 0; cnt < msb->current_seg; cnt++)
+				for (cnt = 0; cnt < msb->current_seg; cnt++) {
 					t_len += msb->req_sg[cnt].length
 						 / msb->page_size;
 
@@ -766,6 +766,7 @@ static int mspro_block_complete_req(stru
 						t_len += msb->current_page - 1;
 
 					t_len *= msb->page_size;
+				}
 			}
 		} else
 			t_len = blk_rq_bytes(msb->block_req);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

rtc-ds1685-fix-conditional-in-ds1685_rtc_sysfs_time_regs_showstore.patch
memstick-mspro_block-add-missing-curly-braces.patch
linux-next.patch

