From: akpm@linux-foundation.org
Subject: + fs-fix-lock-imbalance-in-do_remount_sb.patch added to -mm tree
Date: Wed, 13 May 2009 16:09:40 -0700
Message-ID: <200905132309.n4DN9eUC010968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356AbZEMXKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 19:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     fs: fix lock imbalance in do_remount_sb()
has been added to the -mm tree.  Its filename is
     fs-fix-lock-imbalance-in-do_remount_sb.patch

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
Subject: fs: fix lock imbalance in do_remount_sb()
From: Jiri Slaby <jirislaby@gmail.com>

Commit "Push BKL down into do_remount_sb()" pushed un/lock_kernel into
do_remount_sb but forgets to unlock it on fail paths.  Fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN fs/super.c~fs-fix-lock-imbalance-in-do_remount_sb fs/super.c
--- a/fs/super.c~fs-fix-lock-imbalance-in-do_remount_sb
+++ a/fs/super.c
@@ -546,18 +546,24 @@ int do_remount_sb(struct super_block *sb
 	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
 		if (force)
 			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb))
+		else if (!fs_may_remount_ro(sb)) {
+			unlock_kernel();
 			return -EBUSY;
+		}
 		retval = vfs_dq_off(sb, 1);
-		if (retval < 0 && retval != -ENOSYS)
+		if (retval < 0 && retval != -ENOSYS) {
+			unlock_kernel();
 			return -EBUSY;
+		}
 	}
 	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		if (retval)
+		if (retval) {
+			unlock_kernel();
 			return retval;
+		}
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 	unlock_kernel();
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
fs-fix-lock-imbalance-in-do_remount_sb.patch
icom-converting-space-to-tabs.patch
char-isicom-fix-build-warning.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

