Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECF43603D5;
	Tue, 30 Jun 2026 02:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782785182; cv=none; b=mQRpPpUrn2mQzN0LCdZNJhvNadI+VLEc/zO3pxkJ4AbnMQqS9+uCGJnEJ+clp3voJRhyn5yytQ1MhasDynRcmhc9RUkwln3sIcWsxUfbML1S433cOacm+HsN4LGKNKdN75OcGrTR1lFFLTS4hA43gIrW1uO3UDwK4P6XymeYHnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782785182; c=relaxed/simple;
	bh=qcjlqVgMBng3JrMXXt6dxNGOaJrJtFMJOrdR3IdfZ0M=;
	h=Date:To:From:Subject:Message-Id; b=fDXc8p4sWawbFJtlaVa2616fzjRinSWiGzAH7teB7lDWN5f6b2tvn6Wnjk00oLCNFPGfLI4tu/dMI2v79Rzdx31p++cXS6/MLV8x8ymujKprr0FMxiVvMjMO2/Llf2f+A4ZEk8y1GI3/sSGJsnEb/jXGmnymkUH5kd1Uqf3/KGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MaHVsk1b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MaHVsk1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114B11F000E9;
	Tue, 30 Jun 2026 02:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782785181;
	bh=VMY5q02TSLKXORYGWu7qp70GTD2mddMdf9wKurdFhJk=;
	h=Date:To:From:Subject;
	b=MaHVsk1bYXm41TLFk+IU7o89kc9ZgXvIuvhk0HL3QAvQ98C9ZolqAZxIA8fDFT7xe
	 8nmWJLI+EYJ8Qm5+XKpT53moEgyOQLSJ1cQ7te8A9JdoZItoK2N3ZGSCGHeadAl2SK
	 igUkCieJE93w6FPpKuhg65D6+jJztnbGTdf4Veto=
Date: Mon, 29 Jun 2026 19:06:20 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match.patch added to mm-new branch
Message-Id: <20260630020621.114B11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: free allocated PFNs if the range does not match
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match.patch

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
Subject: mm/page_alloc: free allocated PFNs if the range does not match
Date: Mon, 29 Jun 2026 21:35:33 -0400

When using __GFP_COMP in alloc_contig_frozen_range(), if the allocated
range does not match the requested one, the code errors out with EINVAL
without freeing the allocated PFNs and causes free page leaks.  Fix it by
calling release_free_list() in the error path.

The issue is reported by Sashiko[1].

Link: https://lore.kernel.org/20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com
Link: https://sashiko.dev/#/patchset/20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com [1]
Fixes: e98337d11bbd ("mm/contig_alloc: support __GFP_COMP")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 mm/internal.h   |    1 +
 mm/page_alloc.c |    6 ++++--
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match
+++ a/mm/compaction.c
@@ -88,7 +88,7 @@ static struct page *mark_allocated_nopro
 }
 #define mark_allocated(...)	alloc_hooks(mark_allocated_noprof(__VA_ARGS__))
 
-static unsigned long release_free_list(struct list_head *freepages)
+unsigned long release_free_list(struct list_head *freepages)
 {
 	int order;
 	unsigned long high_pfn = 0;
--- a/mm/internal.h~mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match
+++ a/mm/internal.h
@@ -828,6 +828,7 @@ static inline void clear_zone_contiguous
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
+extern unsigned long release_free_list(struct list_head *freepages);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
 extern void memblock_free_pages(unsigned long pfn, unsigned int order);
--- a/mm/page_alloc.c~mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match
+++ a/mm/page_alloc.c
@@ -7244,9 +7244,11 @@ int alloc_contig_frozen_range_noprof(uns
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
 	} else {
+		release_free_list(cc.freepages);
 		ret = -EINVAL;
-		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
-		     start, end, outer_start, outer_end);
+		WARN(true,
+		     "PFN range: allocated [%lu, %lu) does not match requested [%lu, %lu), freeing allocated PFNs\n",
+		     outer_start, outer_end, start, end);
 	}
 done:
 	undo_isolate_page_range(start, end);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-compaction-handle-free_pages_prepare-properly-in-compaction_free.patch
mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match.patch

