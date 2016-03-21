From: akpm@linux-foundation.org
Subject: [merged] radix-tree-add-an-explicit-include-of-bitopsh.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:31 -0700
Message-ID: <56f0405b.TRFrFQ5umZ3G/bgV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757753AbcCUTVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: add an explicit include of bitops.h
has been removed from the -mm tree.  Its filename was
     radix-tree-add-an-explicit-include-of-bitopsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: add an explicit include of bitops.h

The radix-tree header uses the __ffs() function, which is defined in
bitops.h.  The current kernel headers implicitly include bitops.h, but the
userspace test harness does not.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/radix-tree.h~radix-tree-add-an-explicit-include-of-bitopsh include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-add-an-explicit-include-of-bitopsh
+++ a/include/linux/radix-tree.h
@@ -21,6 +21,7 @@
 #ifndef _LINUX_RADIX_TREE_H
 #define _LINUX_RADIX_TREE_H
 
+#include <linux/bitops.h>
 #include <linux/preempt.h>
 #include <linux/types.h>
 #include <linux/bug.h>
_

Patches currently in -mm which might be from willy@linux.intel.com are


