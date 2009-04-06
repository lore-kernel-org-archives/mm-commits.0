From: akpm@linux-foundation.org
Subject: [merged] vfs-check-bh-b_blocknr-only-if-bh_mapped-is-set.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:43 -0700
Message-ID: <200904061932.n36JWhoU010806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbZDFTeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:34:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     vfs: check bh->b_blocknr only if BH_Mapped is set
has been removed from the -mm tree.  Its filename was
     vfs-check-bh-b_blocknr-only-if-bh_mapped-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: check bh->b_blocknr only if BH_Mapped is set
From: Nikanth Karthikesan <knikanth@suse.de>

Check bh->b_blocknr only if BH_Mapped is set.

akpm: I doubt if b_blocknr is ever uninitialised here, but it could
conceivably cause a problem if we're doing a lookup for block zero.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/buffer.c~vfs-check-bh-b_blocknr-only-if-bh_mapped-is-set fs/buffer.c
--- a/fs/buffer.c~vfs-check-bh-b_blocknr-only-if-bh_mapped-is-set
+++ a/fs/buffer.c
@@ -199,13 +199,13 @@ __find_get_block_slow(struct block_devic
 	head = page_buffers(page);
 	bh = head;
 	do {
-		if (bh->b_blocknr == block) {
+		if (!buffer_mapped(bh))
+			all_mapped = 0;
+		else if (bh->b_blocknr == block) {
 			ret = bh;
 			get_bh(bh);
 			goto out_unlock;
 		}
-		if (!buffer_mapped(bh))
-			all_mapped = 0;
 		bh = bh->b_this_page;
 	} while (bh != head);
 
_

Patches currently in -mm which might be from knikanth@suse.de are

origin.patch
linux-next.patch

