Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A871322089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957100; cv=none; b=JsOyNl1Li5Zk0rajp2kC5xrAjjSHmxgdJzb+gzfKMqMbPddwpv7fT3cX9r6zp5qjeadlzSIAyZvEnABRXgZvZyO6grfkp2qfDsu7MbTpAZIgSOh8rs+CbDCZllThLEF8kmjrgXg3MQqCyVyxK8XQQHxpKf+S+rBcPsXrxo/P9vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957100; c=relaxed/simple;
	bh=yGcuQIdnzGD3oMVoS8UCJhptsizbZ60fWgL/0XYfLNQ=;
	h=Date:To:From:Subject:Message-Id; b=IwP5zrQSvvdJMp5uJIYT9LpMPxynI+51t/kDYDhSVpIMqGstWdmrRjSa6Iz1MFya/SFQ71MYqGxSDhFKgEwC2BPBtp5RYgyRm0QeXU6P5wbpv/9znfQ1J51z4OlemM/jvG9olS+xHY0YK5YpQnZx1y38S4/JM6AzU3RUV0cJFLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EDQ9RS4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EDQ9RS4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB9CC113CC;
	Mon,  6 May 2024 00:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957100;
	bh=yGcuQIdnzGD3oMVoS8UCJhptsizbZ60fWgL/0XYfLNQ=;
	h=Date:To:From:Subject:From;
	b=EDQ9RS4pCjauKXdYHSktcbAgMXA/jV68QBatjpzWgFIotcn0CcuCjoJI2KZRyvbs3
	 y7K/6n81ow6U6iPO/OaEVRoAWkkcR2O+TDxikBbB4tnSvKCud+EZYYguDnnlwxmnBw
	 6l9kG4aHMGaVTM6KgQkf5jPqxxzLomSSyCCG0SRw=
Date: Sun, 05 May 2024 17:58:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_cache_alloc.patch removed from -mm tree
Message-Id: <20240506005820.7FB9CC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_cache_alloc()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_cache_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_cache_alloc()
Date: Wed, 24 Apr 2024 20:19:06 +0100

Patch series "More folio compat code removal".

More code removal with bonus kernel-doc addition.


This patch (of 7):

All callers have now been converted to filemap_alloc_folio().

Link: https://lkml.kernel.org/r/20240424191914.361554-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240424191914.361554-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-page_cache_alloc
+++ a/include/linux/pagemap.h
@@ -558,11 +558,6 @@ static inline struct page *__page_cache_
 	return &filemap_alloc_folio(gfp, 0)->page;
 }
 
-static inline struct page *page_cache_alloc(struct address_space *x)
-{
-	return __page_cache_alloc(mapping_gfp_mask(x));
-}
-
 static inline gfp_t readahead_gfp_mask(struct address_space *x)
 {
 	return mapping_gfp_mask(x) | __GFP_NORETRY | __GFP_NOWARN;
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

