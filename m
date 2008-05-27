From: akpm@linux-foundation.org
Subject: - md-fix-possible-oops-when-removing-a-bitmap-from-an-active-array.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:06 -0700
Message-ID: <200805270727.m4R7R6kD014733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755858AbYE0H1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix possible oops when removing a bitmap from an active array
has been removed from the -mm tree.  Its filename was
     md-fix-possible-oops-when-removing-a-bitmap-from-an-active-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

md-fix-prexor-vs-sync_request-race.patch
md-fix-uninitialized-use-of-mddev-recovery_wait.patch
md-do-not-compute-parity-unless-it-is-on-a-failed-drive.patch
linux-next.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch

