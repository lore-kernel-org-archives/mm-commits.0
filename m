Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9650F2192E3
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 02:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758075747; cv=none; b=ClbjJjshdnQT4Ucs5I4XQoiMPBBbq92cia3LcSiP8nj4BshvBt7lEDHpA1nE4rq0k3FHbhqtioGpFgs02ARSUvsEgsvpkJl3tV/foKYkVoji1Z99TPIMVY8WyZI7Q9tu1Yp4E7t1FKP5ph0jVTOkVMYLTop+cJxCFvBOySAEQ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758075747; c=relaxed/simple;
	bh=oBTZtKgjHkU5obeoTz7ONOwmtMW/KkX4tXx5/Bp6cyg=;
	h=Date:To:From:Subject:Message-Id; b=u3kKQXIA8qni4gJxkfuZhfD+FBNlGLCQclHXZm9BjkD48He6JCNH2vNreyarnkzX9pzFJASaygxiiAENqvpASG4OFlYGZH1edXtXc/ZClliMu2yc2M3XYSqCeKlK0M0xxEj1l1KoT2b8sKnynVWP/dr+KpP8Cihr/vWGtbuQFTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ouZa2t/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ouZa2t/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FACC4CEEB;
	Wed, 17 Sep 2025 02:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758075747;
	bh=oBTZtKgjHkU5obeoTz7ONOwmtMW/KkX4tXx5/Bp6cyg=;
	h=Date:To:From:Subject:From;
	b=0ouZa2t//9UU5cVB+lRyu6WsfYfk2j3QtKsKU3zamjeTVBeDmmcrJs5ggz7K9rqN/
	 kcp3XbohIVjPJYraQZ7LGfAL9IGHVTdKeeSE9HN+0iUOX6Oo9otpGFUCIUWwL7bhc1
	 MutNiOcPpqcQ2bd/VcYIIDSZY2eLujVZ46p9mgi8=
Date: Tue, 16 Sep 2025 19:22:26 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,xialonglong@kylinos.cn,david@redhat.com,chengming.zhou@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-use-a-folio-inside-cmp_and_merge_page.patch added to mm-new branch
Message-Id: <20250917022227.16FACC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: use a folio inside cmp_and_merge_page()
has been added to the -mm mm-new branch.  Its filename is
     ksm-use-a-folio-inside-cmp_and_merge_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-use-a-folio-inside-cmp_and_merge_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: ksm: use a folio inside cmp_and_merge_page()
Date: Tue, 16 Sep 2025 19:11:59 +0100

This removes the last call to page_stable_node(), so delete the wrapper. 
It also removes a call to trylock_page() and saves a call to
compound_head(), as well as removing a reference to folio->page.

Link: https://lkml.kernel.org/r/20250916181219.2400258-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Longlong Xia <xialonglong@kylinos.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/ksm.c~ksm-use-a-folio-inside-cmp_and_merge_page
+++ a/mm/ksm.c
@@ -1061,11 +1061,6 @@ struct ksm_stable_node *folio_stable_nod
 	return folio_test_ksm(folio) ? folio_raw_mapping(folio) : NULL;
 }
 
-static inline struct ksm_stable_node *page_stable_node(struct page *page)
-{
-	return folio_stable_node(page_folio(page));
-}
-
 static inline void folio_set_stable_node(struct folio *folio,
 					 struct ksm_stable_node *stable_node)
 {
@@ -2225,6 +2220,7 @@ static void stable_tree_append(struct ks
  */
 static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_item)
 {
+	struct folio *folio = page_folio(page);
 	struct ksm_rmap_item *tree_rmap_item;
 	struct page *tree_page = NULL;
 	struct ksm_stable_node *stable_node;
@@ -2233,7 +2229,7 @@ static void cmp_and_merge_page(struct pa
 	int err;
 	bool max_page_sharing_bypass = false;
 
-	stable_node = page_stable_node(page);
+	stable_node = folio_stable_node(folio);
 	if (stable_node) {
 		if (stable_node->head != &migrate_nodes &&
 		    get_kpfn_nid(READ_ONCE(stable_node->kpfn)) !=
@@ -2272,7 +2268,7 @@ static void cmp_and_merge_page(struct pa
 
 	/* Start by searching for the folio in the stable tree */
 	kfolio = stable_tree_search(page);
-	if (&kfolio->page == page && rmap_item->head == stable_node) {
+	if (kfolio == folio && rmap_item->head == stable_node) {
 		folio_put(kfolio);
 		return;
 	}
@@ -2353,10 +2349,11 @@ static void cmp_and_merge_page(struct pa
 			 * the page is locked, it is better to skip it and
 			 * perhaps try again later.
 			 */
-			if (!trylock_page(page))
+			if (!folio_trylock(folio))
 				return;
 			split_huge_page(page);
-			unlock_page(page);
+			folio = page_folio(page);
+			folio_unlock(folio);
 		}
 	}
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-mlock_count-from-struct-page.patch
ptdesc-convert-__page_flags-to-pt_flags.patch
ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch
ptdesc-remove-ptdesc_to_virt.patch
mm-constify-compound_order-and-page_size.patch
mm-remove-redundant-test-in-validate_page_before_insert.patch
mm-remove-page-order.patch
ksm-use-a-folio-inside-cmp_and_merge_page.patch

