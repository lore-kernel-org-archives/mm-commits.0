Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E28925757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957097; cv=none; b=TIQY/ec+oaLQrIxNTgqgMz8BpnJFNTPrGpySM/eGur+Nu1csnKz6UiH3kZ8xGYgcUPkMnSVL/C1OaBkwPcbk0uM8FcAAozPI+FrqCie7L7bLLnX+MpoE3jirdrt8ZOCNztz8PRgObQfs/8WMHQpccFAdnJPpoUEr7DvAA7QxIno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957097; c=relaxed/simple;
	bh=xcwGpFr/SrhPGdXfjartY0luY7MUS4i94AMRKZ8d984=;
	h=Date:To:From:Subject:Message-Id; b=i1VKDU0kECEIg1LL2fVvTtFSIb4mJ38i25d/Eg9pS+s/2ix33DfE/WtxVGeqUw+qA3oRu8rO2oBjFAQieFDTgK1YWbL6XIZ33DuygbW6zCqO+0tIqTMu2YN+eS04qiVH/LtEE8RBPlCvJ/1Rty4ffSFusSB4ONMmNYiJRR0FZaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=meM88L99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="meM88L99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E73C113CC;
	Mon,  6 May 2024 00:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957097;
	bh=xcwGpFr/SrhPGdXfjartY0luY7MUS4i94AMRKZ8d984=;
	h=Date:To:From:Subject:From;
	b=meM88L998chy3BvCYw8Qp/VV7nMMxu6s3s+LRTOYanzgCUQ2OBuQURpJ0MiddkjsS
	 znJb6WInw1HLiJSxqH0UJG7NUYaGvKGm/qnkZVeTp+5hECHKSO/0gF/ssxD9b7Ed72
	 ujKDaPV2QjYsCM97d5QuZSR2r/oxqTq/fPzaFOSA=
Date: Sun, 05 May 2024 17:58:16 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,linmiaohe@huawei.com,ebiggers@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-failure-remove-calls-to-page_mapping.patch removed from -mm tree
Message-Id: <20240506005817.74E73C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory-failure: remove calls to page_mapping()
has been removed from the -mm tree.  Its filename was
     memory-failure-remove-calls-to-page_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memory-failure: remove calls to page_mapping()
Date: Tue, 23 Apr 2024 23:55:34 +0100

This is mostly just inlining page_mapping() into the two callers.

Link: https://lkml.kernel.org/r/20240423225552.4113447-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~memory-failure-remove-calls-to-page_mapping
+++ a/mm/memory-failure.c
@@ -216,6 +216,7 @@ EXPORT_SYMBOL_GPL(hwpoison_filter_flags_
 
 static int hwpoison_filter_dev(struct page *p)
 {
+	struct folio *folio = page_folio(p);
 	struct address_space *mapping;
 	dev_t dev;
 
@@ -223,7 +224,7 @@ static int hwpoison_filter_dev(struct pa
 	    hwpoison_filter_dev_minor == ~0U)
 		return 0;
 
-	mapping = page_mapping(p);
+	mapping = folio_mapping(folio);
 	if (mapping == NULL || mapping->host == NULL)
 		return -EINVAL;
 
@@ -1090,7 +1091,8 @@ out:
  */
 static int me_pagecache_dirty(struct page_state *ps, struct page *p)
 {
-	struct address_space *mapping = page_mapping(p);
+	struct folio *folio = page_folio(p);
+	struct address_space *mapping = folio_mapping(folio);
 
 	SetPageError(p);
 	/* TBD: print more information about the file. */
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

