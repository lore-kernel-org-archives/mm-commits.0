From: akpm@osdl.org
Subject: - md-change-lifetime-rules-for-md-devices.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:44:38 -0800
Message-ID: <200612140044.kBE0idQ9026658@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34224 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbWLNAor (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:44:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     md: change lifetime rules for 'md' devices.
has been removed from the -mm tree.  Its filename was
     md-change-lifetime-rules-for-md-devices.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: md: change lifetime rules for 'md' devices.
From: Neil Brown <neilb@suse.de>

Currently md devices are created when first opened and remain in existence
until the module is unloaded.  This isn't a major problem, but it somewhat
ugly.

This patch changes the lifetime rules so that an md device will disappear
on the last close if it has no state.

Locking rules depend on bd_mutex being held in do_open and __blkdev_put,
and on setting bd_disk->private_data to 'mddev'.

There is room for a race because md_probe is called early in do_open
(get_gendisk) to create the mddev.  As this isn't protected by bd_mutex, a
concurrent call to md_close can destroy that mddev before do_open calls
md_open to get a reference on it.

md_open and md_close are serialised by md_mutex so the worst that can
happen is that md_open finds that the mddev structure doesn't exist after
all.  In this case bd_disk->private_data will be NULL, and md_open chooses
to exit with -EBUSY in this case, which is arguable and appropriate result.

The new 'dead' field in mddev is used to track whether it is time to
destroy the mddev (if a last-close happens).  It is cleared when any state
is create (set_array_info) and set when the array is stopped (do_md_stop).

mddev_put becomes simpler.  It just destroys the mddev when the refcount
hits zero.  This will normally be the reference held in
bd_disk->private_data.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c           |   32 +++++++++++++++++++++++---------
 include/linux/raid/md_k.h |    3 +++
 2 files changed, 26 insertions(+), 9 deletions(-)

diff -puN drivers/md/md.c~md-change-lifetime-rules-for-md-devices drivers/md/md.c
--- a/drivers/md/md.c~md-change-lifetime-rules-for-md-devices
+++ a/drivers/md/md.c
@@ -226,13 +226,14 @@ static void mddev_put(mddev_t *mddev)
 {
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
-	if (!mddev->raid_disks && list_empty(&mddev->disks)) {
-		list_del(&mddev->all_mddevs);
-		spin_unlock(&all_mddevs_lock);
-		blk_cleanup_queue(mddev->queue);
-		kobject_unregister(&mddev->kobj);
-	} else
-		spin_unlock(&all_mddevs_lock);
+	list_del(&mddev->all_mddevs);
+	spin_unlock(&all_mddevs_lock);
+
+	del_gendisk(mddev->gendisk);
+	mddev->gendisk = NULL;
+	blk_cleanup_queue(mddev->queue);
+	mddev->queue = NULL;
+	kobject_unregister(&mddev->kobj);
 }
 
 static mddev_t * mddev_find(dev_t unit)
@@ -273,6 +274,7 @@ static mddev_t * mddev_find(dev_t unit)
 	atomic_set(&new->active, 1);
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
+	new->dead = 1;
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
@@ -1384,6 +1386,7 @@ static int bind_rdev_to_array(mdk_rdev_t
 		ko = &rdev->bdev->bd_disk->kobj;
 	sysfs_create_link(&rdev->kobj, ko, "block");
 	bd_claim_by_disk(rdev->bdev, rdev, mddev->gendisk);
+	mddev->dead = 0;
 	return 0;
 }
 
@@ -3360,6 +3363,8 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->array_size = 0;
 		mddev->size = 0;
 		mddev->raid_disks = 0;
+		mddev->dead = 1;
+
 		mddev->recovery_cp = 0;
 
 	} else if (mddev->pers)
@@ -4023,6 +4028,7 @@ static int set_array_info(mddev_t * mdde
 	mddev->new_layout = mddev->layout;
 	mddev->delta_disks = 0;
 
+	mddev->dead = 0;
 	return 0;
 }
 
@@ -4423,8 +4429,12 @@ static int md_open(struct inode *inode, 
 	 * Succeed if we can lock the mddev, which confirms that
 	 * it isn't being stopped right now.
 	 */
-	mddev_t *mddev = inode->i_bdev->bd_disk->private_data;
-	int err;
+	mddev_t *mddev;
+	int err = -EBUSY;
+
+	mddev = inode->i_bdev->bd_disk->private_data;
+	if (!mddev)
+		goto out;
 
 	if ((err = mutex_lock_interruptible_nested(&mddev->reconfig_mutex, 1)))
 		goto out;
@@ -4443,6 +4453,10 @@ static int md_release(struct inode *inod
  	mddev_t *mddev = inode->i_bdev->bd_disk->private_data;
 
 	BUG_ON(!mddev);
+	if (inode->i_bdev->bd_openers == 0 && mddev->dead) {
+		inode->i_bdev->bd_disk->private_data = NULL;
+		mddev_put(mddev);
+	}
 	mddev_put(mddev);
 
 	return 0;
diff -puN include/linux/raid/md_k.h~md-change-lifetime-rules-for-md-devices include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-change-lifetime-rules-for-md-devices
+++ a/include/linux/raid/md_k.h
@@ -119,6 +119,9 @@ struct mddev_s
 #define MD_CHANGE_PENDING 2	/* superblock update in progress */
 
 	int				ro;
+	int				dead; /* array should be discarded on
+					       * last close
+					       */
 
 	struct gendisk			*gendisk;
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch
knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch
knfsd-nfsd4-clarify-units-of-compound_slack_space.patch
knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch
knfsd-nfsd-simplify-exp_pseudoroot.patch
knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch
knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch
knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch
knfsd-nfsd4-pass-saved-and-current-fh-together-into-nfsd4-operations.patch
knfsd-nfsd4-remove-spurious-replay_owner-check.patch
knfsd-nfsd4-move-replay_owner-to-cstate.patch
knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch
knfsd-nfsd4-make-verify-and-nverify-wrappers.patch
knfsd-nfsd4-reorganize-compound-ops.patch
knfsd-nfsd4-simplify-migration-op-check.patch
knfsd-nfsd4-simplify-filehandle-check.patch
knfsd-dont-ignore-kstrdup-failure-in-rpc-caches.patch
knfsd-fix-up-some-bit-rot-in-exp_export.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch
knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-add-a-generic-function-to-see-if-the-peer-uses-a-secure-port.patch
knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-change-lifetime-rules-for-md-devices.patch
md-close-a-race-between-destroying-and-recreating-an-md-device.patch
md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

