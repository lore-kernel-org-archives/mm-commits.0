From: akpm@linux-foundation.org
Subject: + rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch
 added to -mm tree
Date: Thu, 07 Nov 2013 14:16:48 -0800
Message-ID: <527c1150.vmKu0lA9VdN3+AT2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3KGWQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:16:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tytso@mit.edu, pablo@netfilter.org, lethal@linux-sh.org, kadlec@blackhole.kfki.hu, kaber@trash.net, dwmw2@infradead.org, dedekind1@gmail.com, davem@davemloft.net, cody@linux.vnet.ibm.com, adrian.hunter@intel.com, jack@suse.cz

Subject: + rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch added to -mm tree
To: jack@suse.cz,adrian.hunter@intel.com,cody@linux.vnet.ibm.com,davem@davemloft.net,dedekind1@gmail.com,dwmw2@infradead.org,kaber@trash.net,kadlec@blackhole.kfki.hu,lethal@linux-sh.org,pablo@netfilter.org,tytso@mit.edu,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:16:48 -0800


The patch titled
     Subject: rbtree: fix rbtree_postorder_for_each_entry_safe() iterator
has been added to the -mm tree.  Its filename is
     rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: rbtree: fix rbtree_postorder_for_each_entry_safe() iterator

The iterator rbtree_postorder_for_each_entry_safe() relies on pointer
underflow behavior when testing for loop termination.  In particular it
expects that

  &rb_entry(NULL, type, field)->field

is NULL.  But the result of this expression is not defined by a C standard
and some gcc versions (e.g.  4.3.4) assume the above expression can never
be equal to NULL.  The net result is an oops because the iteration is not
properly terminated.

Fix the problem by modifying the iterator to avoid pointer underflows.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/rbtree.h~rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator
+++ a/include/linux/rbtree.h
@@ -85,6 +85,11 @@ static inline void rb_link_node(struct r
 	*rb_link = node;
 }
 
+#define rb_entry_safe(ptr, type, member) \
+	({ typeof(ptr) ____ptr = (ptr); \
+	   ____ptr ? rb_entry(____ptr, type, member) : NULL; \
+	})
+
 /**
  * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
  * given type safe against removal of rb_node entry
@@ -95,12 +100,9 @@ static inline void rb_link_node(struct r
  * @field:	the name of the rb_node field within 'type'.
  */
 #define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
-	for (pos = rb_entry(rb_first_postorder(root), typeof(*pos), field),\
-		n = rb_entry(rb_next_postorder(&pos->field), \
-			typeof(*pos), field); \
-	     &pos->field; \
-	     pos = n, \
-		n = rb_entry(rb_next_postorder(&pos->field), \
-			typeof(*pos), field))
+	for (pos = rb_entry_safe(rb_first_postorder(root), typeof(*pos), field); \
+	     pos && ({ n = rb_entry_safe(rb_next_postorder(&pos->field), \
+			typeof(*pos), field); 1; }); \
+	     pos = n)
 
 #endif	/* _LINUX_RBTREE_H */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
ocfs2-dont-spam-on-edquot.patch
writeback-do-not-sync-data-dirtied-after-sync-start.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix-3.patch
linux-next.patch
revert-softirq-add-support-for-triggering-softirq-work-on-softirqs.patch
kernel-remove-config_use_generic_smp_helpers.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
kernel-fix-generic_exec_single-indication.patch
llists-move-llist_reverse_order-from-raid5-to-llistc.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
blk-mq-use-__smp_call_function_single-directly.patch
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

