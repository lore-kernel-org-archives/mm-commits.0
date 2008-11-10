From: akpm@linux-foundation.org
Subject: - fat-fix-_fat_bmap-race.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:39 -0800
Message-ID: <200811102033.mAAKXdQ7024613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169AbYKJUgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:36:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Fix _fat_bmap() race
has been removed from the -mm tree.  Its filename was
     fat-fix-_fat_bmap-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Fix _fat_bmap() race
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

fat_get_cluster() assumes the requested blocknr isn't truncated during
read. _fat_bmap() doesn't follow this rule.

This protects it by ->i_mutex.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-fix-_fat_bmap-race fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-_fat_bmap-race
+++ a/fs/fat/inode.c
@@ -199,7 +199,14 @@ static ssize_t fat_direct_IO(int rw, str
 
 static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
 {
-	return generic_block_bmap(mapping, block, fat_get_block);
+	sector_t blocknr;
+
+	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
+	mutex_lock(&mapping->host->i_mutex);
+	blocknr = generic_block_bmap(mapping, block, fat_get_block);
+	mutex_unlock(&mapping->host->i_mutex);
+
+	return blocknr;
 }
 
 static const struct address_space_operations fat_aops = {
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

