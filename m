From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:53:40 -0700
Message-ID: <538fa374.7caeN+1yBoQ+i2vd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaFDWxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, johannes@sipsolutions.net, joern@logfs.org, huangminfei@ucloud.cn, akpm@linux-foundation.org

Subject: [folded-merged] lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,huangminfei@ucloud.cn,joern@logfs.org,johannes@sipsolutions.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:53:39 -0700


The patch titled
     Subject: lib-btreec-fix-leak-of-whole-btree-nodes-fix
has been removed from the -mm tree.  Its filename was
     lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch

This patch was dropped because it was folded into lib-btreec-fix-leak-of-whole-btree-nodes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-btreec-fix-leak-of-whole-btree-nodes-fix

remove unneeded test of NULL

Cc: Joern Engel <joern@logfs.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Minfei Huang <huangminfei@ucloud.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/btree.c~lib-btreec-fix-leak-of-whole-btree-nodes-fix lib/btree.c
--- a/lib/btree.c~lib-btreec-fix-leak-of-whole-btree-nodes-fix
+++ a/lib/btree.c
@@ -198,8 +198,7 @@ EXPORT_SYMBOL_GPL(btree_init);
 
 void btree_destroy(struct btree_head *head)
 {
-	if (head->node)
-		mempool_free(head->node, head->mempool);
+	mempool_free(head->node, head->mempool);
 	mempool_destroy(head->mempool);
 	head->mempool = NULL;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
swap-use-bdev_read_page-bdev_write_page.patch
mm-update-comment-for-default_max_map_count.patch
memcg-fold-mem_cgroup_stolen.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
mm-document-do_fault_around-feature.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch
lib-btreec-fix-leak-of-whole-btree-nodes.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

