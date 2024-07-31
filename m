Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C661799F
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722441372; cv=none; b=QBsfYFRE7zZw6cEVDkQmNZd0kxYlFme1Lz/DfCLfz/YgH+yoxIQxVA8YpWtwKtPc1XYLjNZWfh9glpdMUoHYFQ7Jl6Z1BK9mONgIqJ8QkFCDBRESbNk+7urpm359P9RvpG59Hn0qwbVSeRGWmNHNE+d99JWIGFe8CPaqj1yHhmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722441372; c=relaxed/simple;
	bh=0bTb5LgdFF1fDeGD8fBGJ3juUiFpseu69YOa9U3ayEI=;
	h=Date:To:From:Subject:Message-Id; b=EpzR7NNn3nb+rWjFM5K/3KzfndXiF8uV/mLg96IUiuj2GEMl6azm9LaUOZUdL67mlNCOedlOWyWxHyEVbPecXJbq0d78enb37mBIf/YupnjLh+W8rb/qiUfXB2YPRtP0l5BzYXiOxwPAbbijly0K6kiTOqd03R8p9aT2SW6la78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vm6wpdI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vm6wpdI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A515BC116B1;
	Wed, 31 Jul 2024 15:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722441371;
	bh=0bTb5LgdFF1fDeGD8fBGJ3juUiFpseu69YOa9U3ayEI=;
	h=Date:To:From:Subject:From;
	b=vm6wpdI+uF7fr63ziZjTQhGNpXMMW01PMmtrtj6ZQhBC2S1Zyc9lm4o60vJPWf88m
	 dhBbMo9WSPkTJauw2aMWn9uDV+z85e8LNaOXCqr1bMszf2tEgno9gKVedhjMQVXDEi
	 EI2KozO03H9clAoFV+aGMsnwQYW9OcwF1HWPC1Jg=
Date: Wed, 31 Jul 2024 08:56:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch added to mm-unstable branch
Message-Id: <20240731155611.A515BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: cleanup partially-mapped handling in __folio_remove_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: cleanup partially-mapped handling in __folio_remove_rmap()
Date: Wed, 10 Jul 2024 23:43:50 +0200

Let's simplify and reduce code indentation.  In the RMAP_LEVEL_PTE case,
we already check for nr when computing partially_mapped.

For RMAP_LEVEL_PMD, it's a bit more confusing.  Likely, we don't need the
"nr" check, but we could have "nr < nr_pmdmapped" also if we stumbled into
the "/* Raced ahead of another remove and an add?  */" case.  So let's
simply move the nr check in there.

Note that partially_mapped is always false for small folios.

No functional change intended.

Link: https://lkml.kernel.org/r/20240710214350.147864-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/mm/rmap.c~mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap
+++ a/mm/rmap.c
@@ -1568,22 +1568,19 @@ static __always_inline void __folio_remo
 			}
 		}
 
-		partially_mapped = nr < nr_pmdmapped;
+		partially_mapped = nr && nr < nr_pmdmapped;
 		break;
 	}
 
-	if (nr) {
-		/*
-		 * Queue anon large folio for deferred split if at least one
-		 * page of the folio is unmapped and at least one page
-		 * is still mapped.
-		 *
-		 * Check partially_mapped first to ensure it is a large folio.
-		 */
-		if (folio_test_anon(folio) && partially_mapped &&
-		    list_empty(&folio->_deferred_list))
-			deferred_split_folio(folio);
-	}
+	/*
+	 * Queue anon large folio for deferred split if at least one page of
+	 * the folio is unmapped and at least one page is still mapped.
+	 *
+	 * Check partially_mapped first to ensure it is a large folio.
+	 */
+	if (partially_mapped && folio_test_anon(folio) &&
+	    list_empty(&folio->_deferred_list))
+		deferred_split_folio(folio);
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
 
 	/*
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch

