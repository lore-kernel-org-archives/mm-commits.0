From: akpm@linux-foundation.org
Subject: + hfs-fix-memory-leak-when-unmounting.patch added to -mm tree
Date: Tue, 07 Apr 2009 14:00:52 -0700
Message-ID: <200904072100.n37L0q3I026557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759330AbZDGVPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 17:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anderson@redhat.com, eugeneteo@kernel.sg, zippel@linux-m68k.org


The patch titled
     hfs: fix memory leak when unmounting
has been added to the -mm tree.  Its filename is
     hfs-fix-memory-leak-when-unmounting.patch

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
Subject: hfs: fix memory leak when unmounting
From: Dave Anderson <anderson@redhat.com>

When an HFS filesystem is unmounted, it leaks a 2-page bitmap.  Also,
under extreme memory pressure, it's possible that hfs_releasepage() may
use a tree pointer that has not been initialized, and if so, the release
request should just be rejected.

Signed-off-by: Dave Anderson <anderson@redhat.com>
Tested-by: Eugene Teo <eugeneteo@kernel.sg>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/inode.c |    4 ++++
 fs/hfs/mdb.c   |    4 ++++
 2 files changed, 8 insertions(+)

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
@@ -349,6 +349,10 @@ void hfs_mdb_put(struct super_block *sb)
 	if (HFS_SB(sb)->nls_disk)
 		unload_nls(HFS_SB(sb)->nls_disk);
 
+	/* free the bitmap page(s) */
+	if (HFS_SB(sb)->bitmap)
+		free_pages((unsigned long)HFS_SB(sb)->bitmap, PAGE_SIZE < 8192 ? 1 : 0);
+
 	kfree(HFS_SB(sb));
 	sb->s_fs_info = NULL;
 }
_

Patches currently in -mm which might be from anderson@redhat.com are

hfs-fix-memory-leak-when-unmounting.patch

