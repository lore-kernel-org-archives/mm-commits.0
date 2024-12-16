Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D517410F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327658; cv=none; b=PdhoM8SlUNkuQHZgR6Nj1h2Y0vAxFQFkoYGSllz9VmjGw1Xb1N5/G/437NPp9TLmHB8ykFAwjTa/8s6Bm/1VEOHDyh9CvqB/PpeyjwVWgT8nqrpApqzA/ljoD6gqhV5zQ46yTXwdgH1VLSArrAyUzLme5u7mJbLm7Swi/fxwyRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327658; c=relaxed/simple;
	bh=ZatTGkHAiuYT593DJZZ5ppBEzJstrFSiSy8KDTRDc/g=;
	h=Date:To:From:Subject:Message-Id; b=hwm5YuSedHuQxmyXWSrGmlz2xK5aLm7CL2Tc4DOPwo91Bxh10jnksaErSaDmp1HbOvgXX3AtobjS4tnouL9mlGIvR68HPL1L2PzPLsKtL/1kV4X4LDR3vyVmehi+E5Gb1PCzbToEvRf5MqpXGsIhocktUTYoR1i82kr+HnRZcDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JgjkiWxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JgjkiWxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FC7C4CED0;
	Mon, 16 Dec 2024 05:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327658;
	bh=ZatTGkHAiuYT593DJZZ5ppBEzJstrFSiSy8KDTRDc/g=;
	h=Date:To:From:Subject:From;
	b=JgjkiWxE8kNvU2zt7gPJ2e8JANZme1dIrAJiIBT+ChIg720ZhILlW+yFw25JfCLJ+
	 B1+TSQnYw/vdwURQrDki5r3YyqyDa25/5TSo5mnLDmeO5FNaanZEDjGYw3Eoe8lJRj
	 KI6g19ENTFy0GYUl2En68n7REt93aAK9FDcX1VLo=
Date: Sun, 15 Dec 2024 21:40:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054058.63FC7C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: convert ocfs2_inode_lock_with_page() to ocfs2_inode_lock_with_folio()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

ocfs2-convert-w_target_page-to-w_target_folio.patch
ocfs2-use-a-folio-in-ocfs2_zero_new_buffers.patch
ocfs2-use-a-folio-in-ocfs2_write_begin_inline.patch
ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio.patch
ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio.patch
ocfs2-convert-w_pages-to-w_folios.patch
ocfs2-convert-ocfs2_write_failure-to-use-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_write_end_nolock.patch
ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write.patch
ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page.patch
ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks.patch
ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions.patch
ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages.patch
ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio.patch
ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios.patch
ocfs2-support-large-folios-in-ocfs2_write_zero_page.patch

