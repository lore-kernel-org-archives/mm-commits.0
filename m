From: akpm@linux-foundation.org
Subject: + drivers-block-brdc-make-rd_size-static.patch added to -mm tree
Date: Mon, 12 Aug 2013 15:54:52 -0700
Message-ID: <520967bc.IvqERGwvR+9j7Cxp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3HLWy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Aug 2013 18:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + drivers-block-brdc-make-rd_size-static.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 12 Aug 2013 15:54:52 -0700


The patch titled
     Subject: drivers/block/brd.c: make 'rd_size' static
has been added to the -mm tree.  Its filename is
     drivers-block-brdc-make-rd_size-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-block-brdc-make-rd_size-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-block-brdc-make-rd_size-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/block/brd.c: make 'rd_size' static

'rd_size' is used only in this file.  Fix the following sparse warning:

drivers/block/brd.c:432:5: warning: symbol 'rd_size' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/brd.c~drivers-block-brdc-make-rd_size-static drivers/block/brd.c
--- a/drivers/block/brd.c~drivers-block-brdc-make-rd_size-static
+++ a/drivers/block/brd.c
@@ -429,7 +429,7 @@ static const struct block_device_operati
  * And now the modules code and kernel interface.
  */
 static int rd_nr;
-int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 static int max_part;
 static int part_shift;
 module_param(rd_nr, int, S_IRUGO);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
block-replace-strict_strtoul-with-kstrtoul.patch
block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch
drivers-block-mg_diskc-make-mg_times_out-static.patch
drivers-block-brdc-make-rd_size-static.patch
mm-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
kernel-replace-strict_strto-with-kstrto.patch
documentation-replace-strict_strtoul-with-kstrtoul.patch
w1-replace-strict_strtol-with-kstrtol.patch

