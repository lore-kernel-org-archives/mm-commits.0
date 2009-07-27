From: akpm@linux-foundation.org
Subject: + mg_disk-fix-reading-invalid-status-when-use-polling-driver.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:33:15 -0700
Message-ID: <200907272133.n6RLXFU0012827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755073AbZG0VfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:35:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: donari75@gmail.com, jens.axboe@oracle.com, tj@kernel.org


The patch titled
     mg_disk: fix reading invalid status when use polling driver
has been added to the -mm tree.  Its filename is
     mg_disk-fix-reading-invalid-status-when-use-polling-driver.patch

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
Subject: mg_disk: fix reading invalid status when use polling driver
From: unsik Kim <donari75@gmail.com>

When using polling driver, little delay is required to access status
register.  Without this, host might read invalid status.

Signed-off-by: unsik Kim <donari75@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mg_disk.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/block/mg_disk.c~mg_disk-fix-reading-invalid-status-when-use-polling-driver drivers/block/mg_disk.c
--- a/drivers/block/mg_disk.c~mg_disk-fix-reading-invalid-status-when-use-polling-driver
+++ a/drivers/block/mg_disk.c
@@ -219,6 +219,16 @@ static unsigned int mg_wait(struct mg_ho
 	host->error = MG_ERR_NONE;
 	expire = jiffies + msecs_to_jiffies(msec);
 
+	/* These 2 times dummy status read prevents reading invalid
+	 * status. A very little time (3 times of mflash operating clk)
+	 * is required for busy bit is set. Use dummy read instead of
+	 * busy wait, because mflash's PLL is machine dependent.
+	 */
+	if (prv_data->use_polling) {
+		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+	}
+
 	status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
 
 	do {
_

Patches currently in -mm which might be from donari75@gmail.com are

mg_disk-remove-prohibited-sleep-operation.patch
mg_disk-fix-reading-invalid-status-when-use-polling-driver.patch

