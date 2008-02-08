From: akpm@linux-foundation.org
Subject: - quota-turn-quotas-off-when-remounting-read-only.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:21:19 -0800
Message-ID: <200802082021.m18KL0Ew011275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932395AbYBHUe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:34:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     quota: turn quotas off when remounting read-only
has been removed from the -mm tree.  Its filename was
     quota-turn-quotas-off-when-remounting-read-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: turn quotas off when remounting read-only
From: Jan Kara <jack@suse.cz>

Turn off quotas before filesystem is remounted read only.  Otherwise quota
will try to write to read-only filesystem which does no good...  We could
also just refuse to remount ro when quota is enabled but turning quota off
is consistent with what we do on umount.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/super.c~quota-turn-quotas-off-when-remounting-read-only fs/super.c
--- a/fs/super.c~quota-turn-quotas-off-when-remounting-read-only
+++ a/fs/super.c
@@ -604,6 +604,7 @@ int do_remount_sb(struct super_block *sb
 			mark_files_ro(sb);
 		else if (!fs_may_remount_ro(sb))
 			return -EBUSY;
+		DQUOT_OFF(sb);
 	}
 
 	if (sb->s_op->remount_fs) {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
