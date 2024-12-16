Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C2610F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327650; cv=none; b=VLyGjqSCgZEUaWE7KCIdpVlo0s4rA+2JNUwxKQCxgoRTDBY8QKhEUqOZvRGXtxwkHPj2RT2A/EA1EvPWMJqbrUMWLAbb3Z8fDae8jb9K9dnmPkAvtDWKrYLclpyKhwtS1/D5k9jeLfNUgtNDjcxo8RgBdZV6Sx8w6HwQ1LcEovo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327650; c=relaxed/simple;
	bh=gld3GhFQh4zmCdHSmfgcArPHQIXlapMoOmSQwuKCw5I=;
	h=Date:To:From:Subject:Message-Id; b=d83yNmXPL691oP4isChvUMjpayYtPY5oJMzYl6TpoVZ9W/hHpbAnPODkOpfOZaE9P5X73MSSyqcQsI9ZMlcxfpK78IswCR3XoOC/tnxi5ZWhdVfL+XFJrqxXoVPswOlwODuS3h9Px5/9JapshsIOIRfFhiZ+hePzDHxF5s0Zf0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cOnniYR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cOnniYR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBA0C4CED0;
	Mon, 16 Dec 2024 05:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327649;
	bh=gld3GhFQh4zmCdHSmfgcArPHQIXlapMoOmSQwuKCw5I=;
	h=Date:To:From:Subject:From;
	b=cOnniYR1M+CbcUXh20Noxia5F3WaZZWdzBimSdpNnLAMRhFUY5m7T1adwMjplHbmM
	 XxhSqjEhgSu3l/Y1oOBLibPOSg544delN0/RUhAWwcmaSvUtmSbrKmOu0Tw1yCoZI5
	 jLC7Dy3jbmXCXd2UzNl0BEElWtHXSODYdpTF+OTE=
Date: Sun, 15 Dec 2024 21:40:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-a-folio-in-ocfs2_zero_new_buffers.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054049.CBBA0C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use a folio in ocfs2_zero_new_buffers()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-a-folio-in-ocfs2_zero_new_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-a-folio-in-ocfs2_zero_new_buffers.patch

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
Subject: ocfs2: use a folio in ocfs2_zero_new_buffers()
Date: Thu, 5 Dec 2024 17:16:32 +0000

Convert to the new APIs, saving at least one hidden call to
compound_head().

Link: https://lkml.kernel.org/r/20241205171653.3179945-5-willy@infradead.org
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

 fs/ocfs2/aops.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-use-a-folio-in-ocfs2_zero_new_buffers
+++ a/fs/ocfs2/aops.c
@@ -869,30 +869,30 @@ static int ocfs2_alloc_write_ctxt(struct
  * and dirty so they'll be written out (in order to prevent uninitialised
  * block data from leaking). And clear the new bit.
  */
-static void ocfs2_zero_new_buffers(struct folio *folio, unsigned from, unsigned to)
+static void ocfs2_zero_new_buffers(struct folio *folio, size_t from, size_t to)
 {
-	struct page *page = &folio->page;
 	unsigned int block_start, block_end;
 	struct buffer_head *head, *bh;
 
-	BUG_ON(!PageLocked(page));
-	if (!page_has_buffers(page))
+	BUG_ON(!folio_test_locked(folio));
+	head = folio_buffers(folio);
+	if (!head)
 		return;
 
-	bh = head = page_buffers(page);
+	bh = head;
 	block_start = 0;
 	do {
 		block_end = block_start + bh->b_size;
 
 		if (buffer_new(bh)) {
 			if (block_end > from && block_start < to) {
-				if (!PageUptodate(page)) {
+				if (!folio_test_uptodate(folio)) {
 					unsigned start, end;
 
 					start = max(from, block_start);
 					end = min(to, block_end);
 
-					zero_user_segment(page, start, end);
+					folio_zero_segment(folio, start, end);
 					set_buffer_uptodate(bh);
 				}
 
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

