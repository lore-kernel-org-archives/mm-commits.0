From: akpm@linux-foundation.org
Subject: + dm-use-memweight.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:17:41 -0700
Message-ID: <20120611231741.D4482A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:51242 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2FKXRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 19:17:43 -0400
Received: by yhgm50 with SMTP id m50so533716yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:17:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, agk@redhat.com


The patch titled
     Subject: dm: use memweight()
has been added to the -mm tree.  Its filename is
     dm-use-memweight.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 static void fail_log_device(struct log_c *lc)
 {
 	if (lc->log_dev_failed)
@@ -629,7 +619,8 @@ static int disk_resume(struct dm_dirty_l
 
 	/* copy clean across to sync */
 	memcpy(lc->sync_bits, lc->clean_bits, size);
-	lc->sync_count = count_bits32(lc->clean_bits, lc->bitset_uint32_count);
+	lc->sync_count = memweight(lc->clean_bits,
+				lc->bitset_uint32_count * sizeof(uint32_t));
 	lc->sync_search = 0;
 
 	/* set the correct number of regions in the header */
_
Subject: Subject: dm: use memweight()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
string-introduce-memweight.patch
string-introduce-memweight-fix.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch

