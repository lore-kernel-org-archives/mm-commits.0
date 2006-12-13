From: akpm@osdl.org
Subject: - md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:52 -0800
Message-ID: <200612130654.kBD6sqfM030582@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57681 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965012AbWLMGy4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: tidy up device-change notification when an md array is stopped
has been removed from the -mm tree.  Its filename was
     md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: tidy up device-change notification when an md array is stopped
From: NeilBrown <neilb@suse.de>

An md array can be stopped leaving all the setting still in place, or it can
torn down and destroyed.  set_capacity and other change notifications only
happen in the latter case, but should happen in both.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/md/md.c~md-tidy-up-device-change-notification-when-an-md-array-is-stopped drivers/md/md.c
--- a/drivers/md/md.c~md-tidy-up-device-change-notification-when-an-md-array-is-stopped
+++ a/drivers/md/md.c
@@ -3314,6 +3314,10 @@ static int do_md_stop(mddev_t * mddev, i
 
 			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
+
+			set_capacity(disk, 0);
+			mddev->changed = 1;
+
 			if (mddev->ro)
 				mddev->ro = 0;
 		}
@@ -3333,7 +3337,7 @@ static int do_md_stop(mddev_t * mddev, i
 	if (mode == 0) {
 		mdk_rdev_t *rdev;
 		struct list_head *tmp;
-		struct gendisk *disk;
+
 		printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));
 
 		bitmap_destroy(mddev);
@@ -3358,10 +3362,6 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
 
-		disk = mddev->gendisk;
-		if (disk)
-			set_capacity(disk, 0);
-		mddev->changed = 1;
 	} else if (mddev->pers)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
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

