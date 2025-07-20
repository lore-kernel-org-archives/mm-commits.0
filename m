Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC9113AD3F
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976913; cv=none; b=iJYDyGk9js5KMM+XXoh4SFaHtB1zWMWrkYdbzI2V4hHqdq+mBqsl2N9jiVihOXpMdoxEkfw0T5SMGN6vq77QSsrvYCXHlZ/Ek39ZfzR2hj0b4GuwH9GaODLJhXZzZrcTNdbrqj2+gVhvF0LK4+O7Z8LumuyQrV4DSwsZqjjFOKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976913; c=relaxed/simple;
	bh=X9jVfslb7A9SZcjRvP5eFPMNAjhYzn8Sga6G3DvTkTg=;
	h=Date:To:From:Subject:Message-Id; b=Z5TvIy3W85j4Kk0Ao5Won6oETfkDW9txe9IHJnTSqPwJxDmzbevqNpMTwxVVu5+mz+rWPTtUbMG8sUPaUGqUqFiay22O5/6zPDStQNXgN8m9P0BXsW3YptcVaVBUudjB/iYQVX40bjZ82S1a1ee2pRAQf+xDEWQ3y/hJtkRCm+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J+n+cfIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J+n+cfIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B0BC4CEE3;
	Sun, 20 Jul 2025 02:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976912;
	bh=X9jVfslb7A9SZcjRvP5eFPMNAjhYzn8Sga6G3DvTkTg=;
	h=Date:To:From:Subject:From;
	b=J+n+cfIvtApi339nnkC2DoBZfyC3QTP9okoR/pJHzuTZ6N7PeyzP1JrfS+z72xjyi
	 XDHCwkR66zvXBFYqSm1Sh86v12PxaWlXt4NGs7PScBUNvIgv4GNt2xy1s4MC9HPmLl
	 M7LLA2XP4ZNouXwaeNsPK0seTOCFQU0vjOOuB8CI=
Date: Sat, 19 Jul 2025 19:01:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@jordanrome.com,david@redhat.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unmap_and_put_page.patch removed from -mm tree
Message-Id: <20250720020152.B2B0BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unmap_and_put_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-unmap_and_put_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: remove unmap_and_put_page()
Date: Wed, 9 Jul 2025 12:40:18 -0700

There are no callers of unmap_and_put_page() left. Remove it.

Link: https://lkml.kernel.org/r/20250709194017.927978-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jordan Rome <linux@jordanrome.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/highmem.h~mm-remove-unmap_and_put_page
+++ a/include/linux/highmem.h
@@ -682,10 +682,4 @@ static inline void folio_release_kmap(st
 	kunmap_local(addr);
 	folio_put(folio);
 }
-
-static inline void unmap_and_put_page(struct page *page, void *addr)
-{
-	folio_release_kmap(page_folio(page), addr);
-}
-
 #endif /* _LINUX_HIGHMEM_H */
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


