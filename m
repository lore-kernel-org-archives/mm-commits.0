From: akpm@linux-foundation.org
Subject: + rbtree_test-add-test-for-postorder-iteration.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:43:57 -0700
Message-ID: <51f6f02d.Fg3zugn6H6ui/Jb/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3G2Wn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:43:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, sjenning@linux.vnet.ibm.com, riel@redhat.com, David.Woodhouse@intel.com, cody@linux.vnet.ibm.com

Subject: + rbtree_test-add-test-for-postorder-iteration.patch added to -mm tree
To: cody@linux.vnet.ibm.com,David.Woodhouse@intel.com,riel@redhat.com,sjenning@linux.vnet.ibm.com,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:43:57 -0700


The patch titled
     Subject: rbtree_test: add test for postorder iteration
has been added to the -mm tree.  Its filename is
     rbtree_test-add-test-for-postorder-iteration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree_test-add-test-for-postorder-iteration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree_test-add-test-for-postorder-iteration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: rbtree_test: add test for postorder iteration

Just check that we examine all nodes in the tree for the postorder
iteration.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree_test.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN lib/rbtree_test.c~rbtree_test-add-test-for-postorder-iteration lib/rbtree_test.c
--- a/lib/rbtree_test.c~rbtree_test-add-test-for-postorder-iteration
+++ a/lib/rbtree_test.c
@@ -114,6 +114,16 @@ static int black_path_count(struct rb_no
 	return count;
 }
 
+static void check_postorder(int nr_nodes)
+{
+	struct rb_node *rb;
+	int count = 0;
+	for (rb = rb_first_postorder(&root); rb; rb = rb_next_postorder(rb))
+		count++;
+
+	WARN_ON_ONCE(count != nr_nodes);
+}
+
 static void check(int nr_nodes)
 {
 	struct rb_node *rb;
@@ -136,6 +146,8 @@ static void check(int nr_nodes)
 
 	WARN_ON_ONCE(count != nr_nodes);
 	WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
+
+	check_postorder(nr_nodes);
 }
 
 static void check_augmented(int nr_nodes)
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint.patch
rbtree-add-postorder-iteration-functions.patch
rbtree-add-rbtree_postorder_for_each_entry_safe-helper.patch
rbtree_test-add-test-for-postorder-iteration.patch
rbtree-allow-tests-to-run-as-builtin.patch
mm-zswap-use-postorder-iteration-when-destroying-rbtree.patch

