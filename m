From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch removed
 from -mm tree
Date: Wed, 15 Nov 2017 17:05:44 -0800
Message-ID: <5a0ce468.dSoSHkXRQYwbhfe4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932186AbdKPBFp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:05:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-batch-radix-tree-operations-when-truncating-pages-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch

This patch was dropped because it was folded into mm-batch-radix-tree-operations-when-truncating-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-batch-radix-tree-operations-when-truncating-pages-fix-fix

move struct pagevec forward declaration to top-of-file

To avoid possible duplication in the future.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/pagemap.h~mm-batch-radix-tree-operations-when-truncating-pages-fix-fix include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-batch-radix-tree-operations-when-truncating-pages-fix-fix
+++ a/include/linux/pagemap.h
@@ -16,6 +16,8 @@
 #include <linux/hardirq.h> /* for in_interrupt() */
 #include <linux/hugetlb_inline.h>
 
+struct pagevec;
+
 /*
  * Bits in mapping->flags.
  */
@@ -617,8 +619,6 @@ static inline int fault_in_pages_readabl
 	return 0;
 }
 
-struct pagevec;
