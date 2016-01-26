From: akpm@linux-foundation.org
Subject: + radix-tree-add-an-explicit-include-of-bitopsh.patch added to
 -mm tree
Date: Tue, 26 Jan 2016 15:31:04 -0800
Message-ID: <56a801b8.KJOiYpwC/K/YCnvv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbcAZXbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 18:31:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: add an explicit include of bitops.h
has been added to the -mm tree.  Its filename is
     radix-tree-add-an-explicit-include-of-bitopsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-add-an-explicit-include-of-bitopsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-add-an-explicit-include-of-bitopsh.patch

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

radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix-tree-cleanups.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch

