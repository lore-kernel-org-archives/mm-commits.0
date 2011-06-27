From: akpm@linux-foundation.org
Subject: + mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-v3.patch added to -mm tree
Date: Mon, 27 Jun 2011 14:43:58 -0700
Message-ID: <201106272143.p5RLhwfb028929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542Ab1F0VoB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jun 2011 17:44:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-v3
has been added to the -mm tree.  Its filename is
     mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-v3.patch

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
Subject: mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-v3
From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/inode.c~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-v3 fs/inode.c
--- a/fs/inode.c~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-v3
+++ a/fs/inode.c
@@ -428,9 +428,9 @@ void end_writeback(struct inode *inode)
 	 * process of removing the last page (in __delete_from_page_cache())
 	 * and we must not free mapping under it.
 	 */
-	spin_lock(&inode->i_data.tree_lock);
+	spin_lock_irq(&inode->i_data.tree_lock);
 	BUG_ON(inode->i_data.nrpages);
-	spin_unlock(&inode->i_data.tree_lock);
+	spin_unlock_irq(&inode->i_data.tree_lock);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback.patch
mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-v3.patch
linux-next.patch

