From: akpm@linux-foundation.org
Subject: [patch 046/111] radix-tree: fix comment about "exceptional" bits
Date: Tue, 02 Aug 2016 14:04:19 -0700
Message-ID: <57a10ad3.PHv6oWCSmV8YACq4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366AbcHBVQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, david@fromorbit.com, jack@suse.com, jthumshirn@suse.de, koct9i@gmail.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree: fix comment about "exceptional" bits

The bottom two bits of radix tree entries are reserved for special use by
the radix tree code itself.  A comment detailing their usage was added by:

commit 3bcadd6fa6c4 ("radix-tree: free up the bottom bit of exceptional
entries for reuse")

This comment states that if the bottom two bits are '11', this means that
this is a locked exceptional entry.

It turns out that this bit combination was never actually used.  Radix tree
locking for DAX was indeed implemented, but it actually used the third LSB:

  /* We use lowest available exceptional entry bit for locking */
  #define RADIX_DAX_ENTRY_LOCK (1 << RADIX_TREE_EXCEPTIONAL_SHIFT)

This locking code was also made specific to the DAX code instead of being
generally implemented in radix-tree.h.

So, fix the comment.

Link: http://lkml.kernel.org/r/1468997731-2155-1-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/radix-tree.h~radix-tree-fix-comment-about-exceptional-bits include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-fix-comment-about-exceptional-bits
+++ a/include/linux/radix-tree.h
@@ -35,7 +35,7 @@
  * 00 - data pointer
  * 01 - internal entry
  * 10 - exceptional entry
- * 11 - locked exceptional entry
+ * 11 - this bit combination is currently unused/reserved
  *
  * The internal entry may be a pointer to the next level in the tree, a
  * sibling entry, or an indicator that the entry in this slot has been moved
_
