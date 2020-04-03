From: akpm@linux-foundation.org
Subject: [merged] mm-add-pagemaph-to-the-fine-documentation.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:38:16 -0700
Message-ID: <20200403203816.KwCKcB-0h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUiR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, jhubbard@nvidia.com, mm-commits@vger.kernel.org, willy@infradead.org, ziy@nvidia.com


The patch titled
     Subject: mm: add pagemap.h to the fine documentation
has been removed from the -mm tree.  Its filename was
     mm-add-pagemaph-to-the-fine-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add pagemap.h to the fine documentation

The documentation currently does not include the deathless prose written
to describe functions in pagemap.h because it's not included in any rst
file.  Fix up the mismatches between parameter names and the documentation
and add the file to mm-api.

Link: http://lkml.kernel.org/r/20200221220045.24989-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    3 +++
 include/linux/pagemap.h           |    8 ++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-add-pagemaph-to-the-fine-documentation
+++ a/Documentation/core-api/mm-api.rst
@@ -73,6 +73,9 @@ File Mapping and Page Cache
 .. kernel-doc:: mm/truncate.c
    :export:
 
+.. kernel-doc:: include/linux/pagemap.h
+   :internal:
+
 Memory pools
 ============
 
--- a/include/linux/pagemap.h~mm-add-pagemaph-to-the-fine-documentation
+++ a/include/linux/pagemap.h
@@ -33,8 +33,8 @@ enum mapping_flags {
 
 /**
  * mapping_set_error - record a writeback error in the address_space
- * @mapping - the mapping in which an error should be set
- * @error - the error to set in the mapping
+ * @mapping: the mapping in which an error should be set
+ * @error: the error to set in the mapping
  *
  * When writeback fails in some way, we must record that error so that
  * userspace can be informed when fsync and the like are called.  We endeavor
@@ -303,9 +303,9 @@ static inline struct page *find_lock_pag
  * atomic allocation!
  */
 static inline struct page *find_or_create_page(struct address_space *mapping,
-					pgoff_t offset, gfp_t gfp_mask)
+					pgoff_t index, gfp_t gfp_mask)
 {
-	return pagecache_get_page(mapping, offset,
+	return pagecache_get_page(mapping, index,
 					FGP_LOCK|FGP_ACCESSED|FGP_CREAT,
 					gfp_mask);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-optimise-find_subpage-for-thp.patch
mm-remove-config_transparent_huge_pagecache.patch
proc-inline-vma_stop-into-m_stop.patch
proc-remove-m_cache_vma.patch
proc-use-ppos-instead-of-m-version.patch
seq_file-remove-m-version.patch
proc-inline-m_next_vma-into-m_next.patch
