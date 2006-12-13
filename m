From: akpm@osdl.org
Subject: - md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:03 -0800
Message-ID: <200612130655.kBD6t3cU030602@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57712 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965024AbWLMGzH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: return a non-zero error to bi_end_io as appropriate in raid5
has been removed from the -mm tree.  Its filename was
     md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: return a non-zero error to bi_end_io as appropriate in raid5
From: NeilBrown <neilb@suse.de>

Currently raid5 depends on clearing the BIO_UPTODATE flag to signal an error
to higher levels.  While this should be sufficient, it is safer to explicitly
set the error code as well - less room for confusion.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/md/raid5.c~md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5 drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5
+++ a/drivers/md/raid5.c
@@ -1818,7 +1818,9 @@ static void handle_stripe5(struct stripe
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes,
+			      test_bit(BIO_UPTODATE, &bi->bi_flags)
+			        ? 0 : -EIO);
 	}
 	for (i=disks; i-- ;) {
 		int rw;
@@ -2359,7 +2361,9 @@ static void handle_stripe6(struct stripe
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes,
+			      test_bit(BIO_UPTODATE, &bi->bi_flags)
+			        ? 0 : -EIO);
 	}
 	for (i=disks; i-- ;) {
 		int rw;
@@ -2859,7 +2863,9 @@ static int make_request(request_queue_t 
 		if ( rw == WRITE )
 			md_write_end(mddev);
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes,
+			      test_bit(BIO_UPTODATE, &bi->bi_flags)
+			        ? 0 : -EIO);
 	}
 	return 0;
 }
@@ -3127,7 +3133,9 @@ static int  retry_aligned_read(raid5_con
 		int bytes = raid_bio->bi_size;
 
 		raid_bio->bi_size = 0;
-		raid_bio->bi_end_io(raid_bio, bytes, 0);
+		raid_bio->bi_end_io(raid_bio, bytes,
+			      test_bit(BIO_UPTODATE, &raid_bio->bi_flags)
+			        ? 0 : -EIO);
 	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_stripe);
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

