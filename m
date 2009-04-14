From: akpm@linux-foundation.org
Subject: [merged] hfs-fix-memory-leak-when-unmounting.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:51 -0700
Message-ID: <200904141948.n3EJmptB019234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbZDNTwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anderson@redhat.com, eugeneteo@kernel.sg, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs: fix memory leak when unmounting
has been removed from the -mm tree.  Its filename was
     hfs-fix-memory-leak-when-unmounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs: fix memory leak when unmounting
From: Dave Anderson <anderson@redhat.com>

When an HFS filesystem is unmounted, it leaks a 2-page bitmap.  Also,
under extreme memory pressure, it's possible that hfs_releasepage() may
use a tree pointer that has not been initialized, and if so, the release
request should just be rejected.

[akpm@linux-foundation.org: free_pages(0) is legal, remove obvious comment]
Signed-off-by: Dave Anderson <anderson@redhat.com>
Tested-by: Eugene Teo <eugeneteo@kernel.sg>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/inode.c |    4 ++++
 fs/hfs/mdb.c   |    1 +
 2 files changed, 5 insertions(+)

diff -puN fs/hfs/inode.c~hfs-fix-memory-leak-when-unmounting fs/hfs/inode.c
--- a/fs/hfs/inode.c~hfs-fix-memory-leak-when-unmounting
+++ a/fs/hfs/inode.c
@@ -70,6 +70,10 @@ static int hfs_releasepage(struct page *
 		BUG();
 		return 0;
 	}
+
+	if (!tree)
+		return 0;
+
 	if (tree->node_size >= PAGE_CACHE_SIZE) {
 		nidx = page->index >> (tree->node_size_shift - PAGE_CACHE_SHIFT);
 		spin_lock(&tree->hash_lock);
diff -puN fs/hfs/mdb.c~hfs-fix-memory-leak-when-unmounting fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-fix-memory-leak-when-unmounting
+++ a/fs/hfs/mdb.c
@@ -349,6 +349,7 @@ void hfs_mdb_put(struct super_block *sb)
 	if (HFS_SB(sb)->nls_disk)
 		unload_nls(HFS_SB(sb)->nls_disk);
 
+	free_pages((unsigned long)HFS_SB(sb)->bitmap, PAGE_SIZE < 8192 ? 1 : 0);
 	kfree(HFS_SB(sb));
 	sb->s_fs_info = NULL;
 }
_

Patches currently in -mm which might be from anderson@redhat.com are

origin.patch

