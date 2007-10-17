From: akpm@linux-foundation.org
Subject: + reiserfs-fix-memset-byte-count-during-resize.patch added to -mm tree
Date: Wed, 17 Oct 2007 15:15:28 -0700
Message-ID: <200710172215.l9HMFSj1010971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762004AbXJQWPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 18:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, hch@lst.de, mason@suse.com, vs@namesys.com


The patch titled
     reiserfs: fix memset byte count during resize
has been added to the -mm tree.  Its filename is
     reiserfs-fix-memset-byte-count-during-resize.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: fix memset byte count during resize
From: Jeff Mahoney <jeffm@suse.com>

Correct the memset in reiserfs_resize to clear the memory allocated for the
new bitmap info structs.  Previously, it would clear the memory used by the
old size.  Depending on the contents of memory, this could cause incorrect
caching behavior for bitmap blocks in the newly allocated area.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <mason@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
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

try-to-reap-reiserfs-pages-left-around-by-invalidatepage.patch
reiserfs-fix-kernel-panic-on-corrupted-directory.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
reiserfs-do-not-repair-wrong-journal-params.patch
reiserfs-fix-up-lockdep-warnings.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-dont-use-bug-when-panicking.patch
reiserfs-use-is_reusable-to-catch-corruption.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-fix-memset-byte-count-during-resize.patch
reiserfs-remove-first_zero_hint.patch
reiserfs-ignore-on-disk-s_bmap_nr-value.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
reiserfs-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
