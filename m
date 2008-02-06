From: akpm@linux-foundation.org
Subject: - md-fix-an-occasional-deadlock-in-raid5-fix.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:34:06 -0800
Message-ID: <200802060733.m167XmFu031965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759296AbYBFHeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:34:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix an occasional deadlock in raid5 - FIX
has been removed from the -mm tree.  Its filename was
     md-fix-an-occasional-deadlock-in-raid5-fix.patch

This patch was dropped because it was folded into md-fix-an-occasional-deadlock-in-raid5.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix an occasional deadlock in raid5 - FIX
From: NeilBrown <neilb@suse.de>

(This should be merged with fix-occasional-deadlock-in-raid5.patch)

As we don't call stripe_handle in make_request any more, we need to
clear STRIPE_DELAYED to (previously done by stripe_handle) to ensure
that we test if the stripe still needs to be delayed or not.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/md/raid5.c~md-fix-an-occasional-deadlock-in-raid5-fix drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-an-occasional-deadlock-in-raid5-fix
+++ a/drivers/md/raid5.c
@@ -3551,6 +3551,7 @@ static int make_request(struct request_q
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
+			clear_bit(STRIPE_DELAYED, &sh->state);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
md-raid6-fix-mktablec.patch
md-raid6-clean-up-the-style-of-raid6test-testc.patch
md-update-md-bitmap-during-resync.patch
md-support-external-metadata-for-md-arrays.patch
md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use.patch
md-allow-a-maximum-extent-to-be-set-for-resyncing.patch
md-set-and-test-the-persistent-flag-for-md-devices-more-consistently.patch
md-allow-devices-to-be-shared-between-md-arrays.patch
md-lock-address-when-changing-attributes-of-component-devices.patch
md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch
md-fix-use-after-free-bug-when-dropping-an-rdev-from-an-md-array.patch
md-change-a-few-int-to-size_t-in-md.patch
md-change-interate_mddev-to-for_each_mddev.patch
md-change-iterate_rdev-to-rdev_for_each.patch
md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch
md-fix-an-occasional-deadlock-in-raid5.patch
md-fix-an-occasional-deadlock-in-raid5-fix.patch
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
