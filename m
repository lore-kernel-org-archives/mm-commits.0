From: akpm@osdl.org
Subject: - md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:57 -0800
Message-ID: <200612130654.kBD6svID030591@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57700 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965015AbWLMGzB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix innocuous bug in raid6 stripe_to_pdidx
has been removed from the -mm tree.  Its filename was
     md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: fix innocuous bug in raid6 stripe_to_pdidx
From: NeilBrown <neilb@suse.de>

stripe_to_pdidx finds the index of the parity disk for a given stripe.  It
assumes raid5 in that it uses "disks-1" to determine the number of data disks.

This is incorrect for raid6 but fortunately the two usages cancel each other
out.  The only way that 'data_disks' affects the calculation of pd_idx in
raid5_compute_sector is when it is divided into the sector number.  But as
that sector number is calculated by multiplying in the wrong value of
'data_disks' the division produces the right value.

So it is innocuous but needs to be fixed.

Also change the calculation of raid_disks in compute_blocknr to make it
more obviously correct (it seems at first to always use disks-1 too).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/md/raid5.c~md-fix-innocuous-bug-in-raid6-stripe_to_pdidx drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-innocuous-bug-in-raid6-stripe_to_pdidx
+++ a/drivers/md/raid5.c
@@ -823,7 +823,8 @@ static sector_t raid5_compute_sector(sec
 static sector_t compute_blocknr(struct stripe_head *sh, int i)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int raid_disks = sh->disks, data_disks = raid_disks - 1;
+	int raid_disks = sh->disks;
+	int data_disks = raid_disks - conf->max_degraded;
 	sector_t new_sector = sh->sector, check;
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	sector_t stripe;
@@ -859,7 +860,6 @@ static sector_t compute_blocknr(struct s
 		}
 		break;
 	case 6:
-		data_disks = raid_disks - 2;
 		if (i == raid6_next_disk(sh->pd_idx, raid_disks))
 			return 0; /* It is the Q disk */
 		switch (conf->algorithm) {
@@ -1355,8 +1355,10 @@ static int stripe_to_pdidx(sector_t stri
 	int pd_idx, dd_idx;
 	int chunk_offset = sector_div(stripe, sectors_per_chunk);
 
-	raid5_compute_sector(stripe*(disks-1)*sectors_per_chunk
-			     + chunk_offset, disks, disks-1, &dd_idx, &pd_idx, conf);
+	raid5_compute_sector(stripe * (disks - conf->max_degraded)
+			     *sectors_per_chunk + chunk_offset,
+			     disks, disks - conf->max_degraded,
+			     &dd_idx, &pd_idx, conf);
 	return pd_idx;
 }
 
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

