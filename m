From: akpm@linux-foundation.org
Subject: + drivers-block-paride-pgc-underflow-bug-in-pg_write.patch added
 to -mm tree
Date: Thu, 17 Oct 2013 14:14:28 -0700
Message-ID: <52605334.RWGKZXAilym/RbZs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762344Ab3JQVO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 17:14:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, dan.carpenter@oracle.com

Subject: + drivers-block-paride-pgc-underflow-bug-in-pg_write.patch added to -mm tree
To: dan.carpenter@oracle.com,axboe@kernel.dk
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 14:14:28 -0700


The patch titled
     Subject: drivers/block/paride/pg.c: underflow bug in pg_write()
has been added to the -mm tree.  Its filename is
     drivers-block-paride-pgc-underflow-bug-in-pg_write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-block-paride-pgc-underflow-bug-in-pg_write.patch

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
Subject: drivers/block/paride/pg.c: underflow bug in pg_write()

The test here can underflow so we pass bogus lengths to the hardware. 
It's a static checker fix and I don't know the impact.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/paride/pg.c~drivers-block-paride-pgc-underflow-bug-in-pg_write drivers/block/paride/pg.c
--- a/drivers/block/paride/pg.c~drivers-block-paride-pgc-underflow-bug-in-pg_write
+++ a/drivers/block/paride/pg.c
@@ -581,7 +581,7 @@ static ssize_t pg_write(struct file *fil
 
 	if (hdr.magic != PG_MAGIC)
 		return -EINVAL;
-	if (hdr.dlen > PG_MAX_DATA)
+	if (hdr.dlen < 0 || hdr.dlen > PG_MAX_DATA)
 		return -EINVAL;
 	if ((count - hs) > PG_MAX_DATA)
 		return -EINVAL;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
ocfs2-add-missing-errno-in-ocfs2_ioctl_move_extents.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch
backlight-lm3630-potential-null-deref-in-probe.patch
linux-next.patch

