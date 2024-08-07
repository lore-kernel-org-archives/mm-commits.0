Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631C2143722
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 19:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723058891; cv=none; b=ACxoQO+4CA32XEHb685+cix747XqDweS4+uv6j3jWQKfppHxVtID/2W5IXYvzygRG1+WeUP1hJSKdcclGWkn/MSttp5Kd8rz+LpCQxiCV+71gOi3UgG+PglAKf3c8/8ZcOSPO0DF9yw0gZsoDAV1IZB3Zvu7qi+0yodUK5XJiJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723058891; c=relaxed/simple;
	bh=jI/z7Zs/Ou6smCvM3xHWoO+pgyXOy9wNQqwwF5BJMDw=;
	h=Date:To:From:Subject:Message-Id; b=bPKRydxiY188/ny9mEA738pX7mAN9y0K6TRsKD9FWT7Ub5LmuqMIItsn3ukdqklN3gdkqCQcj48wG2I6P3nbEmDXhBMYInlzSQ4wnhmv1Xq0G7YPJ1q5zrrJVbhCdp3A8XGlft1kXI+BUWy1HVcoQ3HxqSQL4Fnblo4/HdWcwaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cXc+T8Na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cXc+T8Na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE39C32781;
	Wed,  7 Aug 2024 19:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723058890;
	bh=jI/z7Zs/Ou6smCvM3xHWoO+pgyXOy9wNQqwwF5BJMDw=;
	h=Date:To:From:Subject:From;
	b=cXc+T8NaGkSTPs0UbTXIV36R5xBrQ2Rw67Ei+DM1RGgYcgrAFEt+ZwR/5QnmLUNeh
	 jclGxh9L7j9Qa7s22kbcKPZTJnTA0nXF0VHQABcMzdXzq6U6qCbXwskkOCmcvLI3Wt
	 Mm1egPTGqc2Ch06u8AQnK1XH/oDL9djefOJm1C3w=
Date: Wed, 07 Aug 2024 12:28:10 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,willy@infradead.org,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch added to mm-unstable branch
Message-Id: <20240807192810.CCE39C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: free zapped tail pages when splitting isolated thp
has been added to the -mm mm-unstable branch.  Its filename is
     mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm: free zapped tail pages when splitting isolated thp
Date: Wed, 7 Aug 2024 14:46:46 +0100

Patch series "mm: split underutilized THPs", v2.

The current upstream default policy for THP is always.  However, Meta uses
madvise in production as the current THP=always policy vastly
overprovisions THPs in sparsely accessed memory areas, resulting in
excessive memory pressure and premature OOM killing.  Using madvise +
relying on khugepaged has certain drawbacks over THP=always.  Using
madvise hints mean THPs aren't "transparent" and require userspace
changes.  Waiting for khugepaged to scan memory and collapse pages into
THP can be slow and unpredictable in terms of performance (i.e.  you dont
know when the collapse will happen), while production environments require
predictable performance.  If there is enough memory available, its better
for both performance and predictability to have a THP from fault time,
i.e.  THP=always rather than wait for khugepaged to collapse it, and deal
with sparsely populated THPs when the system is running out of memory.

This patch series is an attempt to mitigate the issue of running out of
memory when THP is always enabled.  During runtime whenever a THP is being
faulted in or collapsed by khugepaged, the THP is added to a list. 
Whenever memory reclaim happens, the kernel runs the deferred_split
shrinker which goes through the list and checks if the THP was
underutilized, i.e.  how many of the base 4K pages of the entire THP were
zero-filled.  If this number goes above a certain threshold, the shrinker
will attempt to split that THP.  Then at remap time, the pages that were
zero-filled are mapped to the shared zeropage, hence saving memory.  This
method avoids the downside of wasting memory in areas where THP is
sparsely filled when THP is always enabled, while still providing the
upside THPs like reduced TLB misses without having to use madvise.

Meta production workloads that were CPU bound (>99% CPU utilzation) were
tested with THP shrinker.  The results after 2 hours are as follows:

                            | THP=madvise |  THP=always   | THP=always
                            |             |               | + shrinker series
                            |             |               | + max_ptes_none=409
-----------------------------------------------------------------------------
Performance improvement     |      -      |    +1.8%      |     +1.7%
(over THP=madvise)          |             |               |
-----------------------------------------------------------------------------
Memory usage                |    54.6G    | 58.8G (+7.7%) |   55.9G (+2.4%)
-----------------------------------------------------------------------------
max_ptes_none=409 means that any THP that has more than 409 out of 512
(80%) zero filled filled pages will be split.

To test out the patches, the below commands without the shrinker will
invoke OOM killer immediately and kill stress, but will not fail with the
shrinker:

echo 450 > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
mkdir /sys/fs/cgroup/test
echo $$ > /sys/fs/cgroup/test/cgroup.procs
echo 20M > /sys/fs/cgroup/test/memory.max
echo 0 > /sys/fs/cgroup/test/memory.swap.max
# allocate twice memory.max for each stress worker and touch 40/512 of
# each THP, i.e. vm-stride 50K.
# With the shrinker, max_ptes_none of 470 and below won't invoke OOM
# killer.
# Without the shrinker, OOM killer is invoked immediately irrespective
# of max_ptes_none value and kills stress.
stress --vm 1 --vm-bytes 40M --vm-stride 50K


This patch (of 4):

If a tail page has only two references left, one inherited from the
isolation of its head and the other from lru_add_page_tail() which we are
about to drop, it means this tail page was concurrently zapped.  Then we
can safely free it and save page reclaim or migration the trouble of
trying it.

Link: https://lkml.kernel.org/r/20240807134732.3292797-1-usamaarif642@gmail.com
Link: https://lkml.kernel.org/r/20240807134732.3292797-2-usamaarif642@gmail.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Tested-by: Shuang Zhai <zhais@google.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: kernel-team@meta.com
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexander Zhu <alexlzhu@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/mm/huge_memory.c~mm-free-zapped-tail-pages-when-splitting-isolated-thp
+++ a/mm/huge_memory.c
@@ -2924,7 +2924,9 @@ static void __split_huge_page(struct pag
 	unsigned int new_nr = 1 << new_order;
 	int order = folio_order(folio);
 	unsigned int nr = 1 << order;
+	struct folio_batch free_folios;
 
+	folio_batch_init(&free_folios);
 	/* complete memcg works before add pages to LRU */
 	split_page_memcg(head, order, new_order);
 
@@ -3008,6 +3010,26 @@ static void __split_huge_page(struct pag
 		if (subpage == page)
 			continue;
 		folio_unlock(new_folio);
+		/*
+		 * If a folio has only two references left, one inherited
+		 * from the isolation of its head and the other from
+		 * lru_add_page_tail() which we are about to drop, it means this
+		 * folio was concurrently zapped. Then we can safely free it
+		 * and save page reclaim or migration the trouble of trying it.
+		 */
+		if (list && page_ref_freeze(subpage, 2)) {
+			VM_WARN_ON_ONCE_FOLIO(folio_test_lru(new_folio), new_folio);
+			VM_WARN_ON_ONCE_FOLIO(folio_test_large(new_folio), new_folio);
+			VM_WARN_ON_ONCE_FOLIO(folio_mapped(new_folio), new_folio);
+
+			folio_clear_active(new_folio);
+			folio_clear_unevictable(new_folio);
+			if (folio_batch_add(&free_folios, folio) == 0) {
+				mem_cgroup_uncharge_folios(&free_folios);
+				free_unref_folios(&free_folios);
+			}
+			continue;
+		}
 
 		/*
 		 * Subpages may be freed if there wasn't any mapping
@@ -3018,6 +3040,11 @@ static void __split_huge_page(struct pag
 		 */
 		free_page_and_swap_cache(subpage);
 	}
+
+	if (free_folios.nr) {
+		mem_cgroup_uncharge_folios(&free_folios);
+		free_unref_folios(&free_folios);
+	}
 }
 
 /* Racy check whether the huge page can be split */
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch
mm-swap-remove-boilerplate-fix.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

