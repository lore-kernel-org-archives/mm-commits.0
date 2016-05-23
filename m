From: akpm@linux-foundation.org
Subject: [merged] dax-move-radix_dax_-definitions-to-daxc.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:51:22 -0700
Message-ID: <57435f3a.z0eP2bIWFfZhyTet%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbcEWTvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, jack@suse.cz, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: move RADIX_DAX_ definitions to dax.c
has been removed from the -mm tree.  Its filename was
     dax-move-radix_dax_-definitions-to-daxc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.com>
Subject: dax: move RADIX_DAX_ definitions to dax.c

These don't belong in radix-tree.h any more than PAGECACHE_TAG_* do. 
Let's try to maintain the idea that radix-tree simply implements an
abstract data type.

Signed-off-by: NeilBrown <neilb@suse.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                   |    9 +++++++++
 include/linux/radix-tree.h |    9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/dax.c~dax-move-radix_dax_-definitions-to-daxc fs/dax.c
--- a/fs/dax.c~dax-move-radix_dax_-definitions-to-daxc
+++ a/fs/dax.c
@@ -32,6 +32,15 @@
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
 
+#define RADIX_DAX_MASK	0xf
+#define RADIX_DAX_SHIFT	4
+#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
+#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
+#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
+#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
+#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
+		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
+
 static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
 {
 	struct request_queue *q = bdev->bd_queue;
diff -puN include/linux/radix-tree.h~dax-move-radix_dax_-definitions-to-daxc include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~dax-move-radix_dax_-definitions-to-daxc
+++ a/include/linux/radix-tree.h
@@ -48,15 +48,6 @@
 #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
 #define RADIX_TREE_EXCEPTIONAL_SHIFT	2
 
-#define RADIX_DAX_MASK	0xf
-#define RADIX_DAX_SHIFT	4
-#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
-#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
-#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
-		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
