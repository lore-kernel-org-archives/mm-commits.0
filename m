Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6E91E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010983; cv=none; b=c9XD+ThkECz3XKoMdBs6KGeHToDio/FncpxKaVKNhLejyV7rPNNQu/9QWjgontcH0iYKUlLtvB4lXMMLuCp3F7+BwJ02gIpQmd8pZmjltlFwoUwzox6cnY+TBSvtmq/xdRNrpj+YsoTn0I3+htLskLI4wsjBn/U0uNfYllSa43c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010983; c=relaxed/simple;
	bh=c9Mk0Y9p7elVGH5wOIPD9fHgL/ooUP0j1y686jXl+oI=;
	h=Date:To:From:Subject:Message-Id; b=oZiwDTtdqNTGypp2/FhF7HCkgfZbHuDGQH7iPlgZ9VJkl7bx6qv6MhXP1gcOA5VPFJN+em2kuzaeCtmkqhztfUkWZXx9B5IN0Fg6hk++lmrJ15z2D4qoXz18zMiePwfqjrlhgCdHpK6zCbCP58DHzuso2SpXnd99YBrADDbiSDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c8gSwWm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c8gSwWm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC51C4CEE4;
	Mon, 12 May 2025 00:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010983;
	bh=c9Mk0Y9p7elVGH5wOIPD9fHgL/ooUP0j1y686jXl+oI=;
	h=Date:To:From:Subject:From;
	b=c8gSwWm9aAuVkqGrDM/D4Yb3FC65iH7XhCG3o3/F3AEEXeNxk9Qcybi680aGAjMDd
	 vlVLP9IR/Ega6cia16jhX7FGMsHnvCoj9RLFPgGJJzcKUAdzKmzZeStgk6uRYAVl3v
	 3IWflDShkYX/ORzlYM0tx3MRyrxEzCnvOB6+3fCM=
Date: Sun, 11 May 2025 17:49:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-mk_pte-definition-unconditional.patch removed from -mm tree
Message-Id: <20250512004942.DDC51C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make mk_pte() definition unconditional
has been removed from the -mm tree.  Its filename was
     mm-make-mk_pte-definition-unconditional.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make mk_pte() definition unconditional
Date: Wed, 2 Apr 2025 19:17:00 +0100

All architectures now use the common mk_pte() definition, so we can remove
the condition.

Link: https://lkml.kernel.org/r/20250402181709.2386022-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/mm.h~mm-make-mk_pte-definition-unconditional
+++ a/include/linux/mm.h
@@ -2004,14 +2004,12 @@ static inline struct folio *pfn_folio(un
 	return page_folio(pfn_to_page(pfn));
 }
 
-#ifndef mk_pte
 #ifdef CONFIG_MMU
 static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
 {
 	return pfn_pte(page_to_pfn(page), pgprot);
 }
 #endif
-#endif
 
 static inline bool folio_has_pincount(const struct folio *folio)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


