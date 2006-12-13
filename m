From: akpm@osdl.org
Subject: - md-remove-some-old-ifdefed-out-code-from-raid5c.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:01 -0800
Message-ID: <200612130655.kBD6t1xf030599@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57707 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965020AbWLMGzF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: remove some old ifdefed-out code from raid5.c
has been removed from the -mm tree.  Its filename was
     md-remove-some-old-ifdefed-out-code-from-raid5c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: remove some old ifdefed-out code from raid5.c
From: NeilBrown <neilb@suse.de>

There are some vestiges of old code that was used for bypassing the stripe
cache on reads in raid5.c.  This was never updated after the change from
buffer_heads to bios, but was left as a reminder.

That functionality has nowe been implemented in a completely different way, so
the old code can go.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |   63 -------------------------------------------
 1 file changed, 63 deletions(-)

diff -puN drivers/md/raid5.c~md-remove-some-old-ifdefed-out-code-from-raid5c drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-remove-some-old-ifdefed-out-code-from-raid5c
+++ a/drivers/md/raid5.c
@@ -544,35 +544,7 @@ static int raid5_end_read_request(struct
 	}
 
 	if (uptodate) {
-#if 0
-		struct bio *bio;
-		unsigned long flags;
-		spin_lock_irqsave(&conf->device_lock, flags);
-		/* we can return a buffer if we bypassed the cache or
-		 * if the top buffer is not in highmem.  If there are
-		 * multiple buffers, leave the extra work to
-		 * handle_stripe
-		 */
-		buffer = sh->bh_read[i];
-		if (buffer &&
-		    (!PageHighMem(buffer->b_page)
-		     || buffer->b_page == bh->b_page )
-			) {
-			sh->bh_read[i] = buffer->b_reqnext;
-			buffer->b_reqnext = NULL;
-		} else
-			buffer = NULL;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		if (sh->bh_page[i]==bh->b_page)
-			set_buffer_uptodate(bh);
-		if (buffer) {
-			if (buffer->b_page != bh->b_page)
-				memcpy(buffer->b_data, bh->b_data, bh->b_size);
-			buffer->b_end_io(buffer, 1);
-		}
-#else
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
-#endif
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			rdev = conf->disks[i].rdev;
 			printk(KERN_INFO "raid5:%s: read error corrected (%lu sectors at %llu on %s)\n",
@@ -618,14 +590,6 @@ static int raid5_end_read_request(struct
 		}
 	}
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
-#if 0
-	/* must restore b_page before unlocking buffer... */
-	if (sh->bh_page[i] != bh->b_page) {
-		bh->b_page = sh->bh_page[i];
-		bh->b_data = page_address(bh->b_page);
-		clear_buffer_uptodate(bh);
-	}
-#endif
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
@@ -1619,15 +1583,6 @@ static void handle_stripe5(struct stripe
 				} else if (test_bit(R5_Insync, &dev->flags)) {
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
-#if 0
-					/* if I am just reading this block and we don't have
-					   a failed drive, or any pending writes then sidestep the cache */
-					if (sh->bh_read[i] && !sh->bh_read[i]->b_reqnext &&
-					    ! syncing && !failed && !to_write) {
-						sh->bh_cache[i]->b_page =  sh->bh_read[i]->b_page;
-						sh->bh_cache[i]->b_data =  sh->bh_read[i]->b_data;
-					}
-#endif
 					locked++;
 					PRINTK("Reading block %d (sync=%d)\n", 
 						i, syncing);
@@ -1645,9 +1600,6 @@ static void handle_stripe5(struct stripe
 			dev = &sh->dev[i];
 			if ((dev->towrite || i == sh->pd_idx) &&
 			    (!test_bit(R5_LOCKED, &dev->flags) 
-#if 0
-|| sh->bh_page[i]!=bh->b_page
-#endif
 				    ) &&
 			    !test_bit(R5_UPTODATE, &dev->flags)) {
 				if (test_bit(R5_Insync, &dev->flags)
@@ -1659,9 +1611,6 @@ static void handle_stripe5(struct stripe
 			/* Would I have to read this buffer for reconstruct_write */
 			if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
 			    (!test_bit(R5_LOCKED, &dev->flags) 
-#if 0
-|| sh->bh_page[i] != bh->b_page
-#endif
 				    ) &&
 			    !test_bit(R5_UPTODATE, &dev->flags)) {
 				if (test_bit(R5_Insync, &dev->flags)) rcw++;
@@ -2197,15 +2146,6 @@ static void handle_stripe6(struct stripe
 				} else if (test_bit(R5_Insync, &dev->flags)) {
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
-#if 0
-					/* if I am just reading this block and we don't have
-					   a failed drive, or any pending writes then sidestep the cache */
-					if (sh->bh_read[i] && !sh->bh_read[i]->b_reqnext &&
-					    ! syncing && !failed && !to_write) {
-						sh->bh_cache[i]->b_page =  sh->bh_read[i]->b_page;
-						sh->bh_cache[i]->b_data =  sh->bh_read[i]->b_data;
-					}
-#endif
 					locked++;
 					PRINTK("Reading block %d (sync=%d)\n",
 						i, syncing);
@@ -2224,9 +2164,6 @@ static void handle_stripe6(struct stripe
 			if (!test_bit(R5_OVERWRITE, &dev->flags)
 			    && i != pd_idx && i != qd_idx
 			    && (!test_bit(R5_LOCKED, &dev->flags)
-#if 0
-				|| sh->bh_page[i] != bh->b_page
-#endif
 				    ) &&
 			    !test_bit(R5_UPTODATE, &dev->flags)) {
 				if (test_bit(R5_Insync, &dev->flags)) rcw++;
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

