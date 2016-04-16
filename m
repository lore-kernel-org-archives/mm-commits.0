From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-allow-testing-other-fan-out-values.patch
 added to -mm tree
Date: Fri, 15 Apr 2016 22:58:02 -0700
Message-ID: <5711d46a.WTI4pZvdlWfMf1KN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcDPF6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: allow testing other fan-out values
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-allow-testing-other-fan-out-values.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-allow-testing-other-fan-out-values.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-allow-testing-other-fan-out-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
