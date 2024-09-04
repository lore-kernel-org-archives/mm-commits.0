Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7712477101
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423538; cv=none; b=MaFc24khDCAWFNY3V6wU5WzKYfmZweP0cVIu+BnafQpxLvTocEJxZ4mu6tnqhgKb2y5AJHsFAjGYZwTXiXM98M5kUIShdlhMt1vff4XPRLVUOvIIjBnHYTOkW7Bwiu/CJNVFpxO1cEfXD/2cvcvmHZHe/X4cOx3HfNFt+wOBrAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423538; c=relaxed/simple;
	bh=Iv6ZgcMSqkPoyewvPudzD7UO3uWYQ7LbwQ5D1B5PReg=;
	h=Date:To:From:Subject:Message-Id; b=lGaMvLvqPEqGR8K6GNjnzKzRcOOO1HBmyuIZE6IZ780qgIfURGcw6l6y//JSZJkTj8t1R59pDrHqouCtOZLvJ1GF8AULDt007e2HlimuWyGYSnRwYbck31786emGiO2sUvt+aBeF5dK/F72vDNuN6n8QXAADnqKsJV9QhQ0oMuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f6rk4t7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f6rk4t7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DED3C4CEC2;
	Wed,  4 Sep 2024 04:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423538;
	bh=Iv6ZgcMSqkPoyewvPudzD7UO3uWYQ7LbwQ5D1B5PReg=;
	h=Date:To:From:Subject:From;
	b=f6rk4t7bsCZTPTsGnqc4z2NA/+MInvtljQ6aGRcBuyQ6CDL4hyKemQXSgFZYmzXl2
	 foEh26bvThc3bq4oYGCPjeJvzJflgGN6EsbAfz8PlqdDhB5icbwrtQP+ORuV31E2q/
	 AdykSo88HzHlPM1MzOqjhhITFVWom3OWM3RjwWV4=
Date: Tue, 03 Sep 2024 21:18:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,liyuesong@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-writeback-use-folio_next_index-helper-in-writeback_iter.patch removed from -mm tree
Message-Id: <20240904041858.4DED3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm:page-writeback: use folio_next_index() helper in writeback_iter()
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-use-folio_next_index-helper-in-writeback_iter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuesong Li <liyuesong@vivo.com>
Subject: mm:page-writeback: use folio_next_index() helper in writeback_iter()
Date: Wed, 21 Aug 2024 14:31:12 +0800

Simplify code pattern of 'folio->index + folio_nr_pages(folio)' by using
the existing helper folio_next_index().

Link: https://lkml.kernel.org/r/20240821063112.4053157-1-liyuesong@vivo.com
Signed-off-by: Yuesong Li <liyuesong@vivo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-page-writeback-use-folio_next_index-helper-in-writeback_iter
+++ a/mm/page-writeback.c
@@ -2612,7 +2612,7 @@ struct folio *writeback_iter(struct addr
 
 done:
 	if (wbc->range_cyclic)
-		mapping->writeback_index = folio->index + folio_nr_pages(folio);
+		mapping->writeback_index = folio_next_index(folio);
 	folio_batch_release(&wbc->fbatch);
 	return NULL;
 }
_

Patches currently in -mm which might be from liyuesong@vivo.com are


