From: akpm@linux-foundation.org
Subject: - reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:27:19 -0800
Message-ID: <200811262027.mAQKRJTQ000413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523AbYKZU1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:27:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, reiserfs-devel@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     reiserfs: use sb_any_quota_loaded() instead of sb_any_quota_enabled()
has been removed from the -mm tree.  Its filename was
     reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: use sb_any_quota_loaded() instead of sb_any_quota_enabled()
From: Jan Kara <jack@suse.cz>

Cc: <reiserfs-devel@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/reiserfs/super.c~reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled
+++ a/fs/reiserfs/super.c
@@ -994,8 +994,7 @@ static int reiserfs_parse_options(struct
 		if (c == 'u' || c == 'g') {
 			int qtype = c == 'u' ? USRQUOTA : GRPQUOTA;
 
-			if ((sb_any_quota_enabled(s) ||
-			     sb_any_quota_suspended(s)) &&
+			if (sb_any_quota_loaded(s) &&
 			    (!*arg != !REISERFS_SB(s)->s_qf_names[qtype])) {
 				reiserfs_warning(s,
 						 "reiserfs_parse_options: cannot change journaled quota options when quota turned on.");
@@ -1041,8 +1040,7 @@ static int reiserfs_parse_options(struct
 						 "reiserfs_parse_options: unknown quota format specified.");
 				return 0;
 			}
-			if ((sb_any_quota_enabled(s) ||
-			     sb_any_quota_suspended(s)) &&
+			if (sb_any_quota_loaded(s) &&
 			    *qfmt != REISERFS_SB(s)->s_jquota_fmt) {
 				reiserfs_warning(s,
 						 "reiserfs_parse_options: cannot change journaled quota options when quota turned on.");
@@ -1067,7 +1065,7 @@ static int reiserfs_parse_options(struct
 	}
 	/* This checking is not precise wrt the quota type but for our purposes it is sufficient */
 	if (!(*mount_options & (1 << REISERFS_QUOTA))
-	    && sb_any_quota_enabled(s)) {
+	    && sb_any_quota_loaded(s)) {
 		reiserfs_warning(s,
 				 "reiserfs_parse_options: quota options must be present when quota is turned on.");
 		return 0;
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
quota-remove-compatibility-function-sb_any_quota_enabled.patch
quota-introduce-dquot_quota_sys_file-flag.patch
quota-move-quotaio_vh-from-include-linux-to-fs.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-split-off-quota-tree-handling-into-a-separate-file.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch

