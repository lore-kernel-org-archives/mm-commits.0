From: akpm@linux-foundation.org
Subject: + rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch added to -mm tree
Date: Thu, 07 Nov 2013 14:16:50 -0800
Message-ID: <527c1152.bEcy4BDvt0I2sa0t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3KGWQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, jack@suse.cz, cody@linux.vnet.ibm.com

Subject: + rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch added to -mm tree
To: cody@linux.vnet.ibm.com,jack@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:16:50 -0800


The patch titled
     Subject: rbtree/test: move rb_node to the middle of the test struct
has been added to the -mm tree.  Its filename is
     rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch

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
Subject: rbtree/test: move rb_node to the middle of the test struct

Avoid making the rb_node the first entry to catch some bugs around NULL
checking the rb_node.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/rbtree_test.c~rbtree-test-move-rb_node-to-the-middle-of-the-test-struct lib/rbtree_test.c
--- a/lib/rbtree_test.c~rbtree-test-move-rb_node-to-the-middle-of-the-test-struct
+++ a/lib/rbtree_test.c
@@ -8,8 +8,8 @@
 #define CHECK_LOOPS 100
 
 struct test_node {
-	struct rb_node rb;
 	u32 key;
+	struct rb_node rb;
 
 	/* following fields used for testing augmented rbtree functionality */
 	u32 val;
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

