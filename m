From: akpm@linux-foundation.org
Subject: + ext3-fix-mount-messages-when-quota-disabled.patch added to -mm tree
Date: Tue, 15 Apr 2008 14:46:22 -0700
Message-ID: <200804152146.m3FLkM36017408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759949AbYDOVqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 17:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     ext3: fix mount messages when quota disabled
has been added to the -mm tree.  Its filename is
     ext3-fix-mount-messages-when-quota-disabled.patch

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
@@ -1096,6 +1096,9 @@ clear_qf_name:
 		case Opt_quota:
 		case Opt_usrquota:
 		case Opt_grpquota:
+			printk(KERN_ERR
+				"EXT3-fs: quota options not supported.\n");
+			break;
 		case Opt_usrjquota:
 		case Opt_grpjquota:
 		case Opt_offusrjquota:
@@ -1103,7 +1106,7 @@ clear_qf_name:
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

vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs.patch
git-dvb.patch
git-udf.patch
git-ocfs2.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch
quota-remove-superfluous-dquot_off-in-fs-namespacec.patch
quota-various-style-cleanups.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
ext3-fix-update-of-mtime-and-ctime-on-rename.patch
ext3-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext3-fix-mount-messages-when-quota-disabled.patch
reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext4-fix-update-of-mtime-and-ctime-on-rename.patch
ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
quota-le_add_cpu-conversion.patch
ext4-fix-mount-messages-when-quota-disabled.patch

