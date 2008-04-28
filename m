From: akpm@linux-foundation.org
Subject: - quota-remove-superfluous-dquot_off-in-fs-namespacec.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:25 -0700
Message-ID: <200804282156.m3SLuP6u018224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936830AbYD1V43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: remove superfluous DQUOT_OFF() in fs/namespace.c
has been removed from the -mm tree.  Its filename was
     quota-remove-superfluous-dquot_off-in-fs-namespacec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: remove superfluous DQUOT_OFF() in fs/namespace.c
From: Jan Kara <jack@suse.cz>

We don't need to turn quotas off before remounting root ro, because
do_remount_sb() already handles this.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/namespace.c~quota-remove-superfluous-dquot_off-in-fs-namespacec fs/namespace.c
--- a/fs/namespace.c~quota-remove-superfluous-dquot_off-in-fs-namespacec
+++ a/fs/namespace.c
@@ -14,7 +14,6 @@
 #include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/quotaops.h>
 #include <linux/acct.h>
 #include <linux/capability.h>
 #include <linux/cpumask.h>
@@ -1084,7 +1083,6 @@ static int do_umount(struct vfsmount *mn
 		down_write(&sb->s_umount);
 		if (!(sb->s_flags & MS_RDONLY)) {
 			lock_kernel();
-			DQUOT_OFF(sb);
 			retval = do_remount_sb(sb, MS_RDONLY, NULL, 0);
 			unlock_kernel();
 		}
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
ext4-fix-update-of-mtime-and-ctime-on-rename.patch
ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch
isofs-use-get-put_unaligned_-helpers.patch

