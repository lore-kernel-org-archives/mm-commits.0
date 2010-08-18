From: akpm@linux-foundation.org
Subject: + lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged-update.patch added to -mm tree
Date: Wed, 18 Aug 2010 11:47:18 -0700
Message-ID: <201008181847.o7IIlIHG005840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891Ab0HRSsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 14:48:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, hch@lst.de, nickpiggin@yahoo.com.au


The patch titled
     lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged-update
has been added to the -mm tree.  Its filename is
     lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged-update.patch

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
Subject: lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged-update
From: Jan Kara <jack@suse.cz>

below is an updated version of the fix.  The core of the fix is the same,
it just includes a few more comments updates and a check in
tag_pages_for_writeback() to avoid cycling indefinitely.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c    |    2 ++
 mm/page-writeback.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN lib/radix-tree.c~lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged-update lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged-update
+++ a/lib/radix-tree.c
@@ -625,6 +625,8 @@ EXPORT_SYMBOL(radix_tree_tag_get);
  *
  * The function returns number of leaves where the tag was set and sets
  * *first_indexp to the first unscanned index.
+ * WARNING! *first_indexp can wrap if last_index is ULONG_MAX. Caller must
+ * be prepared to handle that.
  */
 unsigned long radix_tree_range_tag_if_tagged(struct radix_tree_root *root,
 		unsigned long *first_indexp, unsigned long last_index,
diff -puN mm/page-writeback.c~lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged-update mm/page-writeback.c
--- a/mm/page-writeback.c~lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged-update
+++ a/mm/page-writeback.c
@@ -836,7 +836,8 @@ void tag_pages_for_writeback(struct addr
 		spin_unlock_irq(&mapping->tree_lock);
 		WARN_ON_ONCE(tagged > WRITEBACK_TAG_BATCH);
 		cond_resched();
-	} while (tagged >= WRITEBACK_TAG_BATCH);
+		/* We check 'start' to handle wrapping when end == ~0UL */
+	} while (tagged >= WRITEBACK_TAG_BATCH && start);
 }
 EXPORT_SYMBOL(tag_pages_for_writeback);
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged.patch
lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged-update.patch
linux-next.patch
aio-do-not-return-erestartsys-and-friends-from-aio.patch
reiser4.patch

