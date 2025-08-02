Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EB01C3C18
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160836; cv=none; b=VuWFKohTVFB9DA1CUtHG1T7N3yBCIR1oeGtyE/2c5EKjY2tL8y2V1bYF4Nf0O9d/tXmCnUl9SItEvh5vVg6PJlFEYn+Kk88gXzAFD2pl4aF9D4FZOhGqEFWn4SKlzsdqd+vZkSWUQUym9CQMK+xB9hwlrY75itEvquvPZNsXl0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160836; c=relaxed/simple;
	bh=Ir/UvfpmZWWtFj61xBrk5eZffbrvy00riaI7oIththw=;
	h=Date:To:From:Subject:Message-Id; b=m13bEf3T/cIIgT3u+Tdci3XSdPNIRgPtngex+ua5JJBqL6R49CtrR2wm8St2F2nynUHCjlfEjj7Mv2l9nAJNt9d1btF5mDEIiMAWY/jVvoaAWn4odqc4RiN4AG24f+Qrc/GnJEqu9h0iZQsacXLsUTOOcCT4sR9lA/lEvQGqDUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e1JpW+6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e1JpW+6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7FDC4CEEF;
	Sat,  2 Aug 2025 18:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160836;
	bh=Ir/UvfpmZWWtFj61xBrk5eZffbrvy00riaI7oIththw=;
	h=Date:To:From:Subject:From;
	b=e1JpW+6+WDCOd7fCJqbzzcouAa7hGcZOxiqK+e4t9acv8BTwIu4DL4N3dX53EnGIw
	 7PPS/D2xmKX6/wHoySNkcGTzGBMCehhyWeg/8DGsyMNj1zmH0O5fmT7jQmG8jgh/vs
	 yLwDx1OG3HsggJI11fv3yKUMuchVR2siTxkt4iwE=
Date: Sat, 02 Aug 2025 11:53:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-flags-remove-folio_start_writeback_keepwrite.patch removed from -mm tree
Message-Id: <20250802185356.9C7FDC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-flags: remove folio_start_writeback_keepwrite()
has been removed from the -mm tree.  Its filename was
     mm-page-flags-remove-folio_start_writeback_keepwrite.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm/page-flags: remove folio_start_writeback_keepwrite()
Date: Tue, 22 Jul 2025 11:22:30 -0700

Commit cd57b77197a4 ("ext4: Convert ext4_bio_write_page() to use a folio)
removed set_page_writeback_keepwrite() which was the last/only caller of
folio_start_writeback_keepwrite().

Link: https://lkml.kernel.org/r/20250722182230.2114587-1-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/page-flags.h~mm-page-flags-remove-folio_start_writeback_keepwrite
+++ a/include/linux/page-flags.h
@@ -837,8 +837,6 @@ void set_page_writeback(struct page *pag
 
 #define folio_start_writeback(folio)			\
 	__folio_start_writeback(folio, false)
-#define folio_start_writeback_keepwrite(folio)	\
-	__folio_start_writeback(folio, true)
 
 static __always_inline bool folio_test_head(const struct folio *folio)
 {
_

Patches currently in -mm which might be from joannelkoong@gmail.com are


