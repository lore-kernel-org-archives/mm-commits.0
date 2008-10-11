From: akpm@linux-foundation.org
Subject: + drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and.patch added to -mm tree
Date: Fri, 10 Oct 2008 19:50:36 -0700
Message-ID: <200810110250.m9B2oah8002699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbYJKCwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 22:52:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, ben-linux@fluff.org, khali@linux-fr.org


The patch titled
     drivers/i2c/busses/i2c-s3c2410.c: Correct use of ! and &
has been added to the -mm tree.  Its filename is
     drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/i2c/busses/i2c-s3c2410.c: Correct use of ! and &
From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.  In particular,
the result of !readl(i2c->regs + S3C2410_IICCON) & S3C2410_IICCON_IRQEN is
always 0.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E; constant C; @@
(
  !E & !C
|
- !E & C
+ !(E & C)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-s3c2410.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-s3c2410.c~drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and drivers/i2c/busses/i2c-s3c2410.c
--- a/drivers/i2c/busses/i2c-s3c2410.c~drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and
+++ a/drivers/i2c/busses/i2c-s3c2410.c
@@ -507,7 +507,7 @@ static int s3c24xx_i2c_doxfer(struct s3c
 	unsigned long timeout;
 	int ret;
 
-	if (!readl(i2c->regs + S3C2410_IICCON) & S3C2410_IICCON_IRQEN)
+	if (!(readl(i2c->regs + S3C2410_IICCON) & S3C2410_IICCON_IRQEN))
 		return -EIO;
 
 	ret = s3c24xx_i2c_set_master(i2c);
_

Patches currently in -mm which might be from julia@diku.dk are

git-s390.patch
git-v4l-dvb.patch
git-infiniband.patch
git-ieee1394.patch
git-ubi.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-sound.patch
git-cpufreq.patch
git-gfs2.patch
git-ubifs.patch
git-block.patch
drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
fs-namespacec-drop-code-after-return.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

