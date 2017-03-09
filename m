From: akpm@linux-foundation.org
Subject: [nacked]
 compaction-add-def_blk_aops-migrate-function-for-memory-compaction.patch
 removed from -mm tree
Date: Thu, 09 Mar 2017 12:00:06 -0800
Message-ID: <58c1b446.ySLs8yq/XXSlMAVB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57214 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbdCIUAI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 15:00:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhouxianrong@huawei.com, Mi.Sophia.Wang@huawei.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, minchan@kernel.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, weidu.du@huawei.com, won.ho.park@huawei.com, zhangshiming5@huawei.com, zhouxiaoyan1@huawei.com, zhouxiyu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compaction: add def_blk_aops migrate function for memory compaction
has been removed from the -mm tree.  Its filename was
     compaction-add-def_blk_aops-migrate-function-for-memory-compaction.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: zhouxianrong <zhouxianrong@huawei.com>
Subject: compaction: add def_blk_aops migrate function for memory compaction

The reason for doing this is based on two factors.

1. larg file read/write operations with order 0 can fragmentize
   memory rapidly.

2. when a special filesystem does not supply migratepage callback,
   kernel would fallback to default function fallback_migrate_page.
   but fallback_migrate_page could not migrate diry page nicely;
   specially kcompactd with MIGRATE_SYNC_LIGHT could not migrate
   diry pages due to this until clear_page_dirty_for_io in some
   procedure. i think it is not suitable here in this scenario.
   for dirty pages we should migrate it rather than skip or writeout
   it in kcomapctd with MIGRATE_SYNC_LIGHT. i think this problem is
   for all filesystem without migratepage not only for block device fs.

So for compaction under large file writing supply migratepage for
def_blk_aops.

Link: http://lkml.kernel.org/r/1488937915-78955-1-git-send-email-zhouxianrong@huawei.com
Signed-off-by: zhouxianrong <zhouxianrong@huawei.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <Mi.Sophia.Wang@huawei.com>
Cc: <zhouxiyu@huawei.com>
Cc: <weidu.du@huawei.com>
Cc: <zhangshiming5@huawei.com>
Cc: <won.ho.park@huawei.com>
Cc: <zhouxiaoyan1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/block_dev.c~compaction-add-def_blk_aops-migrate-function-for-memory-compaction fs/block_dev.c
--- a/fs/block_dev.c~compaction-add-def_blk_aops-migrate-function-for-memory-compaction
+++ a/fs/block_dev.c
@@ -2064,6 +2064,9 @@ static const struct address_space_operat
 	.releasepage	= blkdev_releasepage,
 	.direct_IO	= blkdev_direct_IO,
 	.is_dirty_writeback = buffer_check_dirty_writeback,
+#ifdef CONFIG_MIGRATION
+	.migratepage = buffer_migrate_page,
+#endif
 };
 
 #define	BLKDEV_FALLOC_FL_SUPPORTED					\
_

Patches currently in -mm which might be from zhouxianrong@huawei.com are


