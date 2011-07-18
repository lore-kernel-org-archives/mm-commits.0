From: akpm@linux-foundation.org
Subject: + mm-remove-useless-rcu-lock-unlock-from-mapping_tagged.patch added to -mm tree
Date: Mon, 18 Jul 2011 13:22:25 -0700
Message-ID: <201107182022.p6IKMPNT025648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab1GRUWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jul 2011 16:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com


The patch titled
     mm: remove useless rcu lock-unlock from mapping_tagged()
has been added to the -mm tree.  Its filename is
     mm-remove-useless-rcu-lock-unlock-from-mapping_tagged.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1611,10 +1611,6 @@ EXPORT_SYMBOL(test_set_page_writeback);
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

mm-remove-useless-rcu-lock-unlock-from-mapping_tagged.patch

