Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD3C364053
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388590; cv=none; b=HcxhIZedXGRYkSlo1TBd/8OUHtdllcxJWTq4EcA2nvUGCNyZeZQ32DrV7wsXEIG1vo8e3ea2D7hg/8ul7ju6khg1+ILfd9YsqTBWFHDUyictvTmG0PUUflQZUAXJ1fuTsJAOO263/tRteJvZdgSkphtYdqoWwgBcc60ONtWNDZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388590; c=relaxed/simple;
	bh=z1NishS7oKniWh+/BwHejlxzTZa417w9wgnWR5hfPG4=;
	h=Date:To:From:Subject:Message-Id; b=Xvg+ckPEZXEVfo0BFnAtNh2xzCVkodHsi7z/094SQeBVEzV+ZFgjtcbX3rrnG22bNM1x3WD2pQA6GbT3NkZDEb3Uc1e0nMXzTKPKciBiewEc2ajdTb7oBLvErbUjasS1RKNU6MUt+OYOGrxebf/7DK44tvnX4+yjt0UKr/ok2fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ClzMGUAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ClzMGUAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC89DC19424;
	Tue, 24 Mar 2026 21:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388589;
	bh=z1NishS7oKniWh+/BwHejlxzTZa417w9wgnWR5hfPG4=;
	h=Date:To:From:Subject:From;
	b=ClzMGUAGDXz+IeFSz3HhJOhgL/B61sQlXWVVjYOUcfP2+ENyhV3vvTbVISMmFLxpf
	 EkEmcT2Rkr3Uqq6az/WI4RFuumOh4eFjewOhgahR/yS1rc+q9HTxM2dWr+lvLhzAz7
	 2arf+s30oBbnr0Xh01XSatkWdtjAACwLVWk9Tb5A=
Date: Tue, 24 Mar 2026 14:43:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_test_lazyfree-helper.patch removed from -mm tree
Message-Id: <20260324214309.DC89DC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add folio_test_lazyfree helper
has been removed from the -mm tree.  Its filename was
     mm-add-folio_test_lazyfree-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: add folio_test_lazyfree helper
Date: Sat, 21 Feb 2026 17:39:17 +0800

Add folio_test_lazyfree() function to identify lazy-free folios to improve
code readability.

Link: https://lkml.kernel.org/r/20260221093918.1456187-4-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 +++++
 mm/rmap.c                  |    2 +-
 mm/vmscan.c                |    5 ++---
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/page-flags.h~mm-add-folio_test_lazyfree-helper
+++ a/include/linux/page-flags.h
@@ -724,6 +724,11 @@ static __always_inline bool folio_test_a
 	return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) != 0;
 }
 
+static __always_inline bool folio_test_lazyfree(const struct folio *folio)
+{
+	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
+}
+
 static __always_inline bool PageAnonNotKsm(const struct page *page)
 {
 	unsigned long flags = (unsigned long)page_folio(page)->mapping;
--- a/mm/rmap.c~mm-add-folio_test_lazyfree-helper
+++ a/mm/rmap.c
@@ -2060,7 +2060,7 @@ static bool try_to_unmap_one(struct foli
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+			if (folio_test_lazyfree(folio)) {
 				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
 					goto walk_done;
 				/*
--- a/mm/vmscan.c~mm-add-folio_test_lazyfree-helper
+++ a/mm/vmscan.c
@@ -963,8 +963,7 @@ static void folio_check_dirty_writeback(
 	 * They could be mistakenly treated as file lru. So further anon
 	 * test is needed.
 	 */
-	if (!folio_is_file_lru(folio) ||
-	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
+	if (!folio_is_file_lru(folio) || folio_test_lazyfree(folio)) {
 		*dirty = false;
 		*writeback = false;
 		return;
@@ -1508,7 +1507,7 @@ retry:
 			}
 		}
 
-		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+		if (folio_test_lazyfree(folio)) {
 			/* follow __remove_mapping for reference */
 			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are


