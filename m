From: akpm@linux-foundation.org
Subject: + testing-radix-tree-fix-a-macro-expansion-bug.patch added to -mm tree
Date: Fri, 15 Jul 2016 14:17:44 -0700
Message-ID: <578952f8.QxGupqgD2+XzXYou%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbcGOVRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2016 17:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: testing/radix-tree: fix a macro expansion bug
has been added to the -mm tree.  Its filename is
     testing-radix-tree-fix-a-macro-expansion-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/testing-radix-tree-fix-a-macro-expansion-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/testing-radix-tree-fix-a-macro-expansion-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: testing/radix-tree: fix a macro expansion bug

There are no parentheses around this macro and it causes a problem when
we do:

	index = rand() % THRASH_SIZE;

Link: http://lkml.kernel.org/r/20160715210953.GC19522@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
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

testing-radix-tree-fix-a-macro-expansion-bug.patch

