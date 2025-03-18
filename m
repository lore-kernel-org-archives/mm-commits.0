Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D450282D91
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274610; cv=none; b=ae89cvMCPHn6CZUrEttgEO6M1puiLPzAGh4OUd+RQYlBCi21ykcZzrg6sJhmKEDFnr+/idUvwzSsZAxUl7IFWA30yBQ+YJZ7SlAztngjJ/5H4HLhn4Thx4FD1wYY631Pe3akXlTBDLDiCbt/8EsFtfus7r2KiuZAAxzUB2JPfyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274610; c=relaxed/simple;
	bh=qlpPl+LWqpHJnW8VGyrecNjjzlene2QGeTHQV139Odo=;
	h=Date:To:From:Subject:Message-Id; b=bLK8FvDIN5dof5kzpQubSsb9yt/0fzC9IAI7aDvVMbJX+XecjhxoUPcvnNi9rzb5ceff+XXcIQT9jI9rN52kv66qR+MLv1+OWM1DpjicCh5dUikM2rGbdthCbRIPGAY3s9n8gBn1oIqP2dzlRf58Q++NOnZPVq1UTM+8UqgCw6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tGv2nuq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tGv2nuq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB98FC4CEDD;
	Tue, 18 Mar 2025 05:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274610;
	bh=qlpPl+LWqpHJnW8VGyrecNjjzlene2QGeTHQV139Odo=;
	h=Date:To:From:Subject:From;
	b=tGv2nuq4gXTz/iQnhXextEz+yDcw55Co4QWXslBYcgi5Uuiky8F5gqAgIK3rYlcfQ
	 dSkdxYItZ64K7jhGhDXZGeqBuvb9r0KG1vm8NNWMYTE0DWC8RQINpm8QPd+RIxRPuj
	 rvQPlEQmZTeKHsFCv0RVr7ujeLLU4FXJENqelENY=
Date: Mon, 17 Mar 2025 22:10:10 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,pasha.tatashin@soleen.com,muchun.song@linux.dev,hannes@cmpxchg.org,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-use-new-iteration-api.patch removed from -mm tree
Message-Id: <20250318051010.AB98FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_table_check: use new iteration API
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-use-new-iteration-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


