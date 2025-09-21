Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2892D21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489992; cv=none; b=Al3BzKYJMqoUxndBYNG6apSGFIctYG9r0G5LJnxz6maQIv85PSbQ9owyVPv4h+fNFReHsOxXH8lDz8A29OO/3Bmi2eNu2Gam4Rdl5IktRmV4aDVAD/gewUBggLPvKvK9dD6iUfcSn9iUhjXeBI7+GK//gOhEJmRty5zhV4JLcgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489992; c=relaxed/simple;
	bh=ibcjc8fEd1ty8ATtkgTUm3JRZSJFTAj/rYuA5ggH7N0=;
	h=Date:To:From:Subject:Message-Id; b=MYKE0O7H6NEpjf5oTDHm5+o3Gd4l8xWGVorYrFiV1wocsh6upBIXWasMM7dl52Pnra581pXcTOaD6v6OF0qjd7S293MeBEI9ZhxyZecPXDF+uqEI5hUZJCyZtlSh9X84ZZscvTueIKzHXyqzpXEcSHH1CN1J9EQFBPtwHYmJE+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HsaErlbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HsaErlbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F013DC4CEE7;
	Sun, 21 Sep 2025 21:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489992;
	bh=ibcjc8fEd1ty8ATtkgTUm3JRZSJFTAj/rYuA5ggH7N0=;
	h=Date:To:From:Subject:From;
	b=HsaErlbHsNPvrwFtLMdM38cOR8BpEbV15JHw8/jMfpugPmB6TXs3QcHdhxdZW+fNu
	 QDtknx7FR32Md8XEcogaOzHxxUNEX0/RNK/rQLn0ipYBCIAWoFayhed4z63Lq283H/
	 zVb8OgnXo43gvLKks6Ii2W+9BxKfOefECIooqqM8=
Date: Sun, 21 Sep 2025 14:26:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-constify-compound_order-and-page_size.patch removed from -mm tree
Message-Id: <20250921212631.F013DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: constify compound_order() and page_size()
has been removed from the -mm tree.  Its filename was
     mm-constify-compound_order-and-page_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: constify compound_order() and page_size()
Date: Wed, 10 Sep 2025 15:29:17 +0100

Patch series "Small cleanups".

These small cleanups can be applied now to reduce conflicts during the
next merge window.  They're all from various efforts to split struct page
from other memdescs.  Thanks to Vlastimil for the suggestion.


This patch (of 3):

These functions do not modify their arguments.  Telling the compiler this
may improve code generation, and allows us to pass const arguments from
other functions.

Link: https://lkml.kernel.org/r/20250910142923.2465470-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20250910142923.2465470-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-constify-compound_order-and-page_size
+++ a/include/linux/mm.h
@@ -1036,9 +1036,9 @@ static inline unsigned long folio_large_
  * set before the order is initialised, or this may be a tail page.
  * See compaction.c for some good examples.
  */
-static inline unsigned int compound_order(struct page *page)
+static inline unsigned int compound_order(const struct page *page)
 {
-	struct folio *folio = (struct folio *)page;
+	const struct folio *folio = (struct folio *)page;
 
 	if (!test_bit(PG_head, &folio->flags.f))
 		return 0;
@@ -1256,7 +1256,7 @@ int folio_mc_copy(struct folio *dst, str
 unsigned long nr_free_buffer_pages(void);
 
 /* Returns the number of bytes in this potentially compound page. */
-static inline unsigned long page_size(struct page *page)
+static inline unsigned long page_size(const struct page *page)
 {
 	return PAGE_SIZE << compound_order(page);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-inside-cmp_and_merge_page.patch

