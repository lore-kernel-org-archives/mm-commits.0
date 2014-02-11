From: akpm@linux-foundation.org
Subject: [merged]
 gru-unlocking-should-be-conditional-in-gru_dump_context.patch removed from
 -mm tree
Date: Tue, 11 Feb 2014 11:23:15 -0800
Message-ID: <52fa78a3.PHZ67/1qgBySeGJ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbaBKTXQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sivanich@sgi.com, dan.carpenter@oracle.com

Subject: [merged] gru-unlocking-should-be-conditional-in-gru_dump_context.patch removed from -mm tree
To: dan.carpenter@oracle.com,sivanich@sgi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:15 -0800


The patch titled
     Subject: drivers/misc/sgi-gru/grukdump.c: unlocking should be conditional in gru_dump_context()
has been removed from the -mm tree.  Its filename was
     gru-unlocking-should-be-conditional-in-gru_dump_context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/misc/sgi-gru/grukdump.c: unlocking should be conditional in gru_dump_context()

I was reviewing this and noticed that unlocking should be conditional on
the error path.  I've changed it to unlock and return directly since we
only do it once and it seems unlikely to change in the near future.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukdump.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/misc/sgi-gru/grukdump.c~gru-unlocking-should-be-conditional-in-gru_dump_context drivers/misc/sgi-gru/grukdump.c
--- a/drivers/misc/sgi-gru/grukdump.c~gru-unlocking-should-be-conditional-in-gru_dump_context
+++ a/drivers/misc/sgi-gru/grukdump.c
@@ -139,8 +139,11 @@ static int gru_dump_context(struct gru_s
 
 	ubuf += sizeof(hdr);
 	ubufcch = ubuf;
-	if (gru_user_copy_handle(&ubuf, cch))
-		goto fail;
+	if (gru_user_copy_handle(&ubuf, cch)) {
+		if (cch_locked)
+			unlock_cch_handle(cch);
+		return -EFAULT;
+	}
 	if (cch_locked)
 		ubufcch->delresp = 0;
 	bytes = sizeof(hdr) + GRU_CACHE_LINE_BYTES;
@@ -179,10 +182,6 @@ static int gru_dump_context(struct gru_s
 		ret = -EFAULT;
 
 	return ret ? ret : bytes;
