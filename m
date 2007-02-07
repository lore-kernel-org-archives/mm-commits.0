From: akpm@linux-foundation.org
Subject: + md-avoid-possible-bug_on-in-md-bitmap-handling.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:38:14 -0800
Message-ID: <200702072338.l17NcEHX031322@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45613 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161477AbXBGXjc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:39:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, stable@kernel.org


The patch titled
     md: avoid possible BUG_ON in md bitmap handling
has been added to the -mm tree.  Its filename is
     md-avoid-possible-bug_on-in-md-bitmap-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: avoid possible BUG_ON in md bitmap handling
From: Neil Brown <neilb@suse.de>

md/bitmap tracks how many active write requests are pending on blocks
associated with each bit in the bitmap, so that it knows when it can clear
the bit (when count hits zero).

The counter has 14 bits of space, so if there are ever more than 16383, we
cannot cope.

Currently the code just calles BUG_ON as "all" drivers have request queue
limits much smaller than this.

However is seems that some don't.  Apparently some multipath configurations
can allow more than 16383 concurrent write requests.

So, in this unlikely situation, instead of calling BUG_ON we now wait
for the count to drop down a bit.  This requires a new wait_queue_head,
some waiting code, and a wakeup call.

Tested by limiting the counter to 20 instead of 16383 (writes go a lot slower
in that case...).

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c         |   22 +++++++++++++++++++++-
 include/linux/raid/bitmap.h |    1 +
 2 files changed, 22 insertions(+), 1 deletion(-)

diff -puN drivers/md/bitmap.c~md-avoid-possible-bug_on-in-md-bitmap-handling drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-avoid-possible-bug_on-in-md-bitmap-handling
+++ a/drivers/md/bitmap.c
@@ -1160,6 +1160,22 @@ int bitmap_startwrite(struct bitmap *bit
 			return 0;
 		}
 
+		if (unlikely((*bmc & COUNTER_MAX) == COUNTER_MAX)) {
+			DEFINE_WAIT(__wait);
+			/* note that it is safe to do the prepare_to_wait
+			 * after the test as long as we do it before dropping
+			 * the spinlock.
+			 */
+			prepare_to_wait(&bitmap->overflow_wait, &__wait,
+					TASK_UNINTERRUPTIBLE);
+			spin_unlock_irq(&bitmap->lock);
+			bitmap->mddev->queue
+				->unplug_fn(bitmap->mddev->queue);
+			schedule();
+			finish_wait(&bitmap->overflow_wait, &__wait);
+			continue;
+		}
+
 		switch(*bmc) {
 		case 0:
 			bitmap_file_set_bit(bitmap, offset);
@@ -1169,7 +1185,7 @@ int bitmap_startwrite(struct bitmap *bit
 		case 1:
 			*bmc = 2;
 		}
-		BUG_ON((*bmc & COUNTER_MAX) == COUNTER_MAX);
+
 		(*bmc)++;
 
 		spin_unlock_irq(&bitmap->lock);
@@ -1207,6 +1223,9 @@ void bitmap_endwrite(struct bitmap *bitm
 		if (!success && ! (*bmc & NEEDED_MASK))
 			*bmc |= NEEDED_MASK;
 
+		if ((*bmc & COUNTER_MAX) == COUNTER_MAX)
+			wake_up(&bitmap->overflow_wait);
+
 		(*bmc)--;
 		if (*bmc <= 2) {
 			set_page_attr(bitmap,
@@ -1431,6 +1450,7 @@ int bitmap_create(mddev_t *mddev)
 	spin_lock_init(&bitmap->lock);
 	atomic_set(&bitmap->pending_writes, 0);
 	init_waitqueue_head(&bitmap->write_wait);
+	init_waitqueue_head(&bitmap->overflow_wait);
 
 	bitmap->mddev = mddev;
 
diff -puN include/linux/raid/bitmap.h~md-avoid-possible-bug_on-in-md-bitmap-handling include/linux/raid/bitmap.h
--- a/include/linux/raid/bitmap.h~md-avoid-possible-bug_on-in-md-bitmap-handling
+++ a/include/linux/raid/bitmap.h
@@ -247,6 +247,7 @@ struct bitmap {
 
 	atomic_t pending_writes; /* pending writes to the bitmap file */
 	wait_queue_head_t write_wait;
+	wait_queue_head_t overflow_wait;
 
 };
 
_

Patches currently in -mm which might be from neilb@suse.de are

md-fix-various-bugs-with-aligned-reads-in-raid5.patch
knfsd-fix-a-race-in-closing-nfsd-connections.patch
md-avoid-possible-bug_on-in-md-bitmap-handling.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
replace-highest_possible_node_id-with-nr_node_ids-fix.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
fix-d_path-for-lazy-unmounts.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-aplit-svc_sock_enqueue-out-of-svc_setup_socket.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch
knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-add-a-generic-function-to-see-if-the-peer-uses-a-secure-port.patch
knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
