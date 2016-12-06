From: akpm@linux-foundation.org
Subject: + idr-reduce-the-number-of-bits-per-level-from-8-to-6.patch added to -mm tree
Date: Tue, 06 Dec 2016 12:51:18 -0800
Message-ID: <584724c6.VrkpKUS04ougsC9I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37082 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752262AbcLFUut (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:50:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: reduce the number of bits per level from 8 to 6
has been added to the -mm tree.  Its filename is
     idr-reduce-the-number-of-bits-per-level-from-8-to-6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-reduce-the-number-of-bits-per-level-from-8-to-6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-reduce-the-number-of-bits-per-level-from-8-to-6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-add-warn_on_once.patch
radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail.patch
tools-add-more-bitmap-functions.patch
radix-tree-test-suite-use-common-find-bit-code.patch
radix-tree-fix-typo.patch
radix-tree-create-node_tag_set.patch
radix-tree-make-radix_tree_find_next_bit-more-useful.patch
radix-tree-add-radix_tree_join.patch
radix-tree-add-radix_tree_split.patch
radix-tree-add-radix_tree_split_preload.patch
idr-add-ida_is_empty.patch
idr-reduce-the-number-of-bits-per-level-from-8-to-6.patch
radix-tree-test-suite-add-some-more-functionality.patch
reimplement-idr-and-ida-using-the-radix-tree.patch

