From: akpm@linux-foundation.org
Subject: + md-do-not-compute-parity-unless-it-is-on-a-failed-drive.patch added to -mm tree
Date: Mon, 26 May 2008 23:43:54 -0700
Message-ID: <200805270643.m4R6hsnQ013284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638AbYE0GoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 02:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, neilb@suse.de, stable@kernel.org


The patch titled
     md: do not compute parity unless it is on a failed drive
has been added to the -mm tree.  Its filename is
     md-do-not-compute-parity-unless-it-is-on-a-failed-drive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: do not compute parity unless it is on a failed drive
From: Dan Williams <dan.j.williams@intel.com>

If a block is computed (rather than read) then a check/repair operation
may be lead to believe that the data on disk is correct, when infact it
isn't.  So only compute blocks for failed devices.

This issue has been around since at least 2.6.12, but has become harder to
hit in recent kernels since most reads bypass the cache.

echo repair > /sys/block/mdN/md/sync_action will set the parity blocks to the
correct state.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/md/raid5.c~md-do-not-compute-parity-unless-it-is-on-a-failed-drive drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-do-not-compute-parity-unless-it-is-on-a-failed-drive
+++ a/drivers/md/raid5.c
@@ -2002,6 +2002,7 @@ static int __handle_issuing_new_read_req
 		 * have quiesced.
 		 */
 		if ((s->uptodate == disks - 1) &&
+		    (s->failed && disk_idx == s->failed_num) &&
 		    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
 			set_bit(R5_Wantcompute, &dev->flags);
@@ -2087,7 +2088,9 @@ static void handle_issuing_new_read_requ
 			/* we would like to get this block, possibly
 			 * by computing it, but we might not be able to
 			 */
-			if (s->uptodate == disks-1) {
+			if ((s->uptodate == disks - 1) &&
+			    (s->failed && (i == r6s->failed_num[0] ||
+					   i == r6s->failed_num[1]))) {
 				pr_debug("Computing stripe %llu block %d\n",
 				       (unsigned long long)sh->sector, i);
 				compute_block_1(sh, i, 0);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
md-md-raid5-rate-limit-error-printk.patch
md-notify-userspace-on-stop-events.patch
md-fix-prexor-vs-sync_request-race.patch
md-fix-uninitialized-use-of-mddev-recovery_wait.patch
md-do-not-compute-parity-unless-it-is-on-a-failed-drive.patch
linux-next.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
fsldma-fix-incorrect-exit-path-for-initialization.patch

