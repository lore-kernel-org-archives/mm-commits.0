Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5565138F9A;
	Tue, 25 Jun 2024 03:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287560; cv=none; b=eUhRoI2JNKiONU+kWr8I7qLktY3tFWr1RIdGoAtiMTJlYLaKugW8zw7ScxEws/ywhlvrYMKoAwF7hPlS8Af/9Jj/oqBCBAy9U4rA1U2+TBKUlqXx3F6T20EtLv3u8Ef+ai4u2J1+lA2tFgyMq3OBy/EvSEKjafog8/GrKodrcp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287560; c=relaxed/simple;
	bh=sX9/64tGCQ6LEulFEg28wEDuSlkftXH0X6VeIVH3pdg=;
	h=Date:To:From:Subject:Message-Id; b=V1PBJ64dtieVYr3h12WztbVezS39RPrqQ+VNS1Z0v3jIfBtTEx4Fa18P4loJVT6iuS6PH06kiQSaoNYX/IgPPLp04Wj0yaThOzMfEfMUQAgEGL+4IWnuogygiVPhltpFTKAj2BrD/kd4ye9wMq7pFZLkTcrX7VVPS68QlHeZ4sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cikM6YJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cikM6YJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7F8C32782;
	Tue, 25 Jun 2024 03:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287560;
	bh=sX9/64tGCQ6LEulFEg28wEDuSlkftXH0X6VeIVH3pdg=;
	h=Date:To:From:Subject:From;
	b=cikM6YJO/K0u37AafUx/q5L+X9EBcWpLvGsQq0gVe/TgiBQvraEjCyLSAM5CsJNp2
	 gd4j8xcu1MXnDrZHBjJa+cOIdRN1AQ2d+FPBGcrMOf0zhpx6e2jBDVvYjM2UsY+5b5
	 Lph6Ihv9aJsbWcWsaazn9QWiTnNn3nA9g2iAh2+0=
Date: Mon, 24 Jun 2024 20:52:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits.patch removed from -mm tree
Message-Id: <20240625035240.1F7F8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix DIO failure due to insufficient transaction credits
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Heming Zhao said:

------
PANIC: "Kernel panic - not syncing: OCFS2: (device dm-1): panic forced after error"

PID: xxx  TASK: xxxx  CPU: 5  COMMAND: "SubmitThread-CA"
  #0 machine_kexec at ffffffff8c069932
  #1 __crash_kexec at ffffffff8c1338fa
  #2 panic at ffffffff8c1d69b9
  #3 ocfs2_handle_error at ffffffffc0c86c0c [ocfs2]
  #4 __ocfs2_abort at ffffffffc0c88387 [ocfs2]
  #5 ocfs2_journal_dirty at ffffffffc0c51e98 [ocfs2]
  #6 ocfs2_split_extent at ffffffffc0c27ea3 [ocfs2]
  #7 ocfs2_change_extent_flag at ffffffffc0c28053 [ocfs2]
  #8 ocfs2_mark_extent_written at ffffffffc0c28347 [ocfs2]
  #9 ocfs2_dio_end_io_write at ffffffffc0c2bef9 [ocfs2]
#10 ocfs2_dio_end_io at ffffffffc0c2c0f5 [ocfs2]
#11 dio_complete at ffffffff8c2b9fa7
#12 do_blockdev_direct_IO at ffffffff8c2bc09f
#13 ocfs2_direct_IO at ffffffffc0c2b653 [ocfs2]
#14 generic_file_direct_write at ffffffff8c1dcf14
#15 __generic_file_write_iter at ffffffff8c1dd07b
#16 ocfs2_file_write_iter at ffffffffc0c49f1f [ocfs2]
#17 aio_write at ffffffff8c2cc72e
#18 kmem_cache_alloc at ffffffff8c248dde
#19 do_io_submit at ffffffff8c2ccada
#20 do_syscall_64 at ffffffff8c004984
#21 entry_SYSCALL_64_after_hwframe at ffffffff8c8000ba

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

revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch
mm-avoid-overflows-in-dirty-throttling-logic.patch

