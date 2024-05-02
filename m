Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56C7154456
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714662818; cv=none; b=Lrw4/6RSHrU6bXoW41sDtjhEPy+edJ8sFechLIltMa1KSWngHW0Sa4xiTN8o65Im+NgtRR68JE0d29m5EnSuG4gQyhgstPTN4QTysK5aIgafUmRI3LBS7XciYkG6qvxB3b9HAUf+4MAxhDRL27moFN6NN4h8LZSdKfjGNZ8XibA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714662818; c=relaxed/simple;
	bh=eJt4MI2pjvy1yJanj4cUBlwdxO/Fe2TI6f8LD7D/fXw=;
	h=Date:To:From:Subject:Message-Id; b=J1rpujIYWQaZbH9dZVjKE0iqEesYvPpFZd+oGxfjUt2RDwqiAQpI/5A4ys0gGvEVzmYPggxaaKTrwvqQR3E5U+DbLtjWOk3N2xX3oBbwE4fRiubHZWtps/t4AycuTuNsaZxsr4xDiZhCQ1ZX7PZEbSc8f9Q219oetddhGRnWwl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xHsAHqDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xHsAHqDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1308DC113CC;
	Thu,  2 May 2024 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714662818;
	bh=eJt4MI2pjvy1yJanj4cUBlwdxO/Fe2TI6f8LD7D/fXw=;
	h=Date:To:From:Subject:From;
	b=xHsAHqDtYI8gjOQ9/GN+OEjXF9RaMec0CqsvRLahAgmQsP9UVKCKnXQuWBU+mYd+M
	 zZZYUmx20Yk+X+Y7km9Prt8uJUFCNqOhjYUZoFIjJeB+db/TOBlo4kKEfKy5K+CFbQ
	 hBNFKSmgwBwJEDv41UMH43f8YlUVoyhmKn/QtwKc=
Date: Thu, 02 May 2024 08:13:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,ioworker0@gmail.com,david@redhat.com,baohua@kernel.org,agordeev@linux.ibm.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-v6.patch added to mm-unstable branch
Message-Id: <20240502151338.1308DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: do not add fully unmapped large folio to deferred split list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-v6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-v6.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/rmap: do not add fully unmapped large folio to deferred split list
Date: Thu, 2 May 2024 09:28:51 -0400

In __folio_remove_rmap(), a large folio is added to deferred split list if
any page in a folio loses its final mapping.  But it is possible that the
folio is fully unmapped and adding it to deferred split list is
unnecessary.

For PMD-mapped THPs, that was not really an issue, because removing the
last PMD mapping in the absence of PTE mappings would not have added the
folio to the deferred split queue.

However, for PTE-mapped THPs, which are now more prominent due to mTHP,
they are always added to the deferred split queue.  One side effect is
that the THP_DEFERRED_SPLIT_PAGE stat for a PTE-mapped folio can be
unintentionally increased, making it look like there are many partially
mapped folios -- although the whole folio is fully unmapped stepwise.

Core-mm now tries batch-unmapping consecutive PTEs of PTE-mapped THPs
where possible starting from commit b06dc281aa99 ("mm/rmap: introduce
folio_remove_rmap_[pte|ptes|pmd]()").  When it happens, a whole PTE-mapped
folio is unmapped in one go and can avoid being added to deferred split
list, reducing the THP_DEFERRED_SPLIT_PAGE noise.  But there will still be
noise when we cannot batch-unmap a complete PTE-mapped folio in one go --
or where this type of batching is not implemented yet, e.g., migration.

To avoid the unnecessary addition, folio->_nr_pages_mapped is checked to
tell if the whole folio is unmapped.  If the folio is already on deferred
split list, it will be skipped, too.

Note: commit 98046944a159 ("mm: huge_memory: add the missing
folio_test_pmd_mappable() for THP split statistics") tried to exclude mTHP
deferred split stats from THP_DEFERRED_SPLIT_PAGE, but it does not fix the
above issue.  A fully unmapped PTE-mapped order-9 THP was still added to
deferred split list and counted as THP_DEFERRED_SPLIT_PAGE, since nr is
512 (non zero), level is RMAP_LEVEL_PTE, and inside deferred_split_folio()
the order-9 folio is folio_test_pmd_mappable().

Link: https://lkml.kernel.org/r/20240502132852.862138-1-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-v6
+++ a/mm/rmap.c
@@ -1494,6 +1494,7 @@ static __always_inline void __folio_remo
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int last, nr = 0, nr_pmdmapped = 0;
+	bool partially_mapped = false;
 	enum node_stat_item idx;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
@@ -1514,6 +1515,8 @@ static __always_inline void __folio_remo
 					nr++;
 			}
 		} while (page++, --nr_pages > 0);
+
+		partially_mapped = nr && atomic_read(mapped);
 		break;
 	case RMAP_LEVEL_PMD:
 		atomic_dec(&folio->_large_mapcount);
@@ -1531,6 +1534,8 @@ static __always_inline void __folio_remo
 				nr = 0;
 			}
 		}
+
+		partially_mapped = nr < nr_pmdmapped;
 		break;
 	}
 
@@ -1551,10 +1556,12 @@ static __always_inline void __folio_remo
 		 * Queue anon large folio for deferred split if at least one
 		 * page of the folio is unmapped and at least one page
 		 * is still mapped.
+		 *
+		 * Check partially_mapped first to ensure it is a large folio.
 		 */
-		if (folio_test_large(folio) && folio_test_anon(folio))
-			if (level == RMAP_LEVEL_PTE || nr < nr_pmdmapped)
-				deferred_split_folio(folio);
+		if (folio_test_anon(folio) && partially_mapped &&
+		    list_empty(&folio->_deferred_list))
+			deferred_split_folio(folio);
 	}
 
 	/*
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-v6.patch

