From: akpm@linux-foundation.org
Subject: + mtdpart-fix-a-division-by-zero-bug.patch added to -mm tree
Date: Fri, 18 Jul 2008 14:42:30 -0700
Message-ID: <200807182142.m6ILgUJC032330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756343AbYGRVmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 17:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, joern@logfs.org


The patch titled
     mtdpart: fix a division by zero bug
has been added to the -mm tree.  Its filename is
     mtdpart-fix-a-division-by-zero-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtdpart: fix a division by zero bug
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

When detecting a partition beyond the end of the device, skip most of the
initialisation, in particular those bits causing a division by zero.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdpart.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/mtdpart.c~mtdpart-fix-a-division-by-zero-bug drivers/mtd/mtdpart.c
--- a/drivers/mtd/mtdpart.c~mtdpart-fix-a-division-by-zero-bug
+++ a/drivers/mtd/mtdpart.c
@@ -411,11 +411,12 @@ static struct mtd_part *add_one_partitio
 
 	/* let's do some sanity checks */
 	if (slave->offset >= master->size) {
-			/* let's register it anyway to preserve ordering */
+		/* let's register it anyway to preserve ordering */
 		slave->offset = 0;
 		slave->mtd.size = 0;
 		printk(KERN_ERR"mtd: partition \"%s\" is out of reach -- disabled\n",
 			part->name);
+		goto out_register;
 	}
 	if (slave->offset + slave->mtd.size > master->size) {
 		slave->mtd.size = master->size - slave->offset;
@@ -475,6 +476,7 @@ static struct mtd_part *add_one_partitio
 		}
 	}
 
+out_register:
 	if (part->mtdp) {
 		/* store the object pointer (caller may or may not register it*/
 		*part->mtdp = &slave->mtd;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
fix-build-on-compat-platforms-when-config_epoll-is-disabled.patch
linux-next.patch
mtd-jedec_probe-fix-sst-16-bit-chip-detection.patch
mtdpart-separate-main-loop-from-per-partition-code-in-add_mtd_partition.patch
mtdpart-handle-most-checkpatch-findings.patch
mtdpart-cleanup-and-document-the-erase-region-handling.patch
mtdpart-fix-a-division-by-zero-bug.patch
mtdpart-handle-remaining-checkpatch-findings.patch

