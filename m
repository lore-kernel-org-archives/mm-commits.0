From: akpm@linux-foundation.org
Subject: [merged] mm-remove-useless-rcu-lock-unlock-from-mapping_tagged.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:36 -0700
Message-ID: <201107260752.p6Q7qd2A003148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112Ab1GZHxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove useless rcu lock-unlock from mapping_tagged()
has been removed from the -mm tree.  Its filename was
     mm-remove-useless-rcu-lock-unlock-from-mapping_tagged.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove useless rcu lock-unlock from mapping_tagged()
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

radix_tree_tagged() is lockless - it reads from a member of the raid-tree
root node.  It does not require any protection.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN mm/page-writeback.c~mm-remove-useless-rcu-lock-unlock-from-mapping_tagged mm/page-writeback.c
--- a/mm/page-writeback.c~mm-remove-useless-rcu-lock-unlock-from-mapping_tagged
+++ a/mm/page-writeback.c
@@ -1405,10 +1405,6 @@ EXPORT_SYMBOL(test_set_page_writeback);
  */
 int mapping_tagged(struct address_space *mapping, int tag)
 {
-	int ret;
-	rcu_read_lock();
-	ret = radix_tree_tagged(&mapping->page_tree, tag);
-	rcu_read_unlock();
-	return ret;
+	return radix_tree_tagged(&mapping->page_tree, tag);
 }
 EXPORT_SYMBOL(mapping_tagged);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch

