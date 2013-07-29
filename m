From: akpm@linux-foundation.org
Subject: + rbtree-add-rbtree_postorder_for_each_entry_safe-helper.patch
 added to -mm tree
Date: Mon, 29 Jul 2013 15:43:56 -0700
Message-ID: <51f6f02c.do1oTihNp5xvwjSy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3G2Wn5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:43:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, sjenning@linux.vnet.ibm.com, riel@redhat.com, David.Woodhouse@intel.com, cody@linux.vnet.ibm.com

Subject: + rbtree-add-rbtree_postorder_for_each_entry_safe-helper.patch added to -mm tree
To: cody@linux.vnet.ibm.com,David.Woodhouse@intel.com,riel@redhat.com,sjenning@linux.vnet.ibm.com,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:43:56 -0700


The patch titled
     Subject: rbtree: add rbtree_postorder_for_each_entry_safe() helper
has been added to the -mm tree.  Its filename is
     rbtree-add-rbtree_postorder_for_each_entry_safe-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-add-rbtree_postorder_for_each_entry_safe-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-add-rbtree_postorder_for_each_entry_safe-helper.patch

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
Subject: rbtree: add rbtree_postorder_for_each_entry_safe() helper

Because deletion (of the entire tree) is a relatively common use of the
rbtree_postorder iteration, and because doing it safely means fiddling
with temporary storage, provide a helper to simplify postorder rbtree
iteration.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN include/linux/rbtree.h~rbtree-add-rbtree_postorder_for_each_entry_safe-helper include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-add-rbtree_postorder_for_each_entry_safe-helper
+++ a/include/linux/rbtree.h
@@ -85,4 +85,22 @@ static inline void rb_link_node(struct r
 	*rb_link = node;
 }
 
+/**
+ * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
+ * given type safe against removal of rb_node entry
+ *
+ * @pos:	the 'type *' to use as a loop cursor.
+ * @n:		another 'type *' to use as temporary storage
+ * @root:	'rb_root *' of the rbtree.
+ * @field:	the name of the rb_node field within 'type'.
+ */
+#define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
+	for (pos = rb_entry(rb_first_postorder(root), typeof(*pos), field),\
+		n = rb_entry(rb_next_postorder(&pos->field), \
+			typeof(*pos), field); \
+	     &pos->field; \
+	     pos = n, \
+		n = rb_entry(rb_next_postorder(&pos->field), \
+			typeof(*pos), field))
+
 #endif	/* _LINUX_RBTREE_H */
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

