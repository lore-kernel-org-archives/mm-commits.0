Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048AD22ACEF
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 02:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766457576; cv=none; b=S2wY36ZhadE1uY0VbTSB8dQ1GiwTurKwKj97NgJU6wldNH0JS2dEJj6WfjDhT2NXiSGbSh+jEPFgtmVKbBFjDd9lKy0ygrtynHS2k5vozeSdPvpd7XGLfHh6gU1U9/JeFy5YYRtS4ViYYcOHkPv0vdWtFEjibLGolVbZ5Pi6Pig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766457576; c=relaxed/simple;
	bh=Y0XscRkA2/7l/Lka4iXaXXAmZwOQI1JiyHmVKVWFx7Y=;
	h=Date:To:From:Subject:Message-Id; b=ouccDktBGdNMb6i/7M5g53PciIP+KCG4gw91+MBZnDibFC9X/kQrmd7q5nqtopQYiSs/9EfkSHbIIP6jDkqITotGJBGl+EZ5pyd9IYjBmf9hulPtkhtD9hW9OZ+CdZacQnZrW03gltdbkRG2kVxQbz0Y3huL5G1l32Pjypy008c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w5A7qdMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w5A7qdMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7414FC4CEF1;
	Tue, 23 Dec 2025 02:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766457575;
	bh=Y0XscRkA2/7l/Lka4iXaXXAmZwOQI1JiyHmVKVWFx7Y=;
	h=Date:To:From:Subject:From;
	b=w5A7qdMukbGq2ZqCIqXqVHRIDUEBcTJh9GXwFdoIdQOWBtUHiYPBpyKtPqPfbLyeg
	 CCuLAy0A2L4pyErNYr0ekskdF+VB/0T9/OZtV6HUpc3RjwgtCUoJvA0AJ1lKvBdNVa
	 0oa+TZTxAEx+4+h5bMb+8/gfiPfxrg4amsaav9g8=
Date: Mon, 22 Dec 2025 18:39:34 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-simplify-page-tracking-in-remap_page-during-folio-split.patch removed from -mm tree
Message-Id: <20251223023935.7414FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: simplify page tracking in remap_page() during folio split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-simplify-page-tracking-in-remap_page-during-folio-split.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: simplify page tracking in remap_page() during folio split
Date: Mon, 22 Dec 2025 13:45:31 +0000

After splitting a large folio, the resulting anonymous folios must be
remapped.

Currently, the code tracks progress by recording the number of processed
pages in an index variable (e.g., @i) and comparing it against the
total. This commit simplifies the logic by directly subtracting the
processed pages from the remaining count. This approach is more
straightforward and reduces the number of local variables.

Additionally, this commit renames the variable nr to nr_pages to improve
code readability and self-documentation.

Link: https://lkml.kernel.org/r/20251222134531.20968-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-simplify-page-tracking-in-remap_page-during-folio-split
+++ a/mm/huge_memory.c
@@ -3423,17 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_are
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_page(struct folio *folio, unsigned long nr_pages, int flags)
 {
-	int i = 0;
-
 	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
 	if (!folio_test_anon(folio))
 		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
-		i += folio_nr_pages(folio);
-		if (i >= nr)
+		nr_pages -= folio_nr_pages(folio);
+		if (!nr_pages)
 			break;
 		folio = folio_next(folio);
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


