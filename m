From: akpm@linux-foundation.org
Subject: [merged] memstick-use-sector_div-instead-of-do_div.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:29:22 -0800
Message-ID: <56a169d2.V4in5crQc1zLwUIw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbcAUX3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memstick: use sector_div instead of do_div
has been removed from the -mm tree.  Its filename was
     memstick-use-sector_div-instead-of-do_div.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: memstick: use sector_div instead of do_div

do_div is the wrong way to divide a sector_t, as it is less efficient when
sector_t is 32-bit wide.  With the upcoming do_div optimizations, the
kernel starts warning about this:

drivers/memstick/core/ms_block.c: In function 'msb_io_work':
include/asm-generic/div64.h:207:28: warning: comparison of distinct pointer types lacks a cast

This changes the code to use sector_div instead, which always produces
optimal code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/ms_block.c~memstick-use-sector_div-instead-of-do_div drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~memstick-use-sector_div-instead-of-do_div
+++ a/drivers/memstick/core/ms_block.c
@@ -1909,7 +1909,7 @@ static void msb_io_work(struct work_stru
 		lba = blk_rq_pos(msb->req);
 
 		sector_div(lba, msb->page_size / 512);
-		page = do_div(lba, msb->pages_in_block);
+		page = sector_div(lba, msb->pages_in_block);
 
 		if (rq_data_dir(msb->req) == READ)
 			error = msb_do_read_request(msb, lba, page, sg,
_

Patches currently in -mm which might be from arnd@arndb.de are


