Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067B9182AE
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628300; cv=none; b=I6lwD3JqZU3EYqb8DGt4ZNI0sAWbnvOYwp2Bs7+sKRFhdI5JEMK1rc7lOsoPDak0Cf+Enf2C+tRZmTwW4wh/qrBAjS+ke1o4kT7494CWtI1LgMTHONt9nTZEM8LmOof0Q8rrNFl/oQQgzH6asLAr07UnrVps0LZMr0KpulCL9ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628300; c=relaxed/simple;
	bh=fs4dVU70rcKIIyFyW3y3qhchY2OVvTDtgZUQwMWc+Jo=;
	h=Date:To:From:Subject:Message-Id; b=jZeZJ1F/2i+1j0LkZdToHoL+r6l1V9c/2Ql/shnRKQm1O7R37mXjurgTziT5wBlT+kp/UgK8fLMNN7e7n8pGhNx2wuxxf4NDN9Q6+1FHkLSo+QID2uCtjXwZJ3XSgkQy+kt8jMicjGMOT7CKUgEvExfqeWAp8pSeYqXCTpTOULA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wiHaZNYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wiHaZNYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3790C116B1;
	Sat, 29 Jun 2024 02:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628299;
	bh=fs4dVU70rcKIIyFyW3y3qhchY2OVvTDtgZUQwMWc+Jo=;
	h=Date:To:From:Subject:From;
	b=wiHaZNYRRSnFP4ROlKnQGrL3rEPqFMmwrg5tR7ltyKSE8BT2rnzGpx+KwfCSi9t+w
	 8G5nPMeLaWoM/pw81zty7iBz0u3ifxLzBQ6yzB3wE4eWuVQKO+Z6RqUpmGhlKBKSB9
	 cl9Tp/FaB31I7+a5QLALp0NseAHO8wDvTssuDNto=
Date: Fri, 28 Jun 2024 19:31:39 -0700
To: mm-commits@vger.kernel.org,zhangpengpeng0808@gmail.com,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-drop-dead-code-in-page_cache_ra_order.patch removed from -mm tree
Message-Id: <20240629023139.D3790C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: drop dead code in page_cache_ra_order()
has been removed from the -mm tree.  Its filename was
     readahead-drop-dead-code-in-page_cache_ra_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: drop dead code in page_cache_ra_order()
Date: Tue, 25 Jun 2024 12:18:56 +0200

page_cache_ra_order() scales folio order down so that is fully fits within
readahead window.  Thus the code handling the case where we walked past
the readahead window is a dead code.  Remove it.

Link: https://lkml.kernel.org/r/20240625101909.12234-6-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Zhang Peng <zhangpengpeng0808@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/readahead.c~readahead-drop-dead-code-in-page_cache_ra_order
+++ a/mm/readahead.c
@@ -525,11 +525,6 @@ void page_cache_ra_order(struct readahea
 		index += 1UL << order;
 	}
 
-	if (index > limit) {
-		ra->size += index - limit - 1;
-		ra->async_size += index - limit - 1;
-	}
-
 	read_pages(ractl);
 	filemap_invalidate_unlock_shared(mapping);
 	memalloc_nofs_restore(nofs);
_

Patches currently in -mm which might be from jack@suse.cz are


