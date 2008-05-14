From: akpm@linux-foundation.org
Subject: - ext4-fix-mount-messages-when-quota-disabled.patch removed from -mm tree
Date: Wed, 14 May 2008 14:22:18 -0700
Message-ID: <200805142122.m4ELMIf2021585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbYENVWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 17:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext4: fix mount messages when quota disabled
has been removed from the -mm tree.  Its filename was
     ext4-fix-mount-messages-when-quota-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fix mount messages when quota disabled
From: Jan Kara <jack@suse.cz>

When quota is disabled, we should not print 'journaled quota not supported'
when user tried to mount non-journaled quota.  Also fix typo in the message.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ext4/super.c~ext4-fix-mount-messages-when-quota-disabled fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-fix-mount-messages-when-quota-disabled
+++ a/fs/ext4/super.c
@@ -1241,6 +1241,9 @@ clear_qf_name:
 		case Opt_quota:
 		case Opt_usrquota:
 		case Opt_grpquota:
+			printk(KERN_ERR
+				"EXT4-fs: quota options not supported.\n");
+			break;
 		case Opt_usrjquota:
 		case Opt_grpjquota:
 		case Opt_offusrjquota:
@@ -1248,7 +1251,7 @@ clear_qf_name:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
 			printk(KERN_ERR
-				"EXT4-fs: journalled quota options not "
+				"EXT4-fs: journaled quota options not "
 				"supported.\n");
 			break;
 		case Opt_noquota:
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch

