Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7CA2557E
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059676; cv=none; b=c6k+/7jGoX8GJEElZcJc4r8C+ZvWH3QHm6PTzGuUp0chQKmWefY0bYhQtGQYtDXgTB/HYozYLYjIX9dV9gGImLCDtT06sf/RFkmAinMW0otWpyUJurYc8B+WUeeF7iXxQ7eNNF/yrfDnesFSvOC1taLCR7rHzEmIL2vQSRTxlZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059676; c=relaxed/simple;
	bh=4A3tEa01lrOoi+vaTpcm5cRrhJlG5IIChj+QUnd02Bk=;
	h=Date:To:From:Subject:Message-Id; b=d0hKSi0jO8+gtx+I/vZakoRwBC61jNzkWOdO2Kufs7O0GONq0SfiZ17xp4giFQR/B5D0WdrLTdTJETu1xrNE7zUmt7/PihQr2KRoItsdw3R4iTCim8EMAl/IBRtLaPm/XjT/e+iPjsn1t1l+/b1wp3lIQ9rQuu4vA5uZbqRp8+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LOAsujNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LOAsujNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6842C433F1;
	Tue, 27 Feb 2024 18:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059675;
	bh=4A3tEa01lrOoi+vaTpcm5cRrhJlG5IIChj+QUnd02Bk=;
	h=Date:To:From:Subject:From;
	b=LOAsujNLJDzmzzEitS9/Hlt5y9g84Bn1ouJNdgZiIRTv+/8WwkdSlTaU3cItmc5Lt
	 Cu9QlQMKsSo/eUmdwySTysrcQw59OzEeH9tfa9ti62PG7EolOFNf3gMi2uDeBR3mF5
	 CLJ5GBY5L4lf1YSiWxoT4fjJlTcp8+ftjBXswDao=
Date: Tue, 27 Feb 2024 10:47:55 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-use-of-folio-list-from-folios_put.patch added to mm-unstable branch
Message-Id: <20240227184755.A6842C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove use of folio list from folios_put()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-use-of-folio-list-from-folios_put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-use-of-folio-list-from-folios_put.patch

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

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch

