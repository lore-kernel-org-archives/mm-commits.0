Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D64E3F9D2
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578017; cv=none; b=oeO7hrNOYl42Z4Ol1jEBtU5p32FJr7ZMthva3vMIiNy0G8B/O5rmkYsmT/YqsPAkeMN7xKWkUMJ6i/naQin6eFYfgZah77zX3RroWpijHkhyBZc419UB8NQmwDMgCjkgLVsSiM5DJkb/TRseNiU+Lo5gPMQOm/ojtPR5AOzQcAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578017; c=relaxed/simple;
	bh=o/IV0FaUskze9V6V1nN9fTlLJRPvX/EMX+KozesyCSo=;
	h=Date:To:From:Subject:Message-Id; b=gcDa3nDt68eFu15/3uYcHI8z1tWWpMPsHc7JleowvqKRsFqjslp9UMD9wN+MEN5Yu1RXmP8/whyqv5DQ/WPfvshL0nVgx04jDxrprHhafh0/PeZodHSV28JlJqLZ/vJWWPXdeNB2axBE44PRCfW0l9hUvGwM4CmdDPM51aU30ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uOnuDlS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uOnuDlS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877BCC4CED1;
	Sat, 15 Feb 2025 00:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739578016;
	bh=o/IV0FaUskze9V6V1nN9fTlLJRPvX/EMX+KozesyCSo=;
	h=Date:To:From:Subject:From;
	b=uOnuDlS8J72akPyHRBk+Y+QXzX7Ut0XtBS70WB8MrHUhOiOrchpb0ev/NFa3X5kzU
	 R/3mf+3NqQ4N07soug/Df5o0Tn0jPMNyP+NK2II3k7xXCq5F3+DLYYVhhJktQNGb7q
	 o3L/4UMNOPllSYgdeaJg6BWt4COPVvODb/JBg1KY=
Date: Fri, 14 Feb 2025 16:06:55 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch added to mm-nonmm-unstable branch
Message-Id: <20250215000656.877BCC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use memcpy_to_folio() in ocfs2_symlink_get_block()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: use memcpy_to_folio() in ocfs2_symlink_get_block()
Date: Thu, 13 Feb 2025 21:45:30 +0000

Replace use of kmap_atomic() with the higher-level construct
memcpy_to_folio().  This removes a use of b_page and supports large folios
as well as being easier to understand.  It also removes the check for
kmap_atomic() failing (because it can't).

Link: https://lkml.kernel.org/r/20250213214533.2242224-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block
+++ a/fs/ocfs2/aops.c
@@ -46,7 +46,6 @@ static int ocfs2_symlink_get_block(struc
 	struct buffer_head *bh = NULL;
 	struct buffer_head *buffer_cache_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	void *kaddr;
 
 	trace_ocfs2_symlink_get_block(
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -91,17 +90,11 @@ static int ocfs2_symlink_get_block(struc
 		 * could've happened. Since we've got a reference on
 		 * the bh, even if it commits while we're doing the
 		 * copy, the data is still good. */
-		if (buffer_jbd(buffer_cache_bh)
-		    && ocfs2_inode_is_new(inode)) {
-			kaddr = kmap_atomic(bh_result->b_page);
-			if (!kaddr) {
-				mlog(ML_ERROR, "couldn't kmap!\n");
-				goto bail;
-			}
-			memcpy(kaddr + (bh_result->b_size * iblock),
-			       buffer_cache_bh->b_data,
-			       bh_result->b_size);
-			kunmap_atomic(kaddr);
+		if (buffer_jbd(buffer_cache_bh) && ocfs2_inode_is_new(inode)) {
+			memcpy_to_folio(bh_result->b_folio,
+					bh_result->b_size * iblock,
+					buffer_cache_bh->b_data,
+					bh_result->b_size);
 			set_buffer_uptodate(bh_result);
 		}
 		brelse(buffer_cache_bh);
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

