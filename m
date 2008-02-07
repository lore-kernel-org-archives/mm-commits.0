From: akpm@linux-foundation.org
Subject: - md-fix-an-occasional-deadlock-in-raid5.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:12 -0800
Message-ID: <200802070029.m170Tr9o007327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935065AbYBGAoq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, dan.j.williams@gmail.com, dean@arctic.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     md: fix an occasional deadlock in raid5
has been removed from the -mm tree.  Its filename was
     md-fix-an-occasional-deadlock-in-raid5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix an occasional deadlock in raid5
From: NeilBrown <neilb@suse.de>

raid5's 'make_request' function calls generic_make_request on underlying
devices and if we run out of stripe heads, it could end up waiting for one of
those requests to complete.  This is bad as recursive calls to
generic_make_request go on a queue and are not even attempted until
make_request completes.

So: don't make any generic_make_request calls in raid5 make_request until all
waiting has been done.  We do this by simply setting STRIPE_HANDLE instead of
calling handle_stripe().

If we need more stripe_heads, raid5d will get called to process the pending
stripe_heads which will call generic_make_request from a

This change by itself causes a performance hit.  So add a change so that
raid5_activate_delayed is only called at unplug time, never in raid5.  This
seems to bring back the performance numbers.  Calling it in raid5d was
sometimes too soon...

Neil said:

  How about we queue it for 2.6.25-rc1 and then about when -rc2 comes out,
  we queue it for 2.6.24.y?

Cc: "Dan Williams" <dan.j.williams@gmail.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Tested-by: dean gaudet <dean@arctic.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/md/raid5.c~md-fix-an-occasional-deadlock-in-raid5 drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-an-occasional-deadlock-in-raid5
+++ a/drivers/md/raid5.c
@@ -3159,7 +3159,8 @@ static void raid5_activate_delayed(raid5
 				atomic_inc(&conf->preread_active_stripes);
 			list_add_tail(&sh->lru, &conf->handle_list);
 		}
-	}
+	} else
+		blk_plug_device(conf->mddev->queue);
 }
 
 static void activate_bit_delay(raid5_conf_t *conf)
@@ -3549,7 +3550,8 @@ static int make_request(struct request_q
 				goto retry;
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
-			handle_stripe(sh, NULL);
+			set_bit(STRIPE_HANDLE, &sh->state);
+			clear_bit(STRIPE_DELAYED, &sh->state);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
@@ -3892,7 +3894,7 @@ static int  retry_aligned_read(raid5_con
  * During the scan, completed stripes are saved for us by the interrupt
  * handler, so that they will not have to wait for our next wakeup.
  */
-static void raid5d (mddev_t *mddev)
+static void raid5d(mddev_t *mddev)
 {
 	struct stripe_head *sh;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
@@ -3917,12 +3919,6 @@ static void raid5d (mddev_t *mddev)
 			activate_bit_delay(conf);
 		}
 
-		if (list_empty(&conf->handle_list) &&
-		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
-		    !blk_queue_plugged(mddev->queue) &&
-		    !list_empty(&conf->delayed_list))
-			raid5_activate_delayed(conf);
-
 		while ((bio = remove_bio_from_retry(conf))) {
 			int ok;
 			spin_unlock_irq(&conf->device_lock);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
d_path-make-d_path-use-a-struct-path-fix.patch
