From: akpm@linux-foundation.org
Subject: +
 drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context.patch added to
 -mm tree
Date: Fri, 09 Sep 2016 21:22:44 -0700
Message-ID: <57d38a94.omatEE588HB001Qg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33950 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753113AbcIJEWq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 10 Sep 2016 00:22:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, khoroshilov@ispras.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rapidio/rio_cm.c: avoid GFP_KERNEL in atomic context
has been added to the -mm tree.  Its filename is
     drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/rapidio/rio_cm.c: avoid GFP_KERNEL in atomic context

riocm_send_close() is called from rio_cm_shutdown() under
spin_lock_bh(idr_lock), but riocm_send_close() uses a GFP_KERNEL
allocation.

Fix this by making local `hdr' a local variable rather than obtaining it
via kmalloc().

Found by Linux Driver Verification project (linuxtesting.org).

Link: http://lkml.kernel.org/r/1473453815-15914-1-git-send-email-khoroshilov@ispras.ru
Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio_cm.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN drivers/rapidio/rio_cm.c~drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context drivers/rapidio/rio_cm.c
--- a/drivers/rapidio/rio_cm.c~drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context
+++ a/drivers/rapidio/rio_cm.c
@@ -1397,36 +1397,32 @@ static void riocm_ch_free(struct kref *r
 
 static int riocm_send_close(struct rio_channel *ch)
 {
-	struct rio_ch_chan_hdr *hdr;
+	struct rio_ch_chan_hdr hdr;
 	int ret;
 
 	/*
 	 * Send CH_CLOSE notification to the remote RapidIO device
 	 */
 
-	hdr = kzalloc(sizeof(*hdr), GFP_KERNEL);
-	if (hdr == NULL)
-		return -ENOMEM;
-
-	hdr->bhdr.src_id = htonl(ch->loc_destid);
-	hdr->bhdr.dst_id = htonl(ch->rem_destid);
-	hdr->bhdr.src_mbox = cmbox;
-	hdr->bhdr.dst_mbox = cmbox;
-	hdr->bhdr.type = RIO_CM_CHAN;
-	hdr->ch_op = CM_CONN_CLOSE;
-	hdr->dst_ch = htons(ch->rem_channel);
-	hdr->src_ch = htons(ch->id);
+	memset(&hdr, 0, sizeof(hdr));
+	hdr.bhdr.src_id = htonl(ch->loc_destid);
+	hdr.bhdr.dst_id = htonl(ch->rem_destid);
+	hdr.bhdr.src_mbox = cmbox;
+	hdr.bhdr.dst_mbox = cmbox;
+	hdr.bhdr.type = RIO_CM_CHAN;
+	hdr.ch_op = CM_CONN_CLOSE;
+	hdr.dst_ch = htons(ch->rem_channel);
+	hdr.src_ch = htons(ch->id);
 
 	/* ATTN: the function call below relies on the fact that underlying
 	 * add_outb_message() routine copies TX data into its internal transfer
 	 * buffer. Needs to be reviewed if switched to direct buffer mode.
 	 */
-	ret = riocm_post_send(ch->cmdev, ch->rdev, hdr, sizeof(*hdr));
+	ret = riocm_post_send(ch->cmdev, ch->rdev, &hdr, sizeof(hdr));
 
 	if (ret == -EBUSY && !riocm_queue_req(ch->cmdev, ch->rdev,
-					      hdr, sizeof(*hdr)))
+					      &hdr, sizeof(hdr)))
 		return 0;
-	kfree(hdr);
 
 	if (ret)
 		riocm_error("ch(%d) send CLOSE failed (ret=%d)", ch->id, ret);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

