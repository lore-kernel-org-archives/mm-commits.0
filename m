Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21118339381
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465811; cv=none; b=T9FAub1CpxoEqMtfkMPROKnpjjpggoe+gB3fAhi8ZWIBK1qRhEv8d9sw49qPYOdXAuR2sSKLf8JOkPa6huc7FvBiEuhST8vsS/xgPlThfwOrTsT4/+sonXPFk5vb3zuRzcbjFk5n6boUMRRf14+aMkvDdGyHG7bvI2Cxqdcwjus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465811; c=relaxed/simple;
	bh=8ynGxZumbLjz5aTFJZJMTpsAFQcYk/2VndkT7zEd9R8=;
	h=Date:To:From:Subject:Message-Id; b=cKDj4kq3RcIutUIb8E4bUTXURvplqD/0EmQvYUZrAO1ctU8fMzKTRfGgIcWqHcDf8Duz2yfOJ91gQrj7ZRxQFjcQkxIAYIXmvlKBpfuCyVqtwjFLMlpiRVDWi06cKIZeLFHONjXv4BI4Cuj/kTkgkou9N+vYaBmtbDeGwEL2y50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GpIE2mI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GpIE2mI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80061F000E9;
	Fri, 31 Jul 2026 02:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465810;
	bh=r6nmJFf8qUkfp+leaAwdI78k+oWQWl5skL8+TTL4zJU=;
	h=Date:To:From:Subject;
	b=GpIE2mI2pkJJLm2UFQ68W1QxMOIQCQ1gcRCcMGWO/sX/OOsp33kZedVye57PVo374
	 VcJl668UqFVO7RsT671Ea/9STf7TuUhQjyQI7a94wOit9qr04KdoDfg5Cm8AJSKW9t
	 UEi/oWGQMg3DL7M/P0Ywg24i+vV5FwPMDOowaRrc=
Date: Thu, 30 Jul 2026 19:43:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-__alloc_pages_node.patch removed from -mm tree
Message-Id: <20260731024329.E80061F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove __alloc_pages_node()
has been removed from the -mm tree.  Its filename was
     mm-remove-__alloc_pages_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: remove __alloc_pages_node()
Date: Fri, 03 Jul 2026 12:31:53 +0000

There were only a few users, which have been removed.  The only advantage
of this API over alloc_pages_node() is avoiding a single conditional
branch.  The disadvantages are:

1. More API surface, more sources of confusion, more maintenance.

2. Worse impact of CPU hotplug bugs: most users of __alloc_pages_node()
   were using the result of cpu_to_node(); if the CPU gets hotplugged
   out this will return NUMA_NO_NODE. If one of these paths fails to
   protect against a concurrent hotplug then page_alloc.c will use
   NUMA_NO_NODE as an index into NODE_DATA() and cause some horrible
   memory corruption or other. With alloc_pages_node(), the code might
   just work fine.

Ulterior motive: this frees up the __* variants of the allocator APIs to
serve specifically for use as mm-internal API.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-13-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/include/linux/gfp.h~mm-remove-__alloc_pages_node
+++ a/include/linux/gfp.h
@@ -256,21 +256,6 @@ static inline void warn_if_node_offline(
 	dump_stack();
 }
 
-/*
- * Allocate pages, preferring the node given as nid. The node must be valid and
- * online. For more general interface, see alloc_pages_node().
- */
-static inline struct page *
-__alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
-{
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-	warn_if_node_offline(nid, gfp_mask);
-
-	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
-}
-
-#define  __alloc_pages_node(...)		alloc_hooks(__alloc_pages_node_noprof(__VA_ARGS__))
-
 static inline
 struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
@@ -293,7 +278,10 @@ static inline struct page *alloc_pages_n
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	return __alloc_pages_node_noprof(nid, gfp_mask, order);
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	warn_if_node_offline(nid, gfp_mask);
+
+	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
 }
 
 #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

