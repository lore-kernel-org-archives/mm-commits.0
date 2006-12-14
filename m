From: akpm@osdl.org
Subject: - md-close-a-race-between-destroying-and-recreating-an-md-device.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:44:41 -0800
Message-ID: <200612140044.kBE0ifkT026661@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34220 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbWLNAoq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:44:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: close a race between destroying and recreating an md device
has been removed from the -mm tree.  Its filename was
     md-close-a-race-between-destroying-and-recreating-an-md-device.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: md: close a race between destroying and recreating an md device
From: NeilBrown <neilb@suse.de>

For each md device, we need a gendisk.  As that gendisk has a name that gets
registered in sysfs, we need to make sure that when an md device is shut down,
we don't create it again until the shutdown is complete and the gendisk has
been deleted.

This patches utilises the disks_mutex to ensure the proper exclusion.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff -puN drivers/md/md.c~md-close-a-race-between-destroying-and-recreating-an-md-device drivers/md/md.c
--- a/drivers/md/md.c~md-close-a-race-between-destroying-and-recreating-an-md-device
+++ a/drivers/md/md.c
@@ -222,18 +222,36 @@ static inline mddev_t *mddev_get(mddev_t
 	return mddev;
 }
 
+static DEFINE_MUTEX(disks_mutex);
 static void mddev_put(mddev_t *mddev)
 {
+	/* We need to hold disks_mutex to safely destroy the gendisk
+	 * info before someone else creates a new gendisk with the same
+	 * name, but we don't want to take that mutex just to decrement
+	 * the ->active counter.  So we first test if this is the last
+	 * reference.  If it is, we put things back as they were found
+	 * and take disks_mutex before trying again.
+	 */
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
+	atomic_inc(&mddev->active);
+	spin_unlock(&all_mddevs_lock);
+
+	mutex_lock(&disks_mutex);
+
+	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock)) {
+		mutex_unlock(&disks_mutex);
+		return;
+	}
 	list_del(&mddev->all_mddevs);
 	spin_unlock(&all_mddevs_lock);
 
-	del_gendisk(mddev->gendisk);
-	mddev->gendisk = NULL;
+	if (mddev->gendisk)
+		del_gendisk(mddev->gendisk);
 	blk_cleanup_queue(mddev->queue);
-	mddev->queue = NULL;
 	kobject_unregister(&mddev->kobj);
+
+	mutex_unlock(&disks_mutex);
 }
 
 static mddev_t * mddev_find(dev_t unit)
@@ -2948,7 +2966,6 @@ int mdp_major = 0;
 
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
 {
-	static DEFINE_MUTEX(disks_mutex);
 	mddev_t *mddev = mddev_find(dev);
 	struct gendisk *disk;
 	int partitioned = (MAJOR(dev) != MD_MAJOR);
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
md-close-a-race-between-destroying-and-recreating-an-md-device.patch
md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

