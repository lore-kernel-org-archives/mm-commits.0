From: akpm@osdl.org
Subject: - md-assorted-md-and-raid1-one-liners.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:05 -0800
Message-ID: <200612130655.kBD6t5oZ030609@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57718 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965020AbWLMGzJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: assorted md and raid1 one-liners
has been removed from the -mm tree.  Its filename was
     md-assorted-md-and-raid1-one-liners.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: assorted md and raid1 one-liners
From: NeilBrown <neilb@suse.de>

Fix few bugs that meant that:
  - superblocks weren't alway written at exactly the right time (this
    could show up if the array was not written to - writting to the array
    causes lots of superblock updates and so hides these errors).

  - restarting device recovery after a clean shutdown (version-1 metadata
    only) didn't work as intended (or at all).

1/ Ensure superblock is updated when a new device is added.
2/ Remove an inappropriate test on MD_RECOVERY_SYNC in md_do_sync.
   The body of this if takes one of two branches depending on whether
   MD_RECOVERY_SYNC is set, so testing it in the clause of the if
   is wrong.
3/ Flag superblock for updating after a resync/recovery finishes.
4/ If we find the neeed to restart a recovery in the middle (version-1
   metadata only) make sure a full recovery (not just as guided by
   bitmaps) does get done.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c    |    3 ++-
 drivers/md/raid1.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-assorted-md-and-raid1-one-liners drivers/md/md.c
--- a/drivers/md/md.c~md-assorted-md-and-raid1-one-liners
+++ a/drivers/md/md.c
@@ -3724,6 +3724,7 @@ static int add_new_disk(mddev_t * mddev,
 		if (err)
 			export_rdev(rdev);
 
+		md_update_sb(mddev, 1);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 		return err;
@@ -5275,7 +5276,6 @@ void md_do_sync(mddev_t *mddev)
 	mddev->pers->sync_request(mddev, max_sectors, &skipped, 1);
 
 	if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
-	    test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > 2) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
@@ -5299,6 +5299,7 @@ void md_do_sync(mddev_t *mddev)
 					rdev->recovery_offset = mddev->curr_resync;
 		}
 	}
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
  skip:
 	mddev->curr_resync = 0;
diff -puN drivers/md/raid1.c~md-assorted-md-and-raid1-one-liners drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-assorted-md-and-raid1-one-liners
+++ a/drivers/md/raid1.c
@@ -1951,6 +1951,7 @@ static int run(mddev_t *mddev)
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
+			conf->fullsync = 1;
 		}
 	}
 	if (mddev->degraded == conf->raid_disks) {
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

