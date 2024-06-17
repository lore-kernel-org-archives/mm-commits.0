Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30632187575;
	Mon, 17 Jun 2024 20:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718655404; cv=none; b=QgIcdeYweMVKO+HNeesvIYwaMUYbAiYFkncJ/8cQW5r5Pk7A2gZxePymGQk69BeaJX3U4QwmCWZyO2RWusnEKqSroMMhGAOyq8chHHcX4Dj5Pzfa6YtHgOfCxPDfvQxapL+KkAOct/fT91kaPmROUwNouL292zqjgo/gCx5fw+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718655404; c=relaxed/simple;
	bh=w4yEqIe57awiwI2V5uQteKS/QqfeXDy1eWiIO+pVGZc=;
	h=Date:To:From:Subject:Message-Id; b=GygIuGXwNNsdV2t6PFOAou2ri5g9sdNtvxvj81/gsvirNeLXBuPwFnz0uqwTmosXizYGGhKuqVLrXFGSoiX7pbCHuyrjrYWttUI31F1aLP6Kldryh8evyI1STyKgifApGI8pn1MSszM7jwSeb3CNrOyyh9l/yxp6Vy4NX7nAFu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gNGJtddb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gNGJtddb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F754C2BD10;
	Mon, 17 Jun 2024 20:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718655403;
	bh=w4yEqIe57awiwI2V5uQteKS/QqfeXDy1eWiIO+pVGZc=;
	h=Date:To:From:Subject:From;
	b=gNGJtddbm9utbYx+05aTCGtISbwbB6c2U2TlAhCE7UQPqsEmfvWRJO8qoTY/k48Y2
	 kzKkD21EIPMJx+uQPrfhXvvdWrKWiPEYQSD/5Xx46y8eSoG9iFtAAYYnTjj5XqSDnc
	 frKk+zmS0FZpKePYOWDbWoIYkjKxLpDMexKxC8uw=
Date: Mon, 17 Jun 2024 13:16:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits.patch added to mm-hotfixes-unstable branch
Message-Id: <20240617201643.9F754C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix DIO failure due to insufficient transaction credits
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: fix DIO failure due to insufficient transaction credits
Date: Fri, 14 Jun 2024 16:52:43 +0200

The code in ocfs2_dio_end_io_write() estimates number of necessary
transaction credits using ocfs2_calc_extend_credits().  This however does
not take into account that the IO could be arbitrarily large and can
contain arbitrary number of extents.

Extent tree manipulations do often extend the current transaction but not
in all of the cases.  For example if we have only single block extents in
the tree, ocfs2_mark_extent_written() will end up calling
ocfs2_replace_extent_rec() all the time and we will never extend the
current transaction and eventually exhaust all the transaction credits if
the IO contains many single block extents.  Once that happens a
WARN_ON(jbd2_handle_buffer_credits(handle) <= 0) is triggered in
jbd2_journal_dirty_metadata() and subsequently OCFS2 aborts in response to
this error.  This was actually triggered by one of our customers on a
heavily fragmented OCFS2 filesystem.

To fix the issue make sure the transaction always has enough credits for
one extent insert before each call of ocfs2_mark_extent_written().

Link: https://lkml.kernel.org/r/20240617095543.6971-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20240614145243.8837-1-jack@suse.cz
Fixes: c15471f79506 ("ocfs2: fix sparse file & data ordering issue in direct io")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c        |    5 +++++
 fs/ocfs2/journal.c     |   17 +++++++++++++++++
 fs/ocfs2/journal.h     |    2 ++
 fs/ocfs2/ocfs2_trace.h |    2 ++
 4 files changed, 26 insertions(+)

--- a/fs/ocfs2/aops.c~ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits
+++ a/fs/ocfs2/aops.c
@@ -2366,6 +2366,11 @@ static int ocfs2_dio_end_io_write(struct
 	}
 
 	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
+		ret = ocfs2_assure_trans_credits(handle, credits);
+		if (ret < 0) {
+			mlog_errno(ret);
+			break;
+		}
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
 						ue->ue_cpos, 1,
 						ue->ue_phys,
--- a/fs/ocfs2/journal.c~ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits
+++ a/fs/ocfs2/journal.c
@@ -446,6 +446,23 @@ bail:
 }
 
 /*
+ * Make sure handle has at least 'nblocks' credits available. If it does not
+ * have that many credits available, we will try to extend the handle to have
+ * enough credits. If that fails, we will restart transaction to have enough
+ * credits. Similar notes regarding data consistency and locking implications
+ * as for ocfs2_extend_trans() apply here.
+ */
+int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
+{
+	int old_nblks = jbd2_handle_buffer_credits(handle);
+
+	trace_ocfs2_assure_trans_credits(old_nblks);
+	if (old_nblks >= nblocks)
+		return 0;
+	return ocfs2_extend_trans(handle, nblocks - old_nblks);
+}
+
+/*
  * If we have fewer than thresh credits, extend by OCFS2_MAX_TRANS_DATA.
  * If that fails, restart the transaction & regain write access for the
  * buffer head which is used for metadata modifications.
--- a/fs/ocfs2/journal.h~ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits
+++ a/fs/ocfs2/journal.h
@@ -243,6 +243,8 @@ handle_t		    *ocfs2_start_trans(struct
 int			     ocfs2_commit_trans(struct ocfs2_super *osb,
 						handle_t *handle);
 int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
+int			     ocfs2_assure_trans_credits(handle_t *handle,
+						int nblocks);
 int			     ocfs2_allocate_extend_trans(handle_t *handle,
 						int thresh);
 
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -2577,6 +2577,8 @@ DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_commit
 
 DEFINE_OCFS2_INT_INT_EVENT(ocfs2_extend_trans);
 
+DEFINE_OCFS2_INT_EVENT(ocfs2_assure_trans_credits);
+
 DEFINE_OCFS2_INT_EVENT(ocfs2_extend_trans_restart);
 
 DEFINE_OCFS2_INT_INT_EVENT(ocfs2_allocate_extend_trans);
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits.patch

