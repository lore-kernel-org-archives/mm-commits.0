Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE7C1E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010996; cv=none; b=nFP6dLgsXok+EDWyqrr6Dziggx0a04VRxXQ1VQauVVzs/esKh9gDjxvkLWOTL7rQ2dSNvfzVp9GlFiE1d08qazfrzHh1VmxmBBEncA9ZsBvMFCeNVrVymNRQu01InQBkRKQUCbBM4+TJUy/iF+PAs5CheUClMsj6mjI8+s6IwUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010996; c=relaxed/simple;
	bh=EzibMXJadzJAkFHOVIjkELEnrizhevPReaEjbGjW3iM=;
	h=Date:To:From:Subject:Message-Id; b=te8vZMeFPsU5UeeBkV6mnoR2umoSla1aa6ZwhOSO/PN2Shb+RgLOkPeo8TVpYV0OdfYSMzqQ1tG2iwR7RiQ30OmTUQsvW334Wc+02eY6Z0trmfu9nKS3xZlSfDzK3D9FgEJjRIG4ECv6DmIv8DWZRhTXxAp5N8XoiqMaTTNEBpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ui1odV7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ui1odV7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F778C4CEED;
	Mon, 12 May 2025 00:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010996;
	bh=EzibMXJadzJAkFHOVIjkELEnrizhevPReaEjbGjW3iM=;
	h=Date:To:From:Subject:From;
	b=Ui1odV7TRh5pUVBiafD+2leIdqrMCLx6BpfHhI9y0zpGbFRF33YPOFkV+IMvsYrg5
	 0CWHxS+xkdgJP3GMWpfwZTcD2H2wQJJleaxTofyblFDRfdNFNYwSHD1iQVeBGTsW+P
	 /0EF7/QnHPNKnEGJu7cIVvDS9pV+mbbTRnvxFHBE=
Date: Sun, 11 May 2025 17:49:55 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-convert-__readahead_batch-to-use-a-folio.patch removed from -mm tree
Message-Id: <20250512004956.3F778C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: convert __readahead_batch() to use a folio
has been removed from the -mm tree.  Its filename was
     filemap-convert-__readahead_batch-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: convert __readahead_batch() to use a folio
Date: Wed, 2 Apr 2025 22:06:08 +0100

Extract folios from i_mapping, not pages.  Removes a hidden call to
compound_head(), a use of thp_nr_pages() and an unnecessary assertion that
we didn't find a tail page in the page cache.

Link: https://lkml.kernel.org/r/20250402210612.2444135-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/include/linux/pagemap.h~filemap-convert-__readahead_batch-to-use-a-folio
+++ a/include/linux/pagemap.h
@@ -1424,7 +1424,7 @@ static inline unsigned int __readahead_b
 {
 	unsigned int i = 0;
 	XA_STATE(xas, &rac->mapping->i_pages, 0);
-	struct page *page;
+	struct folio *folio;
 
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
 	rac->_nr_pages -= rac->_batch_count;
@@ -1433,13 +1433,12 @@ static inline unsigned int __readahead_b
 
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();
-	xas_for_each(&xas, page, rac->_index + rac->_nr_pages - 1) {
-		if (xas_retry(&xas, page))
+	xas_for_each(&xas, folio, rac->_index + rac->_nr_pages - 1) {
+		if (xas_retry(&xas, folio))
 			continue;
-		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		VM_BUG_ON_PAGE(PageTail(page), page);
-		array[i++] = page;
-		rac->_batch_count += thp_nr_pages(page);
+		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+		array[i++] = folio_page(folio, 0);
+		rac->_batch_count += folio_nr_pages(folio);
 		if (i == array_sz)
 			break;
 	}
_

Patches currently in -mm which might be from willy@infradead.org are


