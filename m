Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C551427280A
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 20:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785531533; cv=none; b=m6LkYrjM10rAdgFx+BD46miSbciEDRvpe9rUgF4mU3nVeO3A3MzY+zKgMs8Dn3+5upg2pdkE4IYLrQq82fMoXISccrndS+gC0QnfnuG2HufnwLq7AA/AyGBAnct6DOvNgVVMF9OmVi1rB191kU5G6gMt4EcJGngXgcFHkncTQEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785531533; c=relaxed/simple;
	bh=GgVRaYCILGXWGU64ZUoS74MGRuffP3V3v+o6/MDGkcI=;
	h=Date:To:From:Subject:Message-Id; b=N3MilfPAOBMQfEGVOll8ZPWwaFupyM1uMsZYcYTPj5Z82sW7+KlQI7Z6zJU3PYJiWsF5Eq+2Ee1JvdGw2Rk3QpiEoFoIy8pzF0cCuWiEfz0HvTfICw83VbsIZseZqd6auG+kssq66trJMVVfYYi2hpNauhoXaKNKv5jIybCTYJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jHaJAL4O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jHaJAL4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3921F00AC4;
	Fri, 31 Jul 2026 20:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785531531;
	bh=su27sk1qJYuNXbXXjvf2QZaKPkU3EGHud0T0SI9UGRo=;
	h=Date:To:From:Subject;
	b=jHaJAL4Or/P6hadTuJydEuWn6IechyLSTseF0s7JtbhKM07dphOW52LH92CYB8ONW
	 S9OYluLIoTVfGIFrd28iYvgw7bRm1rRqYEK56gmRSApAe6MuTSbC2zN63J+z8Hcy6J
	 otZU0jwiyxQADj6c+jPMX5UEp+b5XUzgL32U3HQI=
Date: Fri, 31 Jul 2026 13:58:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,william.kucharski@oracle.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-honor-xa_flags_account-in-xas_split_alloc.patch added to mm-new branch
Message-Id: <20260731205851.3B3921F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
has been added to the -mm mm-new branch.  Its filename is
     xarray-honor-xa_flags_account-in-xas_split_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-honor-xa_flags_account-in-xas_split_alloc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Thu, 30 Jul 2026 22:18:01 -0400

XArray operations that allocate xa_nodes, such as xas_nomem() and
xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set. 
This charges the allocated memory and avoids the workingset convergence
issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
regression").

xas_split_alloc() does not have that flag. Add it when necessary.

Link: https://lore.kernel.org/20260730-add-gfp_account-to-xas_split_alloc-v2-2-5a56c2361d85@nvidia.com
Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
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

