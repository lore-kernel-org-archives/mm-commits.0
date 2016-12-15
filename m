From: akpm@linux-foundation.org
Subject: [merged]
 idr-reduce-the-number-of-bits-per-level-from-8-to-6.patch removed from -mm
 tree
Date: Thu, 15 Dec 2016 10:49:21 -0800
Message-ID: <5852e5b1.WCkY5s0fevbylgmd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbcLOStW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:49:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: reduce the number of bits per level from 8 to 6
has been removed from the -mm tree.  Its filename was
     idr-reduce-the-number-of-bits-per-level-from-8-to-6.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: idr: reduce the number of bits per level from 8 to 6

In preparation for merging the IDR and radix tree, reduce the fanout at
each level from 256 to 64.  If this causes a performance problem then a
bisect will point to this commit, and we'll have a better idea about what
we might do to fix it.

Link: http://lkml.kernel.org/r/1480369871-5271-66-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN include/linux/idr.h~idr-reduce-the-number-of-bits-per-level-from-8-to-6 include/linux/idr.h
--- a/include/linux/idr.h~idr-reduce-the-number-of-bits-per-level-from-8-to-6
+++ a/include/linux/idr.h
@@ -18,12 +18,11 @@
 #include <linux/rcupdate.h>
 
 /*
- * We want shallower trees and thus more bits covered at each layer.  8
- * bits gives us large enough first layer for most use cases and maximum
- * tree depth of 4.  Each idr_layer is slightly larger than 2k on 64bit and
- * 1k on 32bit.
+ * Using 6 bits at each layer allows us to allocate 7 layers out of each page.
+ * 8 bits only gave us 3 layers out of every pair of pages, which is less
+ * efficient except for trees with a largest element between 192-255 inclusive.
  */
-#define IDR_BITS 8
+#define IDR_BITS 6
 #define IDR_SIZE (1 << IDR_BITS)
 #define IDR_MASK ((1 << IDR_BITS)-1)
 
_

Patches currently in -mm which might be from willy@linux.intel.com are

reimplement-idr-and-ida-using-the-radix-tree.patch

