Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3E2BE46;
	Fri,  6 Dec 2024 01:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733449378; cv=none; b=bBrTQ6y9YKyoZlnawWm8XwPqLERtRBTVBwHdqLP741QdzGMcqNnM2Tq9Fi0LGHmJRCb5HWTCzuiBrL5xR2RnmwJ0hC6pTlyBbtc7ZzqlX3P1oWfUHQBWlj4DlWPqDiM9nJO5XhM4hgOTZCZKLTq3fEyPFysLeo/52PAuq/C8xD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733449378; c=relaxed/simple;
	bh=pHpSF1YEHWW4EBOS8embs8uNX5Uo99D6/zH3bLxgTLE=;
	h=Date:To:From:Subject:Message-Id; b=qeCnxoBBjodDSzDHzUP7AXNEp+7eSAnmnmFSHtkYlCazXsQBnBdEqF659vQ+boijp5I7G2d4oqJfSQeDG7Xh67K/1lNRZyZQiIlD6CpNhLWTkR1DUuFxLtInPsBteRMSQRpvvNUyCiW9IlvhwI5pObDWCj7ri7JaXWirg0V/jfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cUwBl3zD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cUwBl3zD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C812C4CED1;
	Fri,  6 Dec 2024 01:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733449378;
	bh=pHpSF1YEHWW4EBOS8embs8uNX5Uo99D6/zH3bLxgTLE=;
	h=Date:To:From:Subject:From;
	b=cUwBl3zD36VLQB+7CsSRBLLe8ye6e8whr6AYIGyEtV9HdKRtwKRHUUmcEGl+y4wxr
	 t30nTsK7aRopB1wbRfaN1ThRmwbiSCGcnzV5i+s36cd+lwx6I8BiAYNBuhZo/dik9f
	 9rwTJ3DPzJ3ziE8vC8UD0tDorVubD4BZpQ5QhHck=
Date: Thu, 05 Dec 2024 17:42:57 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,baolin.wang@linux.alibaba.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-shmemhugepages-at-swapout.patch added to mm-hotfixes-unstable branch
Message-Id: <20241206014258.2C812C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix ShmemHugePages at swapout
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-shmemhugepages-at-swapout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-shmemhugepages-at-swapout.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hugh Dickins <hughd@google.com>
Subject: mm: shmem: fix ShmemHugePages at swapout
Date: Wed, 4 Dec 2024 22:50:06 -0800 (PST)

/proc/meminfo ShmemHugePages has been showing overlarge amounts (more than
Shmem) after swapping out THPs: we forgot to update NR_SHMEM_THPS.

Add shmem_update_stats(), to avoid repetition, and risk of making that
mistake again: the call from shmem_delete_from_page_cache() is the bugfix;
the call from shmem_replace_folio() is reassuring, but not really a bugfix
(replace corrects misplaced swapin readahead, but huge swapin readahead
would be a mistake).

Link: https://lkml.kernel.org/r/5ba477c8-a569-70b5-923e-09ab221af45b@google.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-shmemhugepages-at-swapout
+++ a/mm/shmem.c
@@ -787,6 +787,14 @@ static bool shmem_huge_global_enabled(st
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static void shmem_update_stats(struct folio *folio, int nr_pages)
+{
+	if (folio_test_pmd_mappable(folio))
+		__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr_pages);
+	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	__lruvec_stat_mod_folio(folio, NR_SHMEM, nr_pages);
+}
+
 /*
  * Somewhat like filemap_add_folio, but error if expected item has gone.
  */
@@ -821,10 +829,7 @@ static int shmem_add_to_page_cache(struc
 		xas_store(&xas, folio);
 		if (xas_error(&xas))
 			goto unlock;
-		if (folio_test_pmd_mappable(folio))
-			__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr);
-		__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
-		__lruvec_stat_mod_folio(folio, NR_SHMEM, nr);
+		shmem_update_stats(folio, nr);
 		mapping->nrpages += nr;
 unlock:
 		xas_unlock_irq(&xas);
@@ -852,8 +857,7 @@ static void shmem_delete_from_page_cache
 	error = shmem_replace_entry(mapping, folio->index, folio, radswap);
 	folio->mapping = NULL;
 	mapping->nrpages -= nr;
-	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
-	__lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
+	shmem_update_stats(folio, -nr);
 	xa_unlock_irq(&mapping->i_pages);
 	folio_put_refs(folio, nr);
 	BUG_ON(error);
@@ -1969,10 +1973,8 @@ static int shmem_replace_folio(struct fo
 	}
 	if (!error) {
 		mem_cgroup_replace_folio(old, new);
-		__lruvec_stat_mod_folio(new, NR_FILE_PAGES, nr_pages);
-		__lruvec_stat_mod_folio(new, NR_SHMEM, nr_pages);
-		__lruvec_stat_mod_folio(old, NR_FILE_PAGES, -nr_pages);
-		__lruvec_stat_mod_folio(old, NR_SHMEM, -nr_pages);
+		shmem_update_stats(new, nr_pages);
+		shmem_update_stats(old, -nr_pages);
 	}
 	xa_unlock_irq(&swap_mapping->i_pages);
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-shmem-fix-shmemhugepages-at-swapout.patch

