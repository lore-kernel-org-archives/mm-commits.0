From: akpm@linux-foundation.org
Subject: + remove-__gfp_no_kswapd-fixes.patch added to -mm tree
Date: Wed, 25 Jul 2012 11:58:26 -0700
Message-ID: <20120725185827.97F1720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33871 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903Ab2GYS6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2012 14:58:31 -0400
Received: by lagr15 with SMTP id r15so53106lag.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 11:58:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, David.Woodhouse@intel.com, aarcange@redhat.com, artem.bityutskiy@linux.intel.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: mm: remove __GFP_NO_KSWAPD fixes
has been added to the -mm tree.  Its filename is
     remove-__gfp_no_kswapd-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: remove __GFP_NO_KSWAPD fixes

Turns out I missed two spots where __GFP_NO_KSWAPD is used.

The removal from the trace code is obvious, since the flag
got removed there is no need to print it.

For mtdcore.c, now that memory compaction has been fixed, we should no
longer see large swap storms from an attempt to allocate a large buffer,
removing the need to specify __GFP_NO_KSWAPD.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c           |    3 +--
 include/trace/events/gfpflags.h |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/mtd/mtdcore.c~remove-__gfp_no_kswapd-fixes drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~remove-__gfp_no_kswapd-fixes
+++ a/drivers/mtd/mtdcore.c
@@ -1080,8 +1080,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  */
 void *mtd_kmalloc_up_to(const struct mtd_info *mtd, size_t *size)
 {
-	gfp_t flags = __GFP_NOWARN | __GFP_WAIT |
-		       __GFP_NORETRY | __GFP_NO_KSWAPD;
+	gfp_t flags = __GFP_NOWARN | __GFP_WAIT | __GFP_NORETRY;
 	size_t min_alloc = max_t(size_t, mtd->writesize, PAGE_SIZE);
 	void *kbuf;
 
diff -puN include/trace/events/gfpflags.h~remove-__gfp_no_kswapd-fixes include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~remove-__gfp_no_kswapd-fixes
+++ a/include/trace/events/gfpflags.h
@@ -36,7 +36,6 @@
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
 	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
-	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
 	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
 	) : "GFP_NOWAIT"
 
_
Subject: Subject: mm: remove __GFP_NO_KSWAPD fixes

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
swap-allow-swap-readahead-to-be-merged.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-remove-unused-lru_all_evictable.patch
mm-have-order-0-compaction-start-off-where-it-left.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
netvm-prevent-a-stream-specific-deadlock.patch
selinux-tag-avc-cache-alloc-as-non-critical.patch
mm-methods-for-teaching-filesystems-about-pg_swapcache-pages.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch
mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages.patch
mm-swap-implement-generic-handler-for-swap_activate.patch
mm-add-support-for-direct_io-to-highmem-pages.patch
nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages.patch
nfs-disable-data-cache-revalidation-for-swapfiles.patch
nfs-enable-swap-on-nfs.patch
nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch
swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
tmpfs-distribute-interleave-better-across-nodes.patch
mm-remove-__gfp_no_kswapd.patch
remove-__gfp_no_kswapd-fixes.patch
shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-rb_erase-updates-and-comments.patch
rbtree-optimize-fetching-of-sibling-node.patch

