From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:25:15 -0800
Message-ID: <58519c9b.MEtJloyD+7g5D9WH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44434 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756564AbcLNTZQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/backing-dev-defs.h: shrink struct backing_dev_info
has been removed from the -mm tree.  Its filename was
     include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/backing-dev-defs.h: shrink struct backing_dev_info

Move the 4-byte `capabilities' field next to other 4-byte things.  Shrinks
sizeof(backing_dev_info) by 8 bytes on x86_64.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev-defs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/backing-dev-defs.h~include-linux-backing-dev-defsh-shrink-struct-backing_dev_info include/linux/backing-dev-defs.h
--- a/include/linux/backing-dev-defs.h~include-linux-backing-dev-defsh-shrink-struct-backing_dev_info
+++ a/include/linux/backing-dev-defs.h
@@ -137,12 +137,12 @@ struct backing_dev_info {
 	struct list_head bdi_list;
 	unsigned long ra_pages;	/* max readahead in PAGE_SIZE units */
 	unsigned long io_pages;	/* max allowed IO size */
-	unsigned int capabilities; /* Device capabilities */
 	congested_fn *congested_fn; /* Function pointer if device is md/dm */
 	void *congested_data;	/* Pointer to aux data for congested func */
 
 	char *name;
 
+	unsigned int capabilities; /* Device capabilities */
 	unsigned int min_ratio;
 	unsigned int max_ratio, max_prop_frac;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

