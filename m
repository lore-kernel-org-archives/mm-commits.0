From: akpm@linux-foundation.org
Subject: + dax-move-radix_dax_-definitions-to-daxc.patch added to -mm tree
Date: Fri, 15 Apr 2016 23:05:07 -0700
Message-ID: <5711d613.YAkrQ3bjORG7lCeo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbcDPGFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:05:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, jack@suse.cz, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: move RADIX_DAX_ definitions to dax.c
has been added to the -mm tree.  Its filename is
     dax-move-radix_dax_-definitions-to-daxc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-move-radix_dax_-definitions-to-daxc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-move-radix_dax_-definitions-to-daxc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
