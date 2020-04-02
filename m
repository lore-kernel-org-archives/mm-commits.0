From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 085/155] mm: add pagemap.h to the fine
 documentation
Date: Wed, 01 Apr 2020 21:07:55 -0700
Message-ID: <20200402040755.JN2fCFDn2%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDBEH6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:07:58 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, jhubbard@nvidia.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org, ziy@nvidia.com

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
