Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03CFA2D
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 22:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741301673; cv=none; b=s1LcGWSgOqvCIaU+zmZWWpTknxOjFa4RC9pnaVAR5mYGcm8UdOVaR2KJ3tzR5pBL6symFvQh3oIWGVaQfCnxHGDK8BjHYLH1CfGDm2KLsXryOqFAVf9g/mT/yKHPYq66wJBQLZIhFjnIAsPjWoXAQhVqyjL+clyCkcs0gsGAZaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741301673; c=relaxed/simple;
	bh=eAfEBGRfiaIYR0JYBQXlfh6UgUSzm3NoovuzAFhvDEY=;
	h=Date:To:From:Subject:Message-Id; b=iX38GvRSTAeDYxocvsza90/7N9ONAOk+o0q/4MlUIPJkiXr1tI3blcm7rqN5LptkVhfZzfTo3Yd7dFSMJ/RlMOJdaqgIaHnPntPNxmwtj9Y+iL/IAKL8ttASu6qOkBXWLyqMdP11sP1CZfoNRHMe0tXuBZjMCqGMv6SFdAVLAEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dgupFqsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dgupFqsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EEAC4CEE0;
	Thu,  6 Mar 2025 22:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741301672;
	bh=eAfEBGRfiaIYR0JYBQXlfh6UgUSzm3NoovuzAFhvDEY=;
	h=Date:To:From:Subject:From;
	b=dgupFqsu1IZZqVd3PWY/CIjZHZz5pTdRmPXHp36PKGCk4Io6n3DPymDAPvcf5Wrhe
	 JO2XiY4w5v3ilRj+wn11llO3lIlah/NB3YLbA7OzyhNZM9g7iSYNyjznTy9aGiVPdm
	 R7aPNin4LvrcC7itma9pTFU2OWe/+SW/qMcfe7kE=
Date: Thu, 06 Mar 2025 14:54:32 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,pasha.tatashin@soleen.com,muchun.song@linux.dev,hannes@cmpxchg.org,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-use-new-iteration-api.patch added to mm-unstable branch
Message-Id: <20250306225432.B2EEAC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_table_check: use new iteration API
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-use-new-iteration-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-use-new-iteration-api.patch

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
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm: page_table_check: use new iteration API
Date: Thu, 6 Mar 2025 17:44:51 -0500

The page_ext_next() function assumes that page extension objects for a
page order allocation always reside in the same memory section, which may
not be true and could lead to crashes.  Use the new page_ext iteration API
instead.

Link: https://lkml.kernel.org/r/ca2d53a020fe1cd65c442627ff6c0c40d591cbd8.1741301089.git.luizcap@redhat.com
Fixes: cf54f310d0d3 ("mm/hugetlb: use __GFP_COMP for gigantic folios")
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |   39 ++++++++++++---------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-use-new-iteration-api
+++ a/mm/page_table_check.c
@@ -62,24 +62,20 @@ static struct page_table_check *get_page
  */
 static void page_table_check_clear(unsigned long pfn, unsigned long pgcnt)
 {
+	struct page_ext_iter iter;
 	struct page_ext *page_ext;
 	struct page *page;
-	unsigned long i;
 	bool anon;
 
 	if (!pfn_valid(pfn))
 		return;
 
 	page = pfn_to_page(pfn);
-	page_ext = page_ext_get(page);
-
-	if (!page_ext)
-		return;
-
 	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
-	for (i = 0; i < pgcnt; i++) {
+	rcu_read_lock();
+	for_each_page_ext(page, pgcnt, page_ext, iter) {
 		struct page_table_check *ptc = get_page_table_check(page_ext);
 
 		if (anon) {
@@ -89,9 +85,8 @@ static void page_table_check_clear(unsig
 			BUG_ON(atomic_read(&ptc->anon_map_count));
 			BUG_ON(atomic_dec_return(&ptc->file_map_count) < 0);
 		}
-		page_ext = page_ext_next(page_ext);
 	}
-	page_ext_put(page_ext);
+	rcu_read_unlock();
 }
 
 /*
@@ -102,24 +97,20 @@ static void page_table_check_clear(unsig
 static void page_table_check_set(unsigned long pfn, unsigned long pgcnt,
 				 bool rw)
 {
+	struct page_ext_iter iter;
 	struct page_ext *page_ext;
 	struct page *page;
-	unsigned long i;
 	bool anon;
 
 	if (!pfn_valid(pfn))
 		return;
 
 	page = pfn_to_page(pfn);
-	page_ext = page_ext_get(page);
-
-	if (!page_ext)
-		return;
-
 	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
-	for (i = 0; i < pgcnt; i++) {
+	rcu_read_lock();
+	for_each_page_ext(page, pgcnt, page_ext, iter) {
 		struct page_table_check *ptc = get_page_table_check(page_ext);
 
 		if (anon) {
@@ -129,9 +120,8 @@ static void page_table_check_set(unsigne
 			BUG_ON(atomic_read(&ptc->anon_map_count));
 			BUG_ON(atomic_inc_return(&ptc->file_map_count) < 0);
 		}
-		page_ext = page_ext_next(page_ext);
 	}
-	page_ext_put(page_ext);
+	rcu_read_unlock();
 }
 
 /*
@@ -140,24 +130,19 @@ static void page_table_check_set(unsigne
  */
 void __page_table_check_zero(struct page *page, unsigned int order)
 {
+	struct page_ext_iter iter;
 	struct page_ext *page_ext;
-	unsigned long i;
 
 	BUG_ON(PageSlab(page));
 
-	page_ext = page_ext_get(page);
-
-	if (!page_ext)
-		return;
-
-	for (i = 0; i < (1ul << order); i++) {
+	rcu_read_lock();
+	for_each_page_ext(page, 1 << order, page_ext, iter) {
 		struct page_table_check *ptc = get_page_table_check(page_ext);
 
 		BUG_ON(atomic_read(&ptc->anon_map_count));
 		BUG_ON(atomic_read(&ptc->file_map_count));
-		page_ext = page_ext_next(page_ext);
 	}
-	page_ext_put(page_ext);
+	rcu_read_unlock();
 }
 
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-page_ext-add-an-iteration-api-for-page-extensions.patch
mm-page_table_check-use-new-iteration-api.patch
mm-page_owner-use-new-iteration-api.patch

