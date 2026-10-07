Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249D231F9B9
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334284; cv=none; b=cXEWPjkLwPwOrLtkQ6luoJg1ULWsVEyW8YhfTEG+gTWvZ0bNt3FDajvyHBs/Ck6U+uXZ40pYfTzqYsF0SQMiwLxPNIdJnJkCUmBUeE3AnO2565DKsNZwX6v7h1ZBWrItzCQnQxlSu8OQY4H0YApH+OqFuxDUcTLbL5Iu/FGwPVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334284; c=relaxed/simple;
	bh=LoP2f6k8wy0h00OwzMVaj621uUkiqVBdHLRagbGldDU=;
	h=Date:To:From:Subject:Message-Id; b=OOL8w74FEsvWtU8uO4aeiSQsNVG1ccLqqd8Xh166bGZYGASv5aTrQKUiuiIraLmzsIOQh2FQbQtP1jW2KvFeUxaP/G9dxwa9p3K8ysrSKIWmi3GfnAmIdOjp2zM0EQ3w76vAvz/DNnqqvFDV2fck+qrgU0vNh9Sib0F+6sU2/MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dZf7Vggc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dZf7Vggc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF301F0089B;
	Wed,  7 Oct 2026 00:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334283;
	bh=tFTPeCIBzy5O9sG99HhV7u1wgGcoV3X0yRlvmaBRhHE=;
	h=Date:To:From:Subject;
	b=dZf7VggcoDgG3ejA8HHDnuXbejDxi78YSUQpjzkqyCltQ84e6eYTeiqpyWYX3cgD0
	 bcY7ImpfbqvmWo3MJX6bAm/PXbq2oNC0tq8gnLPCFoKvJw7heYyNhzeUMbbhK/5aSN
	 +fkEZSh0zuaxkWm6GBNZTVKETYuTtEXig4czdiyw=
Date: Tue, 06 Oct 2026 17:51:22 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-hugepage_mem_bp-target-metric.patch removed from -mm tree
Message-Id: <20261007005122.EEF301F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: cocument hugepage_mem_bp target metric
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-hugepage_mem_bp-target-metric.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Subject: Docs/mm/damon/design: cocument hugepage_mem_bp target metric
Date: Mon, 31 Aug 2026 07:47:30 -0700

Document hugepage_mem_bp metric exposed by sysfs.

Link: https://lore.kernel.org/20260831144732.80910-4-sj@kernel.org
Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/mm/damon/design.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-hugepage_mem_bp-target-metric
+++ a/Documentation/mm/damon/design.rst
@@ -713,6 +713,8 @@ mechanism tries to make ``current_value`
   bp (1/10,000).
 - ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
   of a node in bp (1/10,000).
+- ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
+  (1/10,000).
 
 ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
 ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
_

Patches currently in -mm which might be from gutierrez.asier@huawei-partners.com are


