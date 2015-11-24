From: akpm@linux-foundation.org
Subject: + memstick-use-sector_div-instead-of-do_div.patch added to -mm
 tree
Date: Tue, 24 Nov 2015 14:05:10 -0800
Message-ID: <5654df16.2azxCGo6lDfk3vMy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbbKXWFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 17:05:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memstick: use sector_div instead of do_div
has been added to the -mm tree.  Its filename is
     memstick-use-sector_div-instead-of-do_div.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memstick-use-sector_div-instead-of-do_div.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memstick-use-sector_div-instead-of-do_div.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
memstick-use-sector_div-instead-of-do_div.patch

