From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer-v2.patch removed from -mm tree
Date: Mon, 23 Jun 2014 13:13:14 -0700
Message-ID: <53a88a5a.6NzaDyxpBD5ANxwA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbaFWUNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 16:13:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.de, joseph.qi@huawei.com, jlbec@evilplan.org, jiangyiwen@huawei.com


The patch titled
     Subject: ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer-v2.patch

This patch was dropped because it was folded into ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer-v2

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c       |    7 +++----
 fs/ocfs2/ocfs2_trace.h |    2 ++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer-v2 fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer-v2
+++ a/fs/ocfs2/namei.c
@@ -1222,10 +1222,9 @@ static int ocfs2_rename(struct inode *ol
 			goto bail;
 		} else if (status == 1) {
 			status = -EPERM;
-			mlog(ML_ERROR, "src inode %llu should not be ancestor "
-				"of new dir inode %llu\n",
-				(unsigned long long)old_inode->i_ino,
-				(unsigned long long)new_dir->i_ino);
+			trace_ocfs2_rename_not_permitted(
+					(unsigned long long)old_inode->i_ino,
+					(unsigned long long)new_dir->i_ino);
 			goto bail;
 		}
 	}
diff -puN fs/ocfs2/ocfs2_trace.h~ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer-v2 fs/ocfs2/ocfs2_trace.h
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer-v2
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -2292,6 +2292,8 @@ TRACE_EVENT(ocfs2_rename,
 		  __entry->new_len, __get_str(new_name))
 );
 
+DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_rename_not_permitted);
+
 TRACE_EVENT(ocfs2_rename_target_exists,
 	TP_PROTO(int new_len, const char *new_name),
 	TP_ARGS(new_len, new_name),
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch
ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod-v2.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch

