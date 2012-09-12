From: akpm@linux-foundation.org
Subject: + memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch added to -mm tree
Date: Wed, 12 Sep 2012 14:32:53 -0700
Message-ID: <20120912213253.C2E861E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:47202 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2ILVcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 17:32:55 -0400
Received: by yenq6 with SMTP id q6so246086yen.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 14:32:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, m.szyprowski@samsung.com, mina86@mina86.com, wency@cn.fujitsu.com


The patch titled
     Subject: memory-hotplug: don't replace lowmem pages with highmem
has been added to the -mm tree.  Its filename is
     memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: memory-hotplug: don't replace lowmem pages with highmem

The changelog for 6a6dccba2 ("mm: cma: don't replace lowmem pages with
highmem") mentioned that lowmem pages can be replaced by highmem pages
during CMA migration.  6a6dccba2 fixed that issue.

Quote from that changelog:

:   The filesystem layer expects pages in the block device's mapping to not
:   be in highmem (the mapping's gfp mask is set in bdget()), but CMA can
:   currently replace lowmem pages with highmem pages, leading to crashes in
:   filesystem code such as the one below:
:
:     Unable to handle kernel NULL pointer dereference at virtual address 00000400
:     pgd = c0c98000
:     [00000400] *pgd=00c91831, *pte=00000000, *ppte=00000000
:     Internal error: Oops: 817 [#1] PREEMPT SMP ARM
:     CPU: 0    Not tainted  (3.5.0-rc5+ #80)
:     PC is at __memzero+0x24/0x80
:     ...
:     Process fsstress (pid: 323, stack limit = 0xc0cbc2f0)
:     Backtrace:
:     [<c010e3f0>] (ext4_getblk+0x0/0x180) from [<c010e58c>] (ext4_bread+0x1c/0x98)
:     [<c010e570>] (ext4_bread+0x0/0x98) from [<c0117944>] (ext4_mkdir+0x160/0x3bc)
:      r4:c15337f0
:     [<c01177e4>] (ext4_mkdir+0x0/0x3bc) from [<c00c29e0>] (vfs_mkdir+0x8c/0x98)
:     [<c00c2954>] (vfs_mkdir+0x0/0x98) from [<c00c2a60>] (sys_mkdirat+0x74/0xac)
:      r6:00000000 r5:c152eb40 r4:000001ff r3:c14b43f0
:     [<c00c29ec>] (sys_mkdirat+0x0/0xac) from [<c00c2ab8>] (sys_mkdir+0x20/0x24)
:      r6:beccdcf0 r5:00074000 r4:beccdbbc
:     [<c00c2a98>] (sys_mkdir+0x0/0x24) from [<c000e3c0>] (ret_fast_syscall+0x0/0x30)

Memory-hotplug has same problem as CMA has so the same fix can be applied
to memory-hotplug as well.

Fix it by reusing.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-dont-replace-lowmem-pages-with-highmem mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-dont-replace-lowmem-pages-with-highmem
+++ a/mm/memory_hotplug.c
@@ -752,13 +752,6 @@ static unsigned long scan_lru_pages(unsi
 	return 0;
 }
 
-static struct page *
-hotremove_migrate_alloc(struct page *page, unsigned long private, int **x)
-{
-	/* This should be improooooved!! */
-	return alloc_page(GFP_HIGHUSER_MOVABLE);
-}
-
 #define NR_OFFLINE_AT_ONCE_PAGES	(256)
 static int
 do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
@@ -809,8 +802,12 @@ do_migrate_range(unsigned long start_pfn
 			putback_lru_pages(&source);
 			goto out;
 		}
-		/* this function returns # of failed pages */
-		ret = migrate_pages(&source, hotremove_migrate_alloc, 0,
+
+		/*
+		 * alloc_migrate_target should be improooooved!!
+		 * migrate_pages returns # of failed pages.
+		 */
+		ret = migrate_pages(&source, alloc_migrate_target, 0,
 							true, MIGRATE_SYNC);
 		if (ret)
 			putback_lru_pages(&source);
_

Patches currently in -mm which might be from minchan@kernel.org are

memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-check-lock-contention-first-before-taking-lock.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch

