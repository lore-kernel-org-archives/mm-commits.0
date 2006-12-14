From: akpm@osdl.org
Subject: - md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:44:45 -0800
Message-ID: <200612140044.kBE0ijSp026664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34226 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbWLNAot (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:44:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: allow mddevs to live a bit longer to avoid a loop with udev
has been removed from the -mm tree.  Its filename was
     md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: md: allow mddevs to live a bit longer to avoid a loop with udev
From: NeilBrown <neilb@suse.de>

As md devices a automatically created on first open, and automatically
destroyed on last close if they have no significant state, a loop can be
caused with udev.

If you open/close an md device that will generate add and remove events to
udev.  udev will open the device, notice nothing is there and close it again
...  which generates another pair of add/remove events.  Ad infinitum.

So: Change md to only destroy a device if an explicity MD_STOP was requested. 
This means that md devices might hang around longer than you would like, but
it is easy to get rid of them, and that could even be automated in user-space
(e.g.  by mdadm --monitor).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev drivers/md/md.c
--- a/drivers/md/md.c~md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev
+++ a/drivers/md/md.c
@@ -292,7 +292,7 @@ static mddev_t * mddev_find(dev_t unit)
 	atomic_set(&new->active, 1);
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
-	new->dead = 1;
+	new->dead = 0;
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
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
md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

