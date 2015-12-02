From: akpm@linux-foundation.org
Subject: + mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
 added to -mm tree
Date: Tue, 01 Dec 2015 16:55:30 -0800
Message-ID: <565e4182.XUA9MYUIiSgBm3By%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbbLBAzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 19:55:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: provide symbolic page flags and gfp_flags
has been added to the -mm tree.  Its filename is
     mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: provide symbolic page flags and gfp_flags

With the new format strings for flags, we can now provide symbolic page
and gfp flags in the /sys/kernel/debug/page_owner file.  This replaces the
positional printing of page flags as single letters, which might have
looked nicer, but was limited to a subset of flags, and required the user
to remember the letters.

Example of the adjusted format:

Page allocated via order 0, mask 0x24213ca(GFP_HIGHUSER_MOVABLE|GFP_COLD|GFP_NOWARN|GFP_NORETRY)
PFN 674308 type Movable Block 1317 type Movable Flags 0x1fffff80010068(uptodate|lru|active|mappedtodisk)
 [<ffffffff81164e9a>] __alloc_pages_nodemask+0x15a/0xa30
 [<ffffffff811ab938>] alloc_pages_current+0x88/0x120
 [<ffffffff8115bc46>] __page_cache_alloc+0xe6/0x120
 [<ffffffff81168b9b>] __do_page_cache_readahead+0xdb/0x200
 [<ffffffff81168df5>] ondemand_readahead+0x135/0x260
 [<ffffffff81168f8c>] page_cache_async_readahead+0x6c/0x70
 [<ffffffff8115d5f8>] generic_file_read_iter+0x378/0x590
 [<ffffffff811d12a7>] __vfs_read+0xa7/0xd0
Page has been migrated, last migrate reason: compaction

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-provide-symbolic-page-flags-and-gfp_flags mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-provide-symbolic-page-flags-and-gfp_flags
+++ a/mm/page_owner.c
@@ -135,8 +135,8 @@ print_page_owner(char __user *buf, size_
 		return -ENOMEM;
 
 	ret = snprintf(kbuf, count,
-			"Page allocated via order %u, mask 0x%x\n",
-			page_ext->order, page_ext->gfp_mask);
+			"Page allocated via order %u, mask %pgg\n",
+			page_ext->order, &page_ext->gfp_mask);
 
 	if (ret >= count)
 		goto err;
@@ -145,23 +145,12 @@ print_page_owner(char __user *buf, size_
 	pageblock_mt = get_pfnblock_migratetype(page, pfn);
 	page_mt  = gfpflags_to_migratetype(page_ext->gfp_mask);
 	ret += snprintf(kbuf + ret, count - ret,
-			"PFN %lu type %s Block %lu type %s Flags %s%s%s%s%s%s%s%s%s%s%s%s\n",
+			"PFN %lu type %s Block %lu type %s Flags %pgp\n",
 			pfn,
 			migratetype_names[page_mt],
 			pfn >> pageblock_order,
 			migratetype_names[pageblock_mt],
-			PageLocked(page)	? "K" : " ",
-			PageError(page)		? "E" : " ",
-			PageReferenced(page)	? "R" : " ",
-			PageUptodate(page)	? "U" : " ",
-			PageDirty(page)		? "D" : " ",
-			PageLRU(page)		? "L" : " ",
-			PageActive(page)	? "A" : " ",
-			PageSlab(page)		? "S" : " ",
-			PageWriteback(page)	? "W" : " ",
-			PageCompound(page)	? "C" : " ",
-			PageSwapCache(page)	? "B" : " ",
-			PageMappedToDisk(page)	? "M" : " ");
+			&page->flags);
 
 	if (ret >= count)
 		goto err;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-track-and-print-last-migrate-reason-fix.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch

