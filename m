Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8E6FC1C
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600567; cv=none; b=XetEyH7qvv4JaSGk+EPukHdEhbJHmpP/4nl5TCd+xxQsg7+bflCVGDsL4dkbDHxD+LdYIoMde3EJOe9vGNWfVMHzGX7NS7+sAH5QtNtmu2v/esEehsHdqLcdf9+Cvguzo27pCR/7N9ljXdFFsrnAkfmMSMZcGr0ddAxzLLk3kzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600567; c=relaxed/simple;
	bh=e1bOveVUYC0C0L9HMvFNVrpqzS916Eyia8N0jqn0I6c=;
	h=Date:To:From:Subject:Message-Id; b=HQ+HqQaGUY5onGIWch7/w/VuE+5trS/qlOq2o/iQ/gHY0EooZGwfZMzWrHfqTUxXjNTCJHTtwzW2mM1t3ESbMtlluIt85W7CJQaEzlrPXLxrZmSuxUpNB2LRAo8P4LvUyqgHDLQDcyOseyEGJpPvhK0bwtSE4IkA29FDCM++cwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c+Ygpus5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c+Ygpus5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EDEC433F1;
	Tue,  5 Mar 2024 01:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600567;
	bh=e1bOveVUYC0C0L9HMvFNVrpqzS916Eyia8N0jqn0I6c=;
	h=Date:To:From:Subject:From;
	b=c+Ygpus5944wFEahjlEF3QnhavL5ZTBnW0G9I3wATn283A++cwyw0JI5WmPq24Y4o
	 nMRLq3P9tb18ucPuxepxPDOwLljZw15gXlYBKPL6Q+gKE575THKDfFGgZNfdB0IXfV
	 ruMNCkgpFVpXv+DdJc621+odcFY4HQyWTnxtIvYo=
Date: Mon, 04 Mar 2024 17:02:46 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-use-of-folio-list-from-folios_put.patch removed from -mm tree
Message-Id: <20240305010246.E5EDEC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove use of folio list from folios_put()
has been removed from the -mm tree.  Its filename was
     mm-remove-use-of-folio-list-from-folios_put.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove use of folio list from folios_put()
Date: Tue, 27 Feb 2024 17:42:40 +0000

Instead of putting the interesting folios on a list, delete the
uninteresting one from the folio_batch.

Link: https://lkml.kernel.org/r/20240227174254.710559-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/mm/swap.c~mm-remove-use-of-folio-list-from-folios_put
+++ a/mm/swap.c
@@ -961,12 +961,11 @@ void lru_cache_disable(void)
  */
 void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 {
-	int i;
-	LIST_HEAD(pages_to_free);
+	int i, j;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 
-	for (i = 0; i < folios->nr; i++) {
+	for (i = 0, j = 0; i < folios->nr; i++) {
 		struct folio *folio = folios->folios[i];
 		unsigned int nr_refs = refs ? refs[i] : 1;
 
@@ -1016,14 +1015,20 @@ void folios_put_refs(struct folio_batch
 			count_vm_event(UNEVICTABLE_PGCLEARED);
 		}
 
-		list_add(&folio->lru, &pages_to_free);
+		if (j != i)
+			folios->folios[j] = folio;
+		j++;
 	}
 	if (lruvec)
 		unlock_page_lruvec_irqrestore(lruvec, flags);
+	if (!j) {
+		folio_batch_reinit(folios);
+		return;
+	}
 
-	mem_cgroup_uncharge_list(&pages_to_free);
-	free_unref_page_list(&pages_to_free);
-	folio_batch_reinit(folios);
+	folios->nr = j;
+	mem_cgroup_uncharge_folios(folios);
+	free_unref_folios(folios);
 }
 EXPORT_SYMBOL(folios_put_refs);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

