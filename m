From: akpm@linux-foundation.org
Subject: [merged]
 dax-use-pg_pmd_colour-instead-of-open-coding.patch removed from -mm tree
Date: Thu, 07 Sep 2017 11:36:46 -0700
Message-ID: <20170907183646.OMBlA73C-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54866 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755468AbdIGSg4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, marcin.slusarz@intel.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: dax: use PG_PMD_COLOUR instead of open coding
has been removed from the -mm tree.  Its filename was
     dax-use-pg_pmd_colour-instead-of-open-coding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: use PG_PMD_COLOUR instead of open coding

Use ~PG_PMD_COLOUR in dax_entry_waitqueue() instead of open coding an
equivalent page offset mask.

Link: http://lkml.kernel.org/r/20170822222436.18926-2-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Slusarz, Marcin" <marcin.slusarz@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/dax.c~dax-use-pg_pmd_colour-instead-of-open-coding fs/dax.c
--- a/fs/dax.c~dax-use-pg_pmd_colour-instead-of-open-coding
+++ a/fs/dax.c
@@ -42,6 +42,9 @@
 #define DAX_WAIT_TABLE_BITS 12
 #define DAX_WAIT_TABLE_ENTRIES (1 << DAX_WAIT_TABLE_BITS)
 
+/* The 'colour' (ie low bits) within a PMD of a page offset.  */
+#define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
+
 static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
 
 static int __init init_dax_wait_table(void)
@@ -132,7 +135,7 @@ static wait_queue_head_t *dax_entry_wait
 	 * the range covered by the PMD map to the same bit lock.
 	 */
 	if (dax_is_pmd_entry(entry))
-		index &= ~((1UL << (PMD_SHIFT - PAGE_SHIFT)) - 1);
+		index &= ~PG_PMD_COLOUR;
 
 	key->mapping = mapping;
 	key->entry_start = index;
@@ -1215,12 +1218,6 @@ static int dax_iomap_pte_fault(struct vm
 }
 
 #ifdef CONFIG_FS_DAX_PMD
-/*
- * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
- * more often than one might expect in the below functions.
- */
-#define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
