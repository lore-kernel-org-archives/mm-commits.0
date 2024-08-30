Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52911C1AD1
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057426; cv=none; b=gohIOl9WACZEy0y5vM2euwMMsg3RUrR2+GKfYEagOaFNfmDVb/xc1zG3STtyyhA/ZXzm8joX+kMgMz709lRYHB9Q8en5/jIg3TLWFkKaUxQMQyDUOYonvPk9tbHBy+QnipXbaJrj5UPEjhCf9+Srs7s7VFFXyYCbq7GvtaC4bec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057426; c=relaxed/simple;
	bh=DBZhr+QugIBn1fq2LmAa9DceekJevGfJ3sk2++TqP80=;
	h=Date:To:From:Subject:Message-Id; b=qRnORRQvCN8TVJRUUso4C1lQtL835SPRprbNjbtYhWcV6a5cEuI5PQNtLv6acdRp9WqkRFoVxfXKd1qjNDKnKhdy9VfJr/gZ8XnqRfprcd3++TfZgMyyKdWEDm8iw1qyLFFGGNWEtft/7J6SnyD4pktUsWDnoKVC4xmuEKb2EWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E+hG5ZV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E+hG5ZV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49604C4CEC2;
	Fri, 30 Aug 2024 22:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725057426;
	bh=DBZhr+QugIBn1fq2LmAa9DceekJevGfJ3sk2++TqP80=;
	h=Date:To:From:Subject:From;
	b=E+hG5ZV81o78839ijN4UT7GQR4mPIyAA0RhLxwGOFRgeGLj3zh9xNEmTODY8dkc3g
	 xlDCSDSSbwd9vgN23SsbDtDPlkRg7I2yGy7oJZAofVVTwFnIYyVrkyXe/333Ar8XKU
	 wtOfk1Uic49iGNrgWfmsRuLU7dBWrcCssAHGGaqg=
Date: Fri, 30 Aug 2024 15:37:05 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,willy@infradead.org,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,npache@redhat.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch added to mm-unstable branch
Message-Id: <20240830223706.49604C4CEC2@smtp.kernel.org>
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
Date: Fri, 30 Aug 2024 11:03:35 +0100

Patch series "mm: split underused THPs", v5.

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
shrinker which goes through the list and checks if the THP was underused,
i.e.  how many of the base 4K pages of the entire THP were zero-filled. 
If this number goes above a certain threshold, the shrinker will attempt
to split that THP.  Then at remap time, the pages that were zero-filled
are mapped to the shared zeropage, hence saving memory.  This method
avoids the downside of wasting memory in areas where THP is sparsely
filled when THP is always enabled, while still providing the upside THPs
like reduced TLB misses without having to use madvise.

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


This patch (of 6):

If a tail page has only two references left, one inherited from the
isolation of its head and the other from lru_add_page_tail() which we are
about to drop, it means this tail page was concurrently zapped.  Then we
can safely free it and save page reclaim or migration the trouble of
trying it.

Link: https://lkml.kernel.org/r/20240830100438.3623486-1-usamaarif642@gmail.com
Link: https://lkml.kernel.org/r/20240830100438.3623486-2-usamaarif642@gmail.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Tested-by: Shuang Zhai <zhais@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexander Zhu <alexlzhu@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/mm/huge_memory.c~mm-free-zapped-tail-pages-when-splitting-isolated-thp
+++ a/mm/huge_memory.c
@@ -3170,7 +3170,9 @@ static void __split_huge_page(struct pag
 	unsigned int new_nr = 1 << new_order;
 	int order = folio_order(folio);
 	unsigned int nr = 1 << order;
+	struct folio_batch free_folios;
 
+	folio_batch_init(&free_folios);
 	/* complete memcg works before add pages to LRU */
 	split_page_memcg(head, order, new_order);
 
@@ -3254,6 +3256,27 @@ static void __split_huge_page(struct pag
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
+		if (list && folio_ref_freeze(new_folio, 2)) {
+			VM_WARN_ON_ONCE_FOLIO(folio_test_lru(new_folio), new_folio);
+			VM_WARN_ON_ONCE_FOLIO(folio_test_large(new_folio), new_folio);
+			VM_WARN_ON_ONCE_FOLIO(folio_mapped(new_folio), new_folio);
+
+			folio_clear_active(new_folio);
+			folio_clear_unevictable(new_folio);
+			list_del(&new_folio->lru);
+			if (!folio_batch_add(&free_folios, new_folio)) {
+				mem_cgroup_uncharge_folios(&free_folios);
+				free_unref_folios(&free_folios);
+			}
+			continue;
+		}
 
 		/*
 		 * Subpages may be freed if there wasn't any mapping
@@ -3264,6 +3287,11 @@ static void __split_huge_page(struct pag
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
mm-hugetlb_vmemmap-batch-hvo-work-when-demoting.patch
mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-cma-add-cma_allocfree_folio-fix.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

