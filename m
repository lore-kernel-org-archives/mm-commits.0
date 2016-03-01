From: akpm@linux-foundation.org
Subject: + radix-tree-test-harness-fix.patch added to -mm tree
Date: Tue, 01 Mar 2016 13:09:02 -0800
Message-ID: <56d604ee.Zd1mc1GLW+JdRWah%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbcCAVJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 16:09:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree tests: fix compilation
has been added to the -mm tree.  Its filename is
     radix-tree-test-harness-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-harness-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-harness-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: radix-tree tests: fix compilation

Couple GFP flags and empty header linux/init.h

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/gfp.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN tools/testing/radix-tree/linux/gfp.h~radix-tree-test-harness-fix tools/testing/radix-tree/linux/gfp.h
--- a/tools/testing/radix-tree/linux/gfp.h~radix-tree-test-harness-fix
+++ a/tools/testing/radix-tree/linux/gfp.h
@@ -4,5 +4,7 @@
 #define __GFP_BITS_SHIFT 22
 #define __GFP_BITS_MASK ((gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 #define __GFP_WAIT 1
+#define __GFP_ACCOUNT 0
+#define __GFP_NOWARN 0
 
 #endif
_

Patches currently in -mm which might be from koct9i@gmail.com are

tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering.patch
radix-tree-test-harness-fix.patch
radix-treeshmem-introduce-radix_tree_iter_next-fix.patch
radix-tree-tests-add-test-for-radix_tree_iter_next.patch
radix-tree-tests-add-regression3-test.patch

