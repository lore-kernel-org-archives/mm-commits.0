Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF241DFDE
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597507; cv=none; b=Zd0uRn5trmu1j7GJj+YblmE5DaBdV1YyzANolGZq0PZOTNJdxLVlj+prCXmdVcLHxmgWj4wxhJ6vNCi/3FGYJMnCARuc8SKPFj942ZggeE8WKZSDj1vV1O42nECRUV1R4+9ZdQfh+2DglrgCRbqPeF2pcO3Spw143jiK2+ITB+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597507; c=relaxed/simple;
	bh=oRHjhHIBnelT+e2p52hfQk5BqpAscL8U83GwvvLrkBk=;
	h=Date:To:From:Subject:Message-Id; b=PLlwluabnDKaxu4hx0FrrCUWJZkchB8pQLVK3aBHmcUK9JgrIpjMqzwF00FbBJJldp6ImrDBdEFi81E7Qet5rB2XwcGuDRP10n8IK3esOF94DfykRs1HOwPIcwu/pFRbm8oLQEZlcx67Re2rremKkQc75Y+/5mqCJMjJ1GP+uV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J0TaCDDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J0TaCDDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B327FC4CEF0;
	Tue, 23 Sep 2025 03:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597506;
	bh=oRHjhHIBnelT+e2p52hfQk5BqpAscL8U83GwvvLrkBk=;
	h=Date:To:From:Subject:From;
	b=J0TaCDDFV7QMYhQ8xGzTN5CPP9YICPaEXta8zdmr8fItfA2AOEHP7cA/HYPdLTQm6
	 sxY45GuE/U3VAr9K1mldS7jvbUUoRH24Rkmi3dIcB8F2vPU9/uyXV3sidKQwb3Lwpm
	 dAculKjBsTi10aQDlyuAaCJeU5u+e2Acl5OxJfuQ=
Date: Mon, 22 Sep 2025 20:18:26 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,xialonglong@kylinos.cn,david@redhat.com,chengming.zhou@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-use-a-folio-inside-cmp_and_merge_page.patch removed from -mm tree
Message-Id: <20250923031826.B327FC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: use a folio inside cmp_and_merge_page()
has been removed from the -mm tree.  Its filename was
     ksm-use-a-folio-inside-cmp_and_merge_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ksm: use a folio inside cmp_and_merge_page()
Date: Tue, 16 Sep 2025 19:11:59 +0100

This removes the last call to page_stable_node(), so delete the wrapper. 
It also removes a call to trylock_page() and saves a call to
compound_head(), as well as removing a reference to folio->page.

Link: https://lkml.kernel.org/r/20250916181219.2400258-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
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


