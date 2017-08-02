From: akpm@linux-foundation.org
Subject: [folded-merged]
 swap-fix-oops-during-block-io-poll-in-swapin-path-fix.patch removed from
 -mm tree
Date: Wed, 02 Aug 2017 13:24:17 -0700
Message-ID: <598234f1.lq6CfihW70a3Xph6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44898 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752435AbdHBUYS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@fb.com, hughd@google.com, penguin-kernel@I-love.SAKURA.ne.jp, shli@fb.com, tim.c.chen@intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap-fix-oops-during-block-io-poll-in-swapin-path-fix
has been removed from the -mm tree.  Its filename was
     swap-fix-oops-during-block-io-poll-in-swapin-path-fix.patch

This patch was dropped because it was folded into swap-fix-oops-during-block-io-poll-in-swapin-path.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-fix-oops-during-block-io-poll-in-swapin-path-fix

add comment

Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_io.c~swap-fix-oops-during-block-io-poll-in-swapin-path-fix mm/page_io.c
--- a/mm/page_io.c~swap-fix-oops-during-block-io-poll-in-swapin-path-fix
+++ a/mm/page_io.c
@@ -380,6 +380,10 @@ int swap_readpage(struct page *page, boo
 		goto out;
 	}
 	bdev = bio->bi_bdev;
+	/*
+	 * Keep this task valid during swap readpage because the oom killer may
+	 * attempt to access it in the page fault retry time check.
+	 */
 	get_task_struct(current);
 	bio->bi_private = current;
 	bio_set_op_attrs(bio, REQ_OP_READ, 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
swap-fix-oops-during-block-io-poll-in-swapin-path.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

