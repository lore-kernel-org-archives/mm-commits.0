From: akpm@linux-foundation.org
Subject: + radix-tree-fix-radix_tree_prev_hole-underflow-case.patch added to -mm tree
Date: Fri, 14 May 2010 11:00:38 -0700
Message-ID: <201005141800.o4EI0cL5013635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758786Ab0ENSAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 May 2010 14:00:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, fengguang.wu@intel.com


The patch titled
     radix-tree: fix radix_tree_prev_hole() underflow case
has been added to the -mm tree.  Its filename is
     radix-tree-fix-radix_tree_prev_hole-underflow-case.patch

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
Subject: radix-tree: fix radix_tree_prev_hole() underflow case
From: Cesar Eduardo Barros <cesarb@cesarb.net>

radix_tree_prev_hole() used LONG_MAX to detect underflow; however,
ULONG_MAX is clearly what was intended, both here and by its only user
(count_history_pages at mm/readahead.c).

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-radix_tree_prev_hole-underflow-case lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-radix_tree_prev_hole-underflow-case
+++ a/lib/radix-tree.c
@@ -656,7 +656,7 @@ EXPORT_SYMBOL(radix_tree_next_hole);
  *
  *	Returns: the index of the hole if found, otherwise returns an index
  *	outside of the set specified (in which case 'index - return >= max_scan'
- *	will be true). In rare cases of wrap-around, LONG_MAX will be returned.
+ *	will be true). In rare cases of wrap-around, ULONG_MAX will be returned.
  *
  *	radix_tree_next_hole may be called under rcu_read_lock. However, like
  *	radix_tree_gang_lookup, this will not atomically search a snapshot of
@@ -674,7 +674,7 @@ unsigned long radix_tree_prev_hole(struc
 		if (!radix_tree_lookup(root, index))
 			break;
 		index--;
-		if (index == LONG_MAX)
+		if (index == ULONG_MAX)
 			break;
 	}
 
_

Patches currently in -mm which might be from cesarb@cesarb.net are

radix-tree-fix-radix_tree_prev_hole-underflow-case.patch

