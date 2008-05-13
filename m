From: akpm@linux-foundation.org
Subject: - fix-hfsplus-oops-on-image-without-extents.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:45 -0700
Message-ID: <200805132133.m4DLXj8t000848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762169AbYEMVd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snakebyte@gmx.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Fix hfsplus oops on image without extents
has been removed from the -mm tree.  Its filename was
     fix-hfsplus-oops-on-image-without-extents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix hfsplus oops on image without extents
From: Eric Sesterhenn <snakebyte@gmx.de>

Fix an oops with a corrupted hfs+ image.

See http://bugzilla.kernel.org/show_bug.cgi?id=10548 for details.

Problem is that we call hfs_btree_open() from hfsplus_fill_super() to set
HFSPLUS_SB(sb).[ext_tree|cat_tree] Both trees are still NULL at this moment. 
If hfs_btree_open() fails for any reason it calls iput() on the page, which
gets to hfsplus_releasepage() which tries to access HFSPLUS_SB(sb).* which is
still NULL and oopses while dereferencing it.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/hfsplus/inode.c~fix-hfsplus-oops-on-image-without-extents fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~fix-hfsplus-oops-on-image-without-extents
+++ a/fs/hfsplus/inode.c
@@ -65,6 +65,8 @@ static int hfsplus_releasepage(struct pa
 		BUG();
 		return 0;
 	}
+	if (!tree)
+		return 0;
 	if (tree->node_size >= PAGE_CACHE_SIZE) {
 		nidx = page->index >> (tree->node_size_shift - PAGE_CACHE_SHIFT);
 		spin_lock(&tree->hash_lock);
_

Patches currently in -mm which might be from snakebyte@gmx.de are

origin.patch
linux-next.patch

