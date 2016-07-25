From: akpm@linux-foundation.org
Subject: [merged] testing-radix-tree-fix-a-macro-expansion-bug.patch
 removed from -mm tree
Date: Mon, 25 Jul 2016 12:05:12 -0700
Message-ID: <579662e8.2G4KdjCPw+vvursD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbcGYTFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 15:05:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: testing/radix-tree: fix a macro expansion bug
has been removed from the -mm tree.  Its filename was
     testing-radix-tree-fix-a-macro-expansion-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: testing/radix-tree: fix a macro expansion bug

There are no parentheses around this macro and it causes a problem when
we do:

	index = rand() % THRASH_SIZE;

Link: http://lkml.kernel.org/r/20160715210953.GC19522@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/tag_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/radix-tree/tag_check.c~testing-radix-tree-fix-a-macro-expansion-bug tools/testing/radix-tree/tag_check.c
--- a/tools/testing/radix-tree/tag_check.c~testing-radix-tree-fix-a-macro-expansion-bug
+++ a/tools/testing/radix-tree/tag_check.c
@@ -122,7 +122,7 @@ enum {
 	NODE_TAGGED = 2,
 };
 
-#define THRASH_SIZE		1000 * 1000
+#define THRASH_SIZE		(1000 * 1000)
 #define N 127
 #define BATCH	33
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are


