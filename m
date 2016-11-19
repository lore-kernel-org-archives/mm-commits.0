From: akpm@linux-foundation.org
Subject: +
 include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch added
 to -mm tree
Date: Fri, 18 Nov 2016 16:23:54 -0800
Message-ID: <582f9b9a.0ul5GIh2nynvLxOb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753065AbcKSAXz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 19:23:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/backing-dev-defs.h: shrink struct backing_dev_info
has been added to the -mm tree.  Its filename is
     include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch

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
Subject: include/linux/backing-dev-defs.h: shrink struct backing_dev_info

Move the 4-byte `capabilities' field next to other 4-byte things.  Shrinks
sizeof(backing_dev_info) by 8 bytes on x86_64 for some strange reason.

Cc: Jens Axboe <axboe@kernel.dk>
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
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
mle-releases-issue-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

