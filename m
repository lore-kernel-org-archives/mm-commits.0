From: akpm@linux-foundation.org
Subject: [patch 102/162] radix tree test suite: allow testing other
 fan-out values
Date: Fri, 20 May 2016 17:01:42 -0700
Message-ID: <573fa566.ySdtkimPvYhsCzN1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbcEUABn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix tree test suite: allow testing other fan-out values

The defines in regression2.c are already in radix-tree.h and duplicating
them in the test case makes experimenting with other values for the
fan-out harder than necessary.  Allow the user of the radix tree to decide
what the fan-out should be rather than fixing it to 8 for non-kernel uses.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h              |    4 +---
 tools/testing/radix-tree/linux/kernel.h |    2 ++
 tools/testing/radix-tree/regression2.c  |    7 -------
 3 files changed, 3 insertions(+), 10 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-test-suite-allow-testing-other-fan-out-values include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-test-suite-allow-testing-other-fan-out-values
+++ a/include/linux/radix-tree.h
@@ -70,10 +70,8 @@ static inline int radix_tree_is_indirect
 
 #define RADIX_TREE_MAX_TAGS 3
 
-#ifdef __KERNEL__
+#ifndef RADIX_TREE_MAP_SHIFT
 #define RADIX_TREE_MAP_SHIFT	(CONFIG_BASE_SMALL ? 4 : 6)
-#else
-#define RADIX_TREE_MAP_SHIFT	3	/* For more stressful testing */
 #endif
 
 #define RADIX_TREE_MAP_SIZE	(1UL << RADIX_TREE_MAP_SHIFT)
diff -puN tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-allow-testing-other-fan-out-values tools/testing/radix-tree/linux/kernel.h
--- a/tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-allow-testing-other-fan-out-values
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -12,6 +12,8 @@
 #define CONFIG_SHMEM
 #define CONFIG_SWAP
 
+#define RADIX_TREE_MAP_SHIFT	3
+
 #ifndef NULL
 #define NULL	0
 #endif
diff -puN tools/testing/radix-tree/regression2.c~radix-tree-test-suite-allow-testing-other-fan-out-values tools/testing/radix-tree/regression2.c
--- a/tools/testing/radix-tree/regression2.c~radix-tree-test-suite-allow-testing-other-fan-out-values
+++ a/tools/testing/radix-tree/regression2.c
@@ -51,13 +51,6 @@
 
 #include "regression.h"
 
-#ifdef __KERNEL__
-#define RADIX_TREE_MAP_SHIFT    (CONFIG_BASE_SMALL ? 4 : 6)
-#else
-#define RADIX_TREE_MAP_SHIFT    3       /* For more stressful testing */
-#endif
