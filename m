From: akpm@linux-foundation.org
Subject: + lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged.patch added to -mm tree
Date: Thu, 12 Aug 2010 15:38:47 -0700
Message-ID: <201008122238.o7CMclxQ016748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518Ab0HLWjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 18:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, hch@lst.de, nickpiggin@yahoo.com.au


The patch titled
     lib/radix-tree.c: fix overflow in radix_tree_range_tag_if_tagged()
has been added to the -mm tree.  Its filename is
     lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged.patch

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
Subject: lib/radix-tree.c: fix overflow in radix_tree_range_tag_if_tagged()
From: Jan Kara <jack@suse.cz>

When radix_tree_maxindex() is ~0UL, it can happen that scanning
overflows index and tree traversal code goes astray reading memory
until it hits unreadable memory. Check for overflow and exit in
that case.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/radix-tree.c~lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged
+++ a/lib/radix-tree.c
@@ -675,7 +675,8 @@ unsigned long radix_tree_range_tag_if_ta
 next:
 		/* Go to next item at level determined by 'shift' */
 		index = ((index >> shift) + 1) << shift;
-		if (index > last_index)
+		/* Overflow can happen when last_index is ~0UL... */
+		if (index > last_index || !index)
 			break;
 		if (tagged >= nr_to_tag)
 			break;
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
lib-radix-treec-fix-overflow-in-radix_tree_range_tag_if_tagged.patch
aio-do-not-return-erestartsys-and-friends-from-aio.patch
reiser4.patch

