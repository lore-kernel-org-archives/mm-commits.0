From: akpm@linux-foundation.org
Subject: +
 hwspinlock-fix-race-between-radix-tree-insertion-and-lookup.patch added to
 -mm tree
Date: Wed, 27 Jan 2016 13:34:55 -0800
Message-ID: <56a937ff.TWVZgO1Z+GQf1j9n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934563AbcA0Ve4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 16:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hughd@google.com, khlebnikov@openvz.org, ohad@wizery.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/hwspinlock: fix race between radix tree insertion and lookup
has been added to the -mm tree.  Its filename is
     hwspinlock-fix-race-between-radix-tree-insertion-and-lookup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwspinlock-fix-race-between-radix-tree-insertion-and-lookup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwspinlock-fix-race-between-radix-tree-insertion-and-lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: drivers/hwspinlock: fix race between radix tree insertion and lookup

of_hwspin_lock_get_id() is protected by the RCU lock, which means that
insertions can occur simultaneously with the lookup.  If the radix tree
transitions from a height of 0, we can see a slot with the indirect_ptr
bit set, which will cause us to at least read random memory, and could
cause other havoc.

Fix this by using the newly introduced radix_tree_iter_retry().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwspinlock/hwspinlock_core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/hwspinlock/hwspinlock_core.c~hwspinlock-fix-race-between-radix-tree-insertion-and-lookup drivers/hwspinlock/hwspinlock_core.c
--- a/drivers/hwspinlock/hwspinlock_core.c~hwspinlock-fix-race-between-radix-tree-insertion-and-lookup
+++ a/drivers/hwspinlock/hwspinlock_core.c
@@ -313,6 +313,10 @@ int of_hwspin_lock_get_id(struct device_
 		hwlock = radix_tree_deref_slot(slot);
 		if (unlikely(!hwlock))
 			continue;
+		if (radix_tree_is_indirect_ptr(hwlock)) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
 
 		if (hwlock->bank->dev->of_node == args.np) {
 			ret = 0;
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-fix-race-in-gang-lookup.patch
hwspinlock-fix-race-between-radix-tree-insertion-and-lookup.patch
radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch

