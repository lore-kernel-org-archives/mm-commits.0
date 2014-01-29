From: akpm@linux-foundation.org
Subject: [merged] block-blk-mq-cpuc-use-hotcpu_notifier.patch removed from -mm tree
Date: Wed, 29 Jan 2014 10:58:28 -0800
Message-ID: <52e94f54.1lqVMv+vIVR8Vwqn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaA2S63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jan 2014 13:58:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, axboe@kernel.dk, akpm@linux-foundation.org

Subject: [merged] block-blk-mq-cpuc-use-hotcpu_notifier.patch removed from -mm tree
To: akpm@linux-foundation.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 29 Jan 2014 10:58:28 -0800


The patch titled
     Subject: block/blk-mq-cpu.c: use hotcpu_notifier()
has been removed from the -mm tree.  Its filename was
     block-blk-mq-cpuc-use-hotcpu_notifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block/blk-mq-cpu.c: use hotcpu_notifier()

Cleaner, reduces text size when cpu hotplug is disabled.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-mq-cpu.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN block/blk-mq-cpu.c~block-blk-mq-cpuc-use-hotcpu_notifier block/blk-mq-cpu.c
--- a/block/blk-mq-cpu.c~block-blk-mq-cpuc-use-hotcpu_notifier
+++ a/block/blk-mq-cpu.c
@@ -28,10 +28,6 @@ static int blk_mq_main_cpu_notify(struct
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata blk_mq_main_cpu_notifier = {
-	.notifier_call	= blk_mq_main_cpu_notify,
-};
-
 void blk_mq_register_cpu_notifier(struct blk_mq_cpu_notifier *notifier)
 {
 	BUG_ON(!notifier->notify);
@@ -58,5 +54,5 @@ void blk_mq_init_cpu_notifier(struct blk
 
 void __init blk_mq_cpu_init(void)
 {
-	register_hotcpu_notifier(&blk_mq_main_cpu_notifier);
+	hotcpu_notifier(blk_mq_main_cpu_notify, 0);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
mm-document-improved-handling-of-swappiness==0-fix.patch
mm-mempolicyc-convert-to-pr_foo.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

