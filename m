Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E72158DAC
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742212; cv=none; b=nf/VIapzOHCCCmD+ubb3xP6ksY6Iyfnx8Y2GIfk1VEyEMFRuIM6x50EcbadklIy1CLtssY0f485Vtk65Y+5lc2bUDQFSXRXLmBd/Wy9zxggAOBIlDJHxARtPK2GnbCFIT1W8JUxMVW32TBVRKV6UaSitqJoBwcBZqxzvSThC6QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742212; c=relaxed/simple;
	bh=Oc9qkaCh2fm+sCY35emtJMv5Uwj0A50aARbZNkOwzyU=;
	h=Date:To:From:Subject:Message-Id; b=jsI4WW3g9xr7dvU5QU+NUDSaXzpL10W9zQB6u9oc6yyurZqQBk913GWxPGs3+v+x7w/+ulIbq5meoLY2bwIPLSxfvU9PcH4yi4+E3eWzCd4NWBUMo1WEV63uNMRcZSyzXSFtzEe605xYEwLJ8XxixK38Fivbovh+Y+mpd+vZ/dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nkNBvRBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nkNBvRBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5038FC4CED6;
	Mon, 13 Jan 2025 04:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742212;
	bh=Oc9qkaCh2fm+sCY35emtJMv5Uwj0A50aARbZNkOwzyU=;
	h=Date:To:From:Subject:From;
	b=nkNBvRBJp2QEUBw+JVkfN3KWan0XXRE4SYAE5lZkWNzU+f8Doc1neFgIigap5HYPq
	 JXPMthH450M1kfFtBxyNMufMLZeubsZeBJLVJxck39+/j0st4U2mkHpNp3mbdgLoZC
	 DHvjl3m5K5Y3HuuV2FGqeFzYRLFXka7BQpvFW9Ns=
Date: Sun, 12 Jan 2025 20:23:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio.patch removed from -mm tree
Message-Id: <20250113042332.5038FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert ocfs2_inode_lock_with_page() to ocfs2_inode_lock_with_folio()
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: convert ocfs2_inode_lock_with_page() to ocfs2_inode_lock_with_folio()
Date: Thu, 5 Dec 2024 17:16:36 +0000

Saves a hidden call to compound_head().

Link: https://lkml.kernel.org/r/20241205171653.3179945-9-willy@infradead.org
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c    |    2 +-
 fs/ocfs2/dlmglue.c |   18 ++++++++----------
 fs/ocfs2/dlmglue.h |    6 ++----
 3 files changed, 11 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio
+++ a/fs/ocfs2/aops.c
@@ -283,7 +283,7 @@ static int ocfs2_read_folio(struct file
 
 	trace_ocfs2_readpage((unsigned long long)oi->ip_blkno, folio->index);
 
-	ret = ocfs2_inode_lock_with_page(inode, NULL, 0, &folio->page);
+	ret = ocfs2_inode_lock_with_folio(inode, NULL, 0, folio);
 	if (ret != 0) {
 		if (ret == AOP_TRUNCATED_PAGE)
 			unlock = 0;
--- a/fs/ocfs2/dlmglue.c~ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio
+++ a/fs/ocfs2/dlmglue.c
@@ -2529,30 +2529,28 @@ bail:
 
 /*
  * This is working around a lock inversion between tasks acquiring DLM
- * locks while holding a page lock and the downconvert thread which
- * blocks dlm lock acquiry while acquiring page locks.
+ * locks while holding a folio lock and the downconvert thread which
+ * blocks dlm lock acquiry while acquiring folio locks.
  *
- * ** These _with_page variants are only intended to be called from aop
- * methods that hold page locks and return a very specific *positive* error
+ * ** These _with_folio variants are only intended to be called from aop
+ * methods that hold folio locks and return a very specific *positive* error
  * code that aop methods pass up to the VFS -- test for errors with != 0. **
  *
  * The DLM is called such that it returns -EAGAIN if it would have
  * blocked waiting for the downconvert thread.  In that case we unlock
- * our page so the downconvert thread can make progress.  Once we've
+ * our folio so the downconvert thread can make progress.  Once we've
  * done this we have to return AOP_TRUNCATED_PAGE so the aop method
  * that called us can bubble that back up into the VFS who will then
  * immediately retry the aop call.
  */
-int ocfs2_inode_lock_with_page(struct inode *inode,
-			      struct buffer_head **ret_bh,
-			      int ex,
-			      struct page *page)
+int ocfs2_inode_lock_with_folio(struct inode *inode,
+		struct buffer_head **ret_bh, int ex, struct folio *folio)
 {
 	int ret;
 
 	ret = ocfs2_inode_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK);
 	if (ret == -EAGAIN) {
-		unlock_page(page);
+		folio_unlock(folio);
 		/*
 		 * If we can't get inode lock immediately, we should not return
 		 * directly here, since this will lead to a softlockup problem.
--- a/fs/ocfs2/dlmglue.h~ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio
+++ a/fs/ocfs2/dlmglue.h
@@ -137,10 +137,8 @@ int ocfs2_inode_lock_full_nested(struct
 			 int ex,
 			 int arg_flags,
 			 int subclass);
-int ocfs2_inode_lock_with_page(struct inode *inode,
-			      struct buffer_head **ret_bh,
-			      int ex,
-			      struct page *page);
+int ocfs2_inode_lock_with_folio(struct inode *inode,
+		struct buffer_head **ret_bh, int ex, struct folio *folio);
 /* Variants without special locking class or flags */
 #define ocfs2_inode_lock_full(i, r, e, f)\
 		ocfs2_inode_lock_full_nested(i, r, e, f, OI_LS_NORMAL)
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


