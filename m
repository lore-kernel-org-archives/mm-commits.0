Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0137314012
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 00:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745799500; cv=none; b=Nake3zwyQmHnuv8WEu08GKM0y/ZYFMI9jFPv2SRiVRJJZ2ThJd5ybuDivzhhBykKkLRNHuvcr6mPUpbE+YRTXpEn9PfO/BOwMPkE+cjCKie5m6nZA3cEeQu5OOSzDsaAbJF1LZm602J8aINaZa4uwF7i7HIKTegA9+WuMyFRf/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745799500; c=relaxed/simple;
	bh=mIlUzDmlh8dr/SJBULNv6gWN/I1vQWNZTIJNuorJgQk=;
	h=Date:To:From:Subject:Message-Id; b=t+P8iGcJrAlVINLEEDysC1QO0pq7TiyDp2IOwI/enIa91NODxe7ozVJKZzHk1nLCJvX0VBB7wAQVO5osYmVRgxXsqCiuaxw7wWrCrS12lETLPW6vTG05eTIWqvrCb4hplm5KV0uSxWEwhmH+MRQHqa5cSVZOXdrmdJ3sZd+u7us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gndwVY5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gndwVY5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D17C4CEEC;
	Mon, 28 Apr 2025 00:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745799499;
	bh=mIlUzDmlh8dr/SJBULNv6gWN/I1vQWNZTIJNuorJgQk=;
	h=Date:To:From:Subject:From;
	b=gndwVY5R1lg7jnxU2licjRiXDxKkeMBawAdCFQJgvU+4dajYheKZhpPLwadm1PvE7
	 WzmYHgds4cWIkVCnKrHgXGEgF/t58W8EQfvP1K2HogcvqdxLx0+aVZhhbvll9ZhsH5
	 tSk264LW5Io4vmcty1uCZPPFe6KC+2o0Nlvxu284=
Date: Sun, 27 Apr 2025 17:18:18 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rppt@kernel.org,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch added to mm-unstable branch
Message-Id: <20250428001819.62D17C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/numa: remove unnecessary local variable in alloc_node_data()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/numa: remove unnecessary local variable in alloc_node_data()
Date: Sun, 27 Apr 2025 18:04:42 +0800

The temporary local variable 'nd' is redundant.  Directly assign the
virtual address to node_data[nid] to simplify the code.

No functional change.

Link: https://lkml.kernel.org/r/20250427100442.958352-4-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/numa.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/numa.c~mm-numa-remove-unnecessary-local-variable-in-alloc_node_data
+++ a/mm/numa.c
@@ -13,7 +13,6 @@ void __init alloc_node_data(int nid)
 {
 	const size_t nd_size = roundup(sizeof(pg_data_t), SMP_CACHE_BYTES);
 	u64 nd_pa;
-	void *nd;
 	int tnid;
 
 	/* Allocate node data.  Try node-local memory and then any node. */
@@ -21,7 +20,6 @@ void __init alloc_node_data(int nid)
 	if (!nd_pa)
 		panic("Cannot allocate %zu bytes for node %d data\n",
 		      nd_size, nid);
-	nd = __va(nd_pa);
 
 	/* report and initialize */
 	pr_info("NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
@@ -30,7 +28,7 @@ void __init alloc_node_data(int nid)
 	if (tnid != nid)
 		pr_info("    NODE_DATA(%d) on node %d\n", nid, tnid);
 
-	node_data[nid] = nd;
+	node_data[nid] = __va(nd_pa);
 	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch
mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch
fs-proc-page-refactoring-to-reduce-code-duplication.patch
mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch
mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch
mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch
mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch
mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch

