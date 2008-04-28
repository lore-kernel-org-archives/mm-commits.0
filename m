From: akpm@linux-foundation.org
Subject: - ext3-fix-mount-messages-when-quota-disabled.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:57 -0700
Message-ID: <200804282200.m3SM0vQw018793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965644AbYD1WBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext3: fix mount messages when quota disabled
has been removed from the -mm tree.  Its filename was
     ext3-fix-mount-messages-when-quota-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: fix mount messages when quota disabled
From: Jan Kara <jack@suse.cz>

When quota is disabled, we should not print 'journaled quota not supported'
when user tried to mount non-journaled quota.  Also fix typo in the message.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ext3/super.c~ext3-fix-mount-messages-when-quota-disabled fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-fix-mount-messages-when-quota-disabled
+++ a/fs/ext3/super.c
@@ -1097,6 +1097,9 @@ clear_qf_name:
 		case Opt_quota:
 		case Opt_usrquota:
 		case Opt_grpquota:
+			printk(KERN_ERR
+				"EXT3-fs: quota options not supported.\n");
+			break;
 		case Opt_usrjquota:
 		case Opt_grpjquota:
 		case Opt_offusrjquota:
@@ -1104,7 +1107,7 @@ clear_qf_name:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
 			printk(KERN_ERR
-				"EXT3-fs: journalled quota options not "
+				"EXT3-fs: journaled quota options not "
 				"supported.\n");
 			break;
 		case Opt_noquota:
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

