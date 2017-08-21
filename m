From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch removed from -mm tree
Date: Mon, 21 Aug 2017 13:33:15 -0700
Message-ID: <599b438b.b9YoXYGjiTLD/heI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44048 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753492AbdHUUdQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2017 16:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix

fix CONFIG_COMPACTION=n build

Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    2 ++
 mm/compaction.c                 |    5 +++++
 2 files changed, 7 insertions(+)

diff -puN include/linux/pageblock-flags.h~mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix
+++ a/include/linux/pageblock-flags.h
@@ -96,6 +96,8 @@ void set_pfnblock_flags_mask(struct page
 #define set_pageblock_skip(page) \
 			set_pageblock_flags_group(page, 1, PB_migrate_skip,  \
 							PB_migrate_skip)
+#else
+#define set_pageblock_skip(page) do { } while (0)
 #endif /* CONFIG_COMPACTION */
 
 #endif	/* PAGEBLOCK_FLAGS_H */
diff -puN mm/compaction.c~mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix
+++ a/mm/compaction.c
@@ -327,6 +327,11 @@ static void update_pageblock_skip(struct
 			bool migrate_scanner)
 {
 }
+
+static bool pageblock_skip_persistent(struct page *page, unsigned int order)
+{
+	return false;
+}
 #endif /* CONFIG_COMPACTION */
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
add-testcases-for-memset16-32-64-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

