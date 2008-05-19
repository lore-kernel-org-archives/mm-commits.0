From: akpm@linux-foundation.org
Subject: + md-fix-possible-oops-when-removing-a-bitmap-from-an-active-array.patch added to -mm tree
Date: Sun, 18 May 2008 18:27:25 -0700
Message-ID: <200805190127.m4J1RPP9009546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbYESB1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 May 2008 21:27:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: fix possible oops when removing a bitmap from an active array
has been added to the -mm tree.  Its filename is
     md-fix-possible-oops-when-removing-a-bitmap-from-an-active-array.patch

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
Subject: md: fix possible oops when removing a bitmap from an active array
From: NeilBrown <neilb@suse.de>

It is possible to add a write-intent bitmap to an active array, or remove
the bitmap that is there.

When we do with the 'quiesce' the array, which causes make_request to
block in "wait_barrier()".

However we are sampling the value of "mddev->bitmap" before the
wait_barrier call, and using it afterwards.  This can result in using a
bitmap structure that has been freed.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/md/raid1.c~md-fix-possible-oops-when-removing-a-bitmap-from-an-active-array drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-fix-possible-oops-when-removing-a-bitmap-from-an-active-array
+++ a/drivers/md/raid1.c
@@ -773,7 +773,7 @@ static int make_request(struct request_q
 	r1bio_t *r1_bio;
 	struct bio *read_bio;
 	int i, targets = 0, disks;
-	struct bitmap *bitmap = mddev->bitmap;
+	struct bitmap *bitmap;
 	unsigned long flags;
 	struct bio_list bl;
 	struct page **behind_pages = NULL;
@@ -802,6 +802,8 @@ static int make_request(struct request_q
 
 	wait_barrier(conf);
 
+	bitmap = mddev->bitmap;
+
 	disk_stat_inc(mddev->gendisk, ios[rw]);
 	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch
md-fix-possible-oops-when-removing-a-bitmap-from-an-active-array.patch
md-proper-extern-for-mdp_major.patch
md-kill-file_path-wrapper.patch
md-md-raid5-rate-limit-error-printk.patch
md-raid1-fix-restoration-of-bio-between-failed-read-and-write.patch
md-notify-userspace-on-write-pending-changes-to-array_state.patch
md-notify-userspace-on-stop-events.patch
md-improve-setting-of-events_cleared-for-write-intent-bitmaps.patch
md-allow-parallel-resync-of-md-devices.patch
md-restart-recovery-cleanly-after-device-failure.patch

