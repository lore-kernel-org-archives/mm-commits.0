From: akpm@linux-foundation.org
Subject: + mm-add-pagemaph-to-the-fine-documentation.patch added
 to -mm tree
Date: Mon, 02 Mar 2020 14:55:34 -0800
Message-ID: <20200302225534.DF3J4d41Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgCBWzf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:55:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, jhubbard@nvidia.com, mm-commits@vger.kernel.org, willy@infradead.org, ziy@nvidia.com


The patch titled
     Subject: mm: add pagemap.h to the fine documentation
has been added to the -mm tree.  Its filename is
     mm-add-pagemaph-to-the-fine-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-pagemaph-to-the-fine-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-pagemaph-to-the-fine-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -305,9 +305,9 @@ static inline struct page *find_lock_pag
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

mm-improve-dump_page-for-compound-pages.patch
mm-add-pagemaph-to-the-fine-documentation.patch
