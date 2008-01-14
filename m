From: akpm@linux-foundation.org
Subject: + md-fix-an-occasional-deadlock-in-raid5.patch added to -mm tree
Date: Sun, 13 Jan 2008 17:59:27 -0800
Message-ID: <200801140159.m0E1x7OD006866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44924 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753385AbYANB7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 20:59:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, dan.j.williams@gmail.com


The patch titled
     md: fix an occasional deadlock in raid5
has been added to the -mm tree.  Its filename is
     md-fix-an-occasional-deadlock-in-raid5.patch

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

Cc: "Dan Williams" <dan.j.williams@gmail.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

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
@@ -3549,7 +3550,7 @@ static int make_request(struct request_q
 				goto retry;
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
-			handle_stripe(sh, NULL);
+			set_bit(STRIPE_HANDLE, &sh->state);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
@@ -3892,7 +3893,7 @@ static int  retry_aligned_read(raid5_con
  * During the scan, completed stripes are saved for us by the interrupt
  * handler, so that they will not have to wait for our next wakeup.
  */
-static void raid5d (mddev_t *mddev)
+static void raid5d(mddev_t *mddev)
 {
 	struct stripe_head *sh;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
@@ -3917,12 +3918,6 @@ static void raid5d (mddev_t *mddev)
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
git-nfsd.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
md-raid6-fix-mktablec.patch
md-raid6-clean-up-the-style-of-raid6test-testc.patch
md-update-md-bitmap-during-resync.patch
md-update-md-bitmap-during-resync-fix.patch
md-support-external-metadata-for-md-arrays.patch
md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use.patch
md-allow-a-maximum-extent-to-be-set-for-resyncing.patch
md-allow-devices-to-be-shared-between-md-arrays.patch
md-lock-address-when-changing-attributes-of-component-devices.patch
md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch
md-fix-an-occasional-deadlock-in-raid5.patch
md-fix-use-after-free-bug-when-dropping-an-rdev-from-an-md-array.patch
md-change-a-few-int-to-size_t-in-md.patch
md-change-interate_mddev-to-for_each_mddev.patch
md-change-iterate_rdev-to-rdev_for_each.patch
md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch
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
