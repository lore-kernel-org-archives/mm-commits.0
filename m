Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11E12E8B83;
	Tue,  4 Aug 2026 23:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785884537; cv=none; b=tjUi58xRuPUliq8dAF2Ib+MNukmaaBy5vMv/c99Anj9Jb2+GW8p/emZnzntZ+a3G+aPCb2Yp7nOcQPibyTQ8SWqj8CW/iL6gE0GYIjfOYqpDdw/FU11qZ7K/Z5rCES4XrIGbWFmJo0KaBIkfP+doUXXPaHP6S1Ab03/mdXvmFnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785884537; c=relaxed/simple;
	bh=SQwArdutxfSjDK1t31roHVTCl8e6jsITKn9mSk71Uho=;
	h=Date:To:From:Subject:Message-Id; b=ODZTqPK97Hucf8ClW37VaW1bPkqBzoodFOBD0HsDwz0rezHncmrMlXob7fwc71dPEFfcifqQtOzfi0b7B8OYCVsOF0zK0MTWNgUxBC+mbYu9rDnVqQg/iXhaVIyFpydbUy5Xo1mIFRAI0/EbgCro5SdhLwBOaB+2uiflqIHM+gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OWcVmnBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OWcVmnBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5811F000E9;
	Tue,  4 Aug 2026 23:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785884535;
	bh=9Fkn5ZKGjhq0gqOoAtGBAzNIM506NRG1osW8HfhFs2w=;
	h=Date:To:From:Subject;
	b=OWcVmnByEEOqp6nj6lQjkmIgkszi2JmJV7vJ/CLL4C7BHFQS6wSK2o0qUnHrM7m5l
	 UsCZlmoMqmxAzUemcgdAF9s8PDNQSESGJ3l7XVV7mBVoXcX6/TToK3IeRMEUkH3zmj
	 jtLJ/3hteGSisKuT42GwjOViLsYVK9SubtOTmKp8=
Date: Tue, 04 Aug 2026 16:02:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,william.kucharski@oracle.com,stable@vger.kernel.org,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-honor-xa_flags_account-in-xas_split_alloc.patch added to mm-unstable branch
Message-Id: <20260804230215.8D5811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-honor-xa_flags_account-in-xas_split_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-honor-xa_flags_account-in-xas_split_alloc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
Date: Tue, 04 Aug 2026 17:04:28 -0400

XArray operations that allocate xa_nodes, such as xas_nomem() and
xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set. 
This charges the allocated memory and avoids the workingset convergence
issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
regression").

xas_split_alloc() does not add _GFP_ACCOUNT when XA_FLAGS_ACCOUNT is
present.  Fix it.

Link: https://lore.kernel.org/20260804-add-gfp_account-to-xas_split_alloc-v3-2-38cb3ff325c5@nvidia.com
Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/xarray.c~xarray-honor-xa_flags_account-in-xas_split_alloc
+++ a/lib/xarray.c
@@ -1053,6 +1053,9 @@ void xas_split_alloc(struct xa_state *xa
 	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
 		return;
 
+	if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
+		gfp |= __GFP_ACCOUNT;
+
 	do {
 		struct xa_node *node;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch
mm-huge_memory-use-folios-memcg-inside-__folio_split.patch
xarray-honor-xa_flags_account-in-xas_split_alloc.patch

