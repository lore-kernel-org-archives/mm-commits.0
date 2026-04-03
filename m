Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1513090C5
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775237421; cv=none; b=kP8EPZKL+xIQSmbVrJE3+Dq5t9zehab8jbQCBgKJA8ep/rSvwQRhETzmpERSVPAOoTz8UAimPan021RKJlG2e4FG9Y2TelJMWllqKoVYsxcWoUfs5IuYlgmdUMVFeV9kjlX7PB61xg/S4lLuuh/h3VFqtYJutDcyShU6G5oUPIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775237421; c=relaxed/simple;
	bh=DFzQa+cXylrnYBiSonN/xsrKf7UCPebarg/eDb9okzs=;
	h=Date:To:From:Subject:Message-Id; b=CbBprkR5s7W/97No0sLHylrMf+LnsC9fewyEs/kq7/MXqKw6nyPfPGab0p0xtfse1eRmc7PbrD6fHwmLjdz1g5I5VeaTgnyFr+o8/jpZD8QBOMlMK05d3B477ARyY5hy2q/AZw9GI3NjTb1y0vZURx4RIr7H+eAocSbVdyxMHM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HW2b9f4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HW2b9f4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B633C4CEF7;
	Fri,  3 Apr 2026 17:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775237421;
	bh=DFzQa+cXylrnYBiSonN/xsrKf7UCPebarg/eDb9okzs=;
	h=Date:To:From:Subject:From;
	b=HW2b9f4fiGvEzfZuVG8C/2lnOgeLUt745/Qw8x1CV7rGkhN8KZo85ra1HwAgxxJSI
	 MSHhGAJAbUhZdEp1+ksBbjhFb43SuciAWE077oU7o6y0vo4hq3fS2SsxI/VnFKuA2b
	 JbjAz1S48Is8QI8O79zAPSTS/E53dCfboHteejMY=
Date: Fri, 03 Apr 2026 10:30:20 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jack@suse.cz,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-split-transactions-in-dio-completion-to-avoid-credit-exhaustion.patch added to mm-nonmm-unstable branch
Message-Id: <20260403173021.1B633C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: split transactions in dio completion to avoid credit exhaustion
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-split-transactions-in-dio-completion-to-avoid-credit-exhaustion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-split-transactions-in-dio-completion-to-avoid-credit-exhaustion.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu, 2 Apr 2026 21:43:27 +0800

During ocfs2 dio operations, JBD2 may report warnings via following
call trace:
ocfs2_dio_end_io_write
 ocfs2_mark_extent_written
  ocfs2_change_extent_flag
   ocfs2_split_extent
    ocfs2_try_to_merge_extent
     ocfs2_extend_rotate_transaction
      ocfs2_extend_trans
       jbd2__journal_restart
        start_this_handle
         output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449

To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
handle extents in a batch of transaction.

Additionally, relocate ocfs2_del_inode_from_orphan().  The orphan inode
should only be removed from the orphan list after the extent tree update
is complete.  This ensures that if a crash occurs in the middle of extent
tree updates, we won't leave stale blocks beyond EOF.

This patch also changes the logic for updating the inode size and removing
orphan, making it similar to ext4_dio_write_end_io().  Both operations are
performed only when everything looks good.

Finally, thanks to Jans and Joseph for providing the bug fix prototype and
suggestions.

Link: https://lkml.kernel.org/r/20260402134328.27334-2-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   74 +++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 29 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-split-transactions-in-dio-completion-to-avoid-credit-exhaustion
+++ a/fs/ocfs2/aops.c
@@ -37,6 +37,8 @@
 #include "namei.h"
 #include "sysfile.h"
 
+#define OCFS2_DIO_MARK_EXTENT_BATCH 200
+
 static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
@@ -2277,7 +2279,7 @@ static int ocfs2_dio_end_io_write(struct
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
-	int ret = 0, credits = 0;
+	int ret = 0, credits = 0, batch = 0;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -2294,18 +2296,6 @@ static int ocfs2_dio_end_io_write(struct
 		goto out;
 	}
 
-	/* Delete orphan before acquire i_rwsem. */
-	if (dwc->dw_orphaned) {
-		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
-
-		end = end > i_size_read(inode) ? end : 0;
-
-		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
-				!!end, end);
-		if (ret < 0)
-			mlog_errno(ret);
-	}
-
 	down_write(&oi->ip_alloc_sem);
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
@@ -2326,24 +2316,25 @@ static int ocfs2_dio_end_io_write(struct
 
 	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
 
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		goto unlock;
-	}
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto commit;
-	}
-
 	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
+		if (!handle) {
+			handle = ocfs2_start_trans(osb, credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				mlog_errno(ret);
+				goto unlock;
+			}
+			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+					OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret) {
+				mlog_errno(ret);
+				goto commit;
+			}
+		}
 		ret = ocfs2_assure_trans_credits(handle, credits);
 		if (ret < 0) {
 			mlog_errno(ret);
-			break;
+			goto commit;
 		}
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
 						ue->ue_cpos, 1,
@@ -2351,19 +2342,44 @@ static int ocfs2_dio_end_io_write(struct
 						meta_ac, &dealloc);
 		if (ret < 0) {
 			mlog_errno(ret);
-			break;
+			goto commit;
+		}
+
+		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
+			ocfs2_commit_trans(osb, handle);
+			handle = NULL;
+			batch = 0;
 		}
 	}
 
 	if (end > i_size_read(inode)) {
+		if (!handle) {
+			handle = ocfs2_start_trans(osb, credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				mlog_errno(ret);
+				goto unlock;
+			}
+		}
 		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
 		if (ret < 0)
 			mlog_errno(ret);
 	}
+
 commit:
-	ocfs2_commit_trans(osb, handle);
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
 unlock:
 	up_write(&oi->ip_alloc_sem);
+
+	/* everything looks good, let's start the cleanup */
+	if (!ret && dwc->dw_orphaned) {
+		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
+
+		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
_

Patches currently in -mm which might be from heming.zhao@suse.com are

ocfs2-split-transactions-in-dio-completion-to-avoid-credit-exhaustion.patch

