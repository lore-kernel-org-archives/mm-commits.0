From: akpm@linux-foundation.org
Subject: [merged] dm-use-memweight.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:59 -0700
Message-ID: <20120731185059.B1C171E005B@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab2GaSvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:00 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dm: use memweight()
has been removed from the -mm tree.  Its filename was
     dm-use-memweight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: dm: use memweight()

Use memweight() to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/md/dm-log.c~dm-use-memweight drivers/md/dm-log.c
--- a/drivers/md/dm-log.c~dm-use-memweight
+++ a/drivers/md/dm-log.c
@@ -571,16 +571,6 @@ static void disk_dtr(struct dm_dirty_log
 	destroy_log_context(lc);
 }
 
-static int count_bits32(uint32_t *addr, unsigned size)
-{
-	int count = 0, i;
-
-	for (i = 0; i < size; i++) {
-		count += hweight32(*(addr+i));
-	}
-	return count;
-}
