Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0606025761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742208; cv=none; b=mX2xhrnTUwX/MNXwNBo24f5oVY8zTzId97rUupB3sjjES1y3Ey8R2COiUQu2Kz3fzZLmPxk8VPbxGkQjMubzkEM1b3ffJ+AMFz/N6A56ZnoRnQLHi9EqoIn0a7XvIGGBW3pPO6jp4KI+a2bGWpuk7MPwu8D3AWcbe/NLXt5TSSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742208; c=relaxed/simple;
	bh=IJJAr/Jq7urwm14D2x45ud30hfHmrGVB1TI+gCjeCno=;
	h=Date:To:From:Subject:Message-Id; b=pl8Y+6h5aXrQA1UVSjHcgg/aWBk0gHc5kctW7u6tkt0x3YHD6oBh1FOCdovFjbN48OWzCKqAeSbz5jmeorbJgPWomEfHVX3JMfDM0k6I3lGa8kWB/qObZ8EAukY3U6wJAoHYKNp2Nd3HoJDnsqQlPoL/etOd/LDgBBSilKpd/Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rg41YL9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rg41YL9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AB1C4CED6;
	Mon, 13 Jan 2025 04:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742207;
	bh=IJJAr/Jq7urwm14D2x45ud30hfHmrGVB1TI+gCjeCno=;
	h=Date:To:From:Subject:From;
	b=rg41YL9xTFnCxD6SLYYlGUe5NVIIkKo0SwkxCbQwjwgxRXGmQCHAA+NTBp6KMrU61
	 vMpB64qmBtu0BexjcpnbwuDlnktSrUqwf7hgAu2omLlzJMiSoHKr8k7OIeG2/OoH9x
	 UJoJiymBFy6USqyOeUEyhVStt7WgacMz37ruvbJ8=
Date: Sun, 12 Jan 2025 20:23:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-a-folio-in-ocfs2_zero_new_buffers.patch removed from -mm tree
Message-Id: <20250113042327.C7AB1C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use a folio in ocfs2_zero_new_buffers()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-a-folio-in-ocfs2_zero_new_buffers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


