From: akpm@linux-foundation.org
Subject: - crash-on-shutdown-unmount.patch removed from -mm tree
Date: Mon, 05 Nov 2007 14:07:44 -0800
Message-ID: <200711052207.lA5M7iiI022036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbXKEWIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 17:08:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     crash on shutdown/unmount
has been removed from the -mm tree.  Its filename was
     crash-on-shutdown-unmount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: crash on shutdown/unmount
From: Jens Axboe <jens.axboe@oracle.com>

On Wed, Oct 31 2007, Alistair John Strachan wrote:
> Hi Jens,
>
> I guessed from the oops that you might have an idea what's causing this oops
> on shutdown/unmount. The git version (describe), a screenshot showing the
> oops, a config, and dmesg for a booted kernel are available from:
>
> http://devzero.co.uk/~alistair/oops-20071031/
>
> I went back to -rc1 and it still happens there too. If you need any more
> information or want me to bisect it, please let me know.

Does this work for you?

index 54fd385..75c98d5 100644

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN block/ll_rw_blk.c~crash-on-shutdown-unmount block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~crash-on-shutdown-unmount
+++ a/block/ll_rw_blk.c
@@ -3221,6 +3221,7 @@ static inline void __generic_make_reques
 	sector_t old_sector;
 	int ret, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
+	int err = -EIO;
 
 	might_sleep();
 
@@ -3248,7 +3249,7 @@ static inline void __generic_make_reques
 				bdevname(bio->bi_bdev, b),
 				(long long) bio->bi_sector);
 end_io:
-			bio_endio(bio, -EIO);
+			bio_endio(bio, err);
 			break;
 		}
 
@@ -3283,6 +3284,10 @@ end_io:
 
 		if (bio_check_eod(bio, nr_sectors))
 			goto end_io;
+		if (bio_empty_barrier(bio) && !q->prepare_flush_fn) {
+			err = -EOPNOTSUPP;
+			goto end_io;
+		}
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
_

Patches currently in -mm which might be from jens.axboe@oracle.com are

origin.patch
uml-fix-incompatible-types-warning-in-previous-sg-fix.patch
scsi-early-detection-of-medium-not-present-updated.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
revoke-vs-git-block.patch
reiser4.patch
