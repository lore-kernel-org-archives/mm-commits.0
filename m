Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD6C145B10
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727383712; cv=none; b=m3BxmZc24CnS61SKZ/SXSLzkut5mPjTP7fyDl7ZRpFSg8ECYXoHDdO0kWZN1E/MKl++bd6iha8gTa8bYXDZwjgb7JRxi/B8Hz2isQY9hJb0TAfaHvhMAewpx1FT0AQxKRGy+oCQCqhnTGGY90QOeWYKljMw3AF7CLT9+aiqx95o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727383712; c=relaxed/simple;
	bh=xrX+KcLiiZzq/Gsh7t8qSZtnIZnenlS9rMZ6yt5bAWs=;
	h=Date:To:From:Subject:Message-Id; b=RCPLGPI6od4O0Cm1gGn4AqOs3QiRdWB+UCPiWf8Zn6a/cIXO0x7SXJn90rv3hOjXxruxuhSO6MxRMmKmN1zrF1eC/VA+YTUnv9Jl7NYc4gElkBfnCafsr8wdQJE8wt0lC9ozBCh6EqDtU5NxVvfdBrgaF6aKbMrdpJ6S481iPY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FahTvGu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FahTvGu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC57C4CEC5;
	Thu, 26 Sep 2024 20:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727383712;
	bh=xrX+KcLiiZzq/Gsh7t8qSZtnIZnenlS9rMZ6yt5bAWs=;
	h=Date:To:From:Subject:From;
	b=FahTvGu+dvWXdXLcXVRV3CKee6NJj9pLEg9kQ90KtVD3TkK64d+UTeGfyZ9d5zDli
	 7p5C87BUw+LF0k37IXjHqQAgo3jyEvNYdCDT3qJaGH2UwDq2JwNZuvm65tqeRk+k47
	 +covjW25Om2SZnYUnEw2lE4CrKihrbVB4Pf+V+/4=
Date: Thu, 26 Sep 2024 13:48:32 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,david@redhat.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags.patch added to mm-unstable branch
Message-Id: <20240926204832.9AC57C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate LRU_REFS_MASK bits in folio_migrate_flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags.patch

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
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: migrate LRU_REFS_MASK bits in folio_migrate_flags
Date: Thu, 26 Sep 2024 13:06:47 +0800

Bits of LRU_REFS_MASK are not inherited during migration which lead to new
folio start from tier0 when MGLRU enabled.  Try to bring as much bits of
folio->flags as possible since compaction and alloc_contig_range which
introduce migration do happen at times.

Link: https://lkml.kernel.org/r/20240926050647.5653-1-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Suggested-by: Yu Zhao <yuzhao@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   10 ++++++++++
 mm/migrate.c              |    1 +
 2 files changed, 11 insertions(+)

--- a/include/linux/mm_inline.h~mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags
+++ a/include/linux/mm_inline.h
@@ -291,6 +291,12 @@ static inline bool lru_gen_del_folio(str
 	return true;
 }
 
+static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+{
+	unsigned long refs = READ_ONCE(old->flags) & LRU_REFS_MASK;
+
+	set_mask_bits(&new->flags, LRU_REFS_MASK, refs);
+}
 #else /* !CONFIG_LRU_GEN */
 
 static inline bool lru_gen_enabled(void)
@@ -313,6 +319,10 @@ static inline bool lru_gen_del_folio(str
 	return false;
 }
 
+static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+{
+
+}
 #endif /* CONFIG_LRU_GEN */
 
 static __always_inline
--- a/mm/migrate.c~mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags
+++ a/mm/migrate.c
@@ -694,6 +694,7 @@ void folio_migrate_flags(struct folio *n
 	if (folio_test_idle(folio))
 		folio_set_idle(newfolio);
 
+	folio_migrate_refs(newfolio, folio);
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags.patch
mm-optimization-on-page-allocation-when-cma-enabled.patch

