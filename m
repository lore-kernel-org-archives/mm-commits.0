Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E516541DE01
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525589; cv=none; b=cFkS5nBvtWsfaJm+rzo1FXoxDiWSjaZVKVufMjFui9GFiWxmsNOkKuGyTZy5TxW7jtCV/lwHBcu+HMWkmJF+u/QDjuSCJsaCzI2vuOcxDXUNeWfYwKJdg/AbiTaayOZrUl4QpFsvPyWuhA+7uvT4eou7jPuj2pFkxJ4a2RBsT7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525589; c=relaxed/simple;
	bh=XiFbdKshswtPf2Mo3ypPHmgr2G/QZbo2x4B3wk61kxc=;
	h=Date:To:From:Subject:Message-Id; b=cPDD1W1iwE74QSIPJkLo8mY7Hig4nM+Gf0KrQFrJrdx0ZUYk4fmAhWnVeeS8JDjtJIq0cKS4U4TEQDbL/j3+CMqGvWQWfQC24uabYyadGbF8pnltaIUoucTrAMk+HG3sJqB2MOnEgfFfBLGFmeG0CgXzucKNmcYAUrikmsyPdxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K8Cdt+IM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K8Cdt+IM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71A41F0089A;
	Fri,  9 Oct 2026 05:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525586;
	bh=nsqGE+ohApQa9xUZdTWBmMJ32paIVkbLCaDt0FS0oB0=;
	h=Date:To:From:Subject;
	b=K8Cdt+IMMtlNqDvymgcSDUJbVTY8SaxcedZx9z6mXEMRPeLyNDq3y6ReAdlpxij5r
	 KhX5KeJCdfb7GKnrxe6LRNeHX3Wg/WOrQBLkVYzPZt9RKX++uIG+rqNsuLU4BWjRV2
	 54iTKgNuv+o+c9nvceugZpux+XsBnkHsEuX9gtt0=
Date: Thu, 08 Oct 2026 22:59:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,david@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] md-use-folio-apis-in-free_page.patch removed from -mm tree
Message-Id: <20261009055946.B71A41F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: md: use folio APIs in free_page()
has been removed from the -mm tree.  Its filename was
     md-use-folio-apis-in-free_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: md: use folio APIs in free_page()
Date: Sun, 20 Sep 2026 22:28:10 -0400

Convert the page to a folio.  This removes some of the last uses of a few
page APIs (detach_page_private(), page_buffers()).  Replaces two calls to
compound_head() with one.

Remove the early return in free_buffers() to avoid memory leak and
uninitialized file bitmap pages.[1][2]

[ziy@nvidia.com: drop early return]
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-14-bb68b6a21869@nvidia.com
Link: https://sashiko.dev/#/patchset/20260913-remove-pg_private-v4-0-848550f7574e%40nvidia.com?part=2 [1]
Link: https://lore.kernel.org/all/aqgfA0QFi98gXYG2@casper.infradead.org/ [2]
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---

 drivers/md/md-bitmap.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/md/md-bitmap.c~md-use-folio-apis-in-free_page
+++ a/drivers/md/md-bitmap.c
@@ -533,19 +533,15 @@ static void write_file_page(struct bitma
 
 static void free_buffers(struct page *page)
 {
-	struct buffer_head *bh;
+	struct folio *folio = page_folio(page);
+	struct buffer_head *bh = folio_detach_private(folio);
 
-	if (!PagePrivate(page))
-		return;
-
-	bh = page_buffers(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
 		bh = next;
 	}
-	detach_page_private(page);
-	put_page(page);
+	folio_put(folio);
 }
 
 /* read a page from a file.
_

Patches currently in -mm which might be from willy@infradead.org are


