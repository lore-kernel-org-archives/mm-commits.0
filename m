From: akpm@linux-foundation.org
Subject: + rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
 added to -mm tree
Date: Thu, 07 Nov 2013 14:16:51 -0800
Message-ID: <527c1153.cI7QofwhQC4Wbr6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab3KGWQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:16:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, jack@suse.cz, cody@linux.vnet.ibm.com

Subject: + rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch added to -mm tree
To: cody@linux.vnet.ibm.com,jack@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:16:51 -0800


The patch titled
     Subject: rbtree/test: test rbtree_postorder_for_each_entry_safe()
has been added to the -mm tree.  Its filename is
     rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch

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
Subject: rbtree/test: test rbtree_postorder_for_each_entry_safe()

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree_test.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN lib/rbtree_test.c~rbtree-test-test-rbtree_postorder_for_each_entry_safe lib/rbtree_test.c
--- a/lib/rbtree_test.c~rbtree-test-test-rbtree_postorder_for_each_entry_safe
+++ a/lib/rbtree_test.c
@@ -114,6 +114,16 @@ static int black_path_count(struct rb_no
 	return count;
 }
 
+static void check_postorder_foreach(int nr_nodes)
+{
+	struct test_node *cur, *n;
+	int count = 0;
+	rbtree_postorder_for_each_entry_safe(cur, n, &root, rb)
+		count++;
+
+	WARN_ON_ONCE(count != nr_nodes);
+}
+
 static void check_postorder(int nr_nodes)
 {
 	struct rb_node *rb;
@@ -148,6 +158,7 @@ static void check(int nr_nodes)
 	WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
 
 	check_postorder(nr_nodes);
+	check_postorder_foreach(nr_nodes);
 }
 
 static void check_augmented(int nr_nodes)
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

bitops-find-clarify-and-extend-documentation.patch
linux-next.patch
rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch
rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch

