From: akpm@linux-foundation.org
Subject: [merged] omfs-fix-sign-confusion-for-bitmap-loop-counter.patch
 removed from -mm tree
Date: Mon, 01 Jun 2015 12:16:00 -0700
Message-ID: <556caf70.9q7RTBEMG3e5ZNaK%akpm__5483.75387811593$1433186184$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbFATQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2015 15:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@bobcopeland.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: omfs: fix sign confusion for bitmap loop counter
has been removed from the -mm tree.  Its filename was
     omfs-fix-sign-confusion-for-bitmap-loop-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Copeland <me@bobcopeland.com>
Subject: omfs: fix sign confusion for bitmap loop counter

The count variable is used to iterate down to (below) zero from the size
of the bitmap and handle the one-filling the remainder of the last partial
bitmap block.  The loop conditional expects count to be signed in order to
detect when the final block is processed, after which count goes negative.

Unfortunately, a recent change made this unsigned along with some other
related fields.  The result of is this is that during mount, omfs_get_imap
will overrun the bitmap array and corrupt memory unless number of blocks
happens to be a multiple of 8 * blocksize.

Fix by changing count back to signed: it is guaranteed to fit in an s32
without overflow due to an enforced limit on the number of blocks in the
filesystem.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/omfs/inode.c~omfs-fix-sign-confusion-for-bitmap-loop-counter fs/omfs/inode.c
--- a/fs/omfs/inode.c~omfs-fix-sign-confusion-for-bitmap-loop-counter
+++ a/fs/omfs/inode.c
@@ -306,7 +306,8 @@ static const struct super_operations omf
  */
 static int omfs_get_imap(struct super_block *sb)
 {
-	unsigned int bitmap_size, count, array_size;
+	unsigned int bitmap_size, array_size;
+	int count;
 	struct omfs_sb_info *sbi = OMFS_SB(sb);
 	struct buffer_head *bh;
 	unsigned long **ptr;
_

Patches currently in -mm which might be from me@bobcopeland.com are

linux-next.patch

