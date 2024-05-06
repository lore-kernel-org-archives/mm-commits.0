Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86605CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957021; cv=none; b=iTdIZ5zeRZDFwTvDIoJDPst3COLjUogwjrvyOLMzil/9e6n19ngQqhkaVa9O1RWfsFskmiusqyfhyhMgnyj6RvYapdKIxc7/4G9KfuqJGITpOcrZFyglJb1cBXiHCMfJZM/2HGKXmZAjtYDMP6Ji9OVzSawhkqnx2BjeNXmrgPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957021; c=relaxed/simple;
	bh=eFbHpL05hjpDIompw3NPNeU+Rf/JvnwRo5gNJXXb3cU=;
	h=Date:To:From:Subject:Message-Id; b=gBeF73OMAXtbH2dQFDkgO2h/w5eVsKujJH/qGyW6nUlIzi4Zjiz61SVOR6+4njeL50S85LCUWaAbdgTiKcUT8WA44ySX4RH9ioPLrNDoYovcZkTkMLvepeiG0oSO5Ypcf67TXbqHUKnsaD2/1G+wcVYWncgkpPs2WfNiImECTHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NeAWU78B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NeAWU78B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDE4C113CC;
	Mon,  6 May 2024 00:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957021;
	bh=eFbHpL05hjpDIompw3NPNeU+Rf/JvnwRo5gNJXXb3cU=;
	h=Date:To:From:Subject:From;
	b=NeAWU78BPzUk+ahXv2YIPpperZh13A+zwIHPyCWEIILaYevWJ+AY26/l+NeVXVHt9
	 7ACAwcgydRgD2V45iokhcxNbL4yovrUSzlSrO/rcJfD1UCIbFCPuKM3F9LiE2I9R1c
	 3Xa9o+ROgYsWFi+9l7EeOv3ghjG0IoZkdO1wnDp8=
Date: Sun, 05 May 2024 17:57:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-add-ksm_get_folio.patch removed from -mm tree
Message-Id: <20240506005701.9FDE4C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: add ksm_get_folio
has been removed from the -mm tree.  Its filename was
     mm-ksm-add-ksm_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: add ksm_get_folio
Date: Thu, 11 Apr 2024 14:17:02 +0800

Patch series "transfer page to folio in KSM".

This is the first part of page to folio transfer on KSM.  Since only
single page could be stored in KSM, we could safely transfer stable tree
pages to folios.  

This patchset could reduce ksm.o 57kbytes from 2541776 bytes on latest
akpm/mm-stable branch with CONFIG_DEBUG_VM enabled.  It pass the KSM
testing in LTP and kernel selftest.

Thanks for Matthew Wilcox and David Hildenbrand's suggestions and
comments!


This patch (of 10):

The ksm only contains single pages, so we could add a new func
ksm_get_folio for get_ksm_page to use folio instead of pages to save a
couple of compound_head calls.

After all caller replaced, get_ksm_page will be removed.

Link: https://lkml.kernel.org/r/20240411061713.1847574-1-alexs@kernel.org
Link: https://lkml.kernel.org/r/20240411061713.1847574-2-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

--- a/mm/ksm.c~mm-ksm-add-ksm_get_folio
+++ a/mm/ksm.c
@@ -897,7 +897,7 @@ enum get_ksm_page_flags {
 };
 
 /*
- * get_ksm_page: checks if the page indicated by the stable node
+ * ksm_get_folio: checks if the page indicated by the stable node
  * is still its ksm page, despite having held no reference to it.
  * In which case we can trust the content of the page, and it
  * returns the gotten page; but if the page has now been zapped,
@@ -915,10 +915,10 @@ enum get_ksm_page_flags {
  * a page to put something that might look like our key in page->mapping.
  * is on its way to being freed; but it is an anomaly to bear in mind.
  */
-static struct page *get_ksm_page(struct ksm_stable_node *stable_node,
+static struct folio *ksm_get_folio(struct ksm_stable_node *stable_node,
 				 enum get_ksm_page_flags flags)
 {
-	struct page *page;
+	struct folio *folio;
 	void *expected_mapping;
 	unsigned long kpfn;
 
@@ -926,8 +926,8 @@ static struct page *get_ksm_page(struct
 					PAGE_MAPPING_KSM);
 again:
 	kpfn = READ_ONCE(stable_node->kpfn); /* Address dependency. */
-	page = pfn_to_page(kpfn);
-	if (READ_ONCE(page->mapping) != expected_mapping)
+	folio = pfn_folio(kpfn);
+	if (READ_ONCE(folio->mapping) != expected_mapping)
 		goto stale;
 
 	/*
@@ -940,41 +940,41 @@ again:
 	 * in folio_migrate_mapping(), it might still be our page,
 	 * in which case it's essential to keep the node.
 	 */
-	while (!get_page_unless_zero(page)) {
+	while (!folio_try_get(folio)) {
 		/*
 		 * Another check for page->mapping != expected_mapping would
 		 * work here too.  We have chosen the !PageSwapCache test to
 		 * optimize the common case, when the page is or is about to
 		 * be freed: PageSwapCache is cleared (under spin_lock_irq)
 		 * in the ref_freeze section of __remove_mapping(); but Anon
-		 * page->mapping reset to NULL later, in free_pages_prepare().
+		 * folio->mapping reset to NULL later, in free_pages_prepare().
 		 */
-		if (!PageSwapCache(page))
+		if (!folio_test_swapcache(folio))
 			goto stale;
 		cpu_relax();
 	}
 
-	if (READ_ONCE(page->mapping) != expected_mapping) {
-		put_page(page);
+	if (READ_ONCE(folio->mapping) != expected_mapping) {
+		folio_put(folio);
 		goto stale;
 	}
 
 	if (flags == GET_KSM_PAGE_TRYLOCK) {
-		if (!trylock_page(page)) {
-			put_page(page);
+		if (!folio_trylock(folio)) {
+			folio_put(folio);
 			return ERR_PTR(-EBUSY);
 		}
 	} else if (flags == GET_KSM_PAGE_LOCK)
-		lock_page(page);
+		folio_lock(folio);
 
 	if (flags != GET_KSM_PAGE_NOLOCK) {
-		if (READ_ONCE(page->mapping) != expected_mapping) {
-			unlock_page(page);
-			put_page(page);
+		if (READ_ONCE(folio->mapping) != expected_mapping) {
+			folio_unlock(folio);
+			folio_put(folio);
 			goto stale;
 		}
 	}
-	return page;
+	return folio;
 
 stale:
 	/*
@@ -990,6 +990,14 @@ stale:
 	return NULL;
 }
 
+static struct page *get_ksm_page(struct ksm_stable_node *stable_node,
+				 enum get_ksm_page_flags flags)
+{
+	struct folio *folio = ksm_get_folio(stable_node, flags);
+
+	return &folio->page;
+}
+
 /*
  * Removing rmap_item from stable or unstable tree.
  * This function will clean the information from the stable/unstable tree.
_

Patches currently in -mm which might be from alexs@kernel.org are


