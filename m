From: akpm@linux-foundation.org
Subject: [folded] mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-v3.patch removed from -mm tree
Date: Mon, 27 Jun 2011 16:16:23 -0700
Message-ID: <201106272316.p5RNGN2O001330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172Ab1F0XQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jun 2011 19:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-v3
has been removed from the -mm tree.  Its filename was
     mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-v3.patch

This patch was dropped because it was folded into mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback.patch

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
linux-next.patch

