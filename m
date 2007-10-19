From: akpm@linux-foundation.org
Subject: - reiserfs-fix-memset-byte-count-during-resize.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:49:48 -0700
Message-ID: <200710192249.l9JMnmUL024004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34108 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763598AbXJSXFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix memset byte count during resize
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-memset-byte-count-during-resize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: fix memset byte count during resize
From: Jeff Mahoney <jeffm@suse.com>

Correct the memset in reiserfs_resize to clear the memory allocated for the
new bitmap info structs.  Previously, it would clear the memory used by the
old size.  Depending on the contents of memory, this could cause incorrect
caching behavior for bitmap blocks in the newly allocated area.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/resize.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/resize.c~reiserfs-fix-memset-byte-count-during-resize fs/reiserfs/resize.c
--- a/fs/reiserfs/resize.c~reiserfs-fix-memset-byte-count-during-resize
+++ a/fs/reiserfs/resize.c
@@ -119,7 +119,7 @@ int reiserfs_resize(struct super_block *
 			return -ENOMEM;
 		}
 		memset(bitmap, 0,
-		       sizeof(struct reiserfs_bitmap_info) * SB_BMAP_NR(s));
+		       sizeof(struct reiserfs_bitmap_info) * bmap_nr_new);
 		for (i = 0; i < bmap_nr; i++)
 			bitmap[i] = old_bitmap[i];
 
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
reiserfs-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
