From: akpm@linux-foundation.org
Subject: + vfs-fix-null-pointer-dereference-in-fsync_buffers_list.patch added to -mm tree
Date: Tue, 04 Mar 2008 11:41:32 -0800
Message-ID: <200803041941.m24JfWFn025422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755973AbYCDTmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 14:42:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     vfs: fix NULL pointer dereference in fsync_buffers_list()
has been added to the -mm tree.  Its filename is
     vfs-fix-null-pointer-dereference-in-fsync_buffers_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix NULL pointer dereference in fsync_buffers_list()
From: Jan Kara <jack@suse.cz>

Fix NULL pointer dereference in fsync_buffers_list() introduced by recent fix
of races in private_list handling.  Since bh->b_assoc_map has been cleared in
__remove_assoc_queue() we should really use original value stored in the
'mapping' variable.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/buffer.c~vfs-fix-null-pointer-dereference-in-fsync_buffers_list fs/buffer.c
--- a/fs/buffer.c~vfs-fix-null-pointer-dereference-in-fsync_buffers_list
+++ a/fs/buffer.c
@@ -835,7 +835,7 @@ static int fsync_buffers_list(spinlock_t
 		smp_mb();
 		if (buffer_dirty(bh)) {
 			list_add(&bh->b_assoc_buffers,
-				 &bh->b_assoc_map->private_list);
+				 &mapping->private_list);
 			bh->b_assoc_map = mapping;
 		}
 		spin_unlock(lock);
_

Patches currently in -mm which might be from jack@suse.cz are

vfs-fix-null-pointer-dereference-in-fsync_buffers_list.patch
git-ocfs2.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
udf-fix-anchor-point-detection.patch
quota-le_add_cpu-conversion.patch

