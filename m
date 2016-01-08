From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch removed from
 -mm tree
Date: Thu, 07 Jan 2016 16:27:21 -0800
Message-ID: <568f0269.ZSh94sB/9KuMFwyV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbcAHA1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 19:27:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: provide symbolic page flags and gfp_flags
has been removed from the -mm tree.  Its filename was
     mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch

This patch was dropped because an updated version will be merged

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-provide-symbolic-page-flags-and-gfp_flags mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-provide-symbolic-page-flags-and-gfp_flags
+++ a/mm/page_owner.c
@@ -100,8 +100,9 @@ print_page_owner(char __user *buf, size_
 		return -ENOMEM;
 
 	ret = snprintf(kbuf, count,
-			"Page allocated via order %u, mask 0x%x\n",
-			page_ext->order, page_ext->gfp_mask);
+			"Page allocated via order %u, mask %#x(%pgg)\n",
+			page_ext->order, page_ext->gfp_mask,
+			&page_ext->gfp_mask);
 
 	if (ret >= count)
 		goto err;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

