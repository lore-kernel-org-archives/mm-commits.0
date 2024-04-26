Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF9729413
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 22:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714170067; cv=none; b=c4WE7B3xXB16az1SUBTEHuGT2wAs69QfA2iEnmY7Ljxv3DNwDFrras70yt8Su/H+umkSpsXgJLORsnV0D66s2P80EqLZg9pepMfR6dKoLTNEjQlLRjtmvZ5oTa8RVZA2yhnghlDxZiH1sAjE3yud/d9joJ3cslZIKweY/vxQt7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714170067; c=relaxed/simple;
	bh=P6L994x6s8FrATH42Ly6R9aAl5Hzf0eSMD0T1eAfruw=;
	h=Date:To:From:Subject:Message-Id; b=KAgIi71a3tAtKd/yuyCbdHBA++ZfP7ZfsD7L/NgiuHJ1vEgYieiIPzrOUqF1m4FWF2BDJWzhR6EroTLubAB8yv00fEpi8BmBZA3MLXb8+00acmgBH5JfrEleVtK4T4oTyt8jVRnAo5hYaz9udZHece0TMkD2eEZrULrxEOjBxPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U8U8z1mw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U8U8z1mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08063C113CD;
	Fri, 26 Apr 2024 22:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714170067;
	bh=P6L994x6s8FrATH42Ly6R9aAl5Hzf0eSMD0T1eAfruw=;
	h=Date:To:From:Subject:From;
	b=U8U8z1mwGfmT97hfV9HttADHeRhfZihcFw8UU9H5x+3VxXQGSqGHIPMUybgDHkk12
	 8vsc2WleLMoTDy9AQJDWbrfUGzN6E0QZWaw7L0BT7zhk5Z53G+DIodNKGRy8OVcowS
	 bRB3OlEVJ2LSlI0p2+0XTYd4T0IjjqzV84AxQ3+c=
Date: Fri, 26 Apr 2024 15:21:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,ioworker0@gmail.com,david@redhat.com,21cnbao@gmail.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list.patch added to mm-unstable branch
Message-Id: <20240426222107.08063C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: do not add fully unmapped large folio to deferred split list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list.patch

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
Date: Fri, 26 Apr 2024 15:02:53 -0400

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

Link: https://lkml.kernel.org/r/20240426190253.541419-1-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list
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
+		partially_mapped = !!nr && !!atomic_read(mapped);
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
 
@@ -1552,9 +1557,10 @@ static __always_inline void __folio_remo
 		 * page of the folio is unmapped and at least one page
 		 * is still mapped.
 		 */
-		if (folio_test_large(folio) && folio_test_anon(folio))
-			if (level == RMAP_LEVEL_PTE || nr < nr_pmdmapped)
-				deferred_split_folio(folio);
+		if (folio_test_anon(folio) &&
+		    list_empty(&folio->_deferred_list) &&
+		    partially_mapped)
+			deferred_split_folio(folio);
 	}
 
 	/*
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list.patch
mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-fix.patch

