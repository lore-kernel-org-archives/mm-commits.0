Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF2EA2D
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741301674; cv=none; b=DAYM8AmSXtsu03O1DA37NEqAdisAFdp6gijzY1vEYAJLF7kbzH7WhnhQkVXQEQEWx+2/pxQruWmLvgmv46fOoe+BrKFHfIS4PdIkwUsMQB1P+eAs8fEUV3QaWIZTorF8BzLf0sEL8ovfTHH2/VpK+7n14SxsRDW4cPLD24oqUFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741301674; c=relaxed/simple;
	bh=OlPocfzTD090Wiy/vSqYp9xAvYi5Bb7RiVShWvCbH+Y=;
	h=Date:To:From:Subject:Message-Id; b=ilHXY7Xp7ydzz8i0GxqmDjaGg2EU2hlshKWRP1XjtSSQG1V9XeKv9GZD85FHRkFOVuA9tgV8If5L5VLTWW7erZt0jobQcU6MJH1U2NHgrzmbz861T++L6YE7GYoL+hAJVxiV81UCG8EerePfeEBNY28E9z1HazutTQ3mUGE+BDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LngCDmRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LngCDmRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D72C4CEE0;
	Thu,  6 Mar 2025 22:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741301674;
	bh=OlPocfzTD090Wiy/vSqYp9xAvYi5Bb7RiVShWvCbH+Y=;
	h=Date:To:From:Subject:From;
	b=LngCDmRtqq7FEWwREQ4osXbTSpj3JvjXX+EeiQ90WR0XdKB7ZoeudRETX91/YYtxz
	 Zw2+tS6tK1DESb2vA/xnpx+TRpuRpd10grNtzc65N7jJONJJtMnkf7/MGvASmu35TG
	 RxGNk1i07GVpg0wCjZsWUdTHec4jcOoDtpi1VTZE=
Date: Thu, 06 Mar 2025 14:54:33 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,pasha.tatashin@soleen.com,muchun.song@linux.dev,hannes@cmpxchg.org,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-use-new-iteration-api.patch added to mm-unstable branch
Message-Id: <20250306225433.E0D72C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_owner: use new iteration API
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-use-new-iteration-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-use-new-iteration-api.patch

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
Subject: mm: page_owner: use new iteration API
Date: Thu, 6 Mar 2025 17:44:52 -0500

The page_ext_next() function assumes that page extension objects for a
page order allocation always reside in the same memory section, which may
not be true and could lead to crashes.  Use the new page_ext iteration API
instead.

Link: https://lkml.kernel.org/r/93c80b040960fa2ebab4a9729073f77a30649862.1741301089.git.luizcap@redhat.com
Fixes: cf54f310d0d3 ("mm/hugetlb: use __GFP_COMP for gigantic folios")
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   84 +++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 45 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-use-new-iteration-api
+++ a/mm/page_owner.c
@@ -229,17 +229,19 @@ static void dec_stack_record_count(depot
 			handle);
 }
 
-static inline void __update_page_owner_handle(struct page_ext *page_ext,
+static inline void __update_page_owner_handle(struct page *page,
 					      depot_stack_handle_t handle,
 					      unsigned short order,
 					      gfp_t gfp_mask,
 					      short last_migrate_reason, u64 ts_nsec,
 					      pid_t pid, pid_t tgid, char *comm)
 {
-	int i;
+	struct page_ext_iter iter;
+	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 
-	for (i = 0; i < (1 << order); i++) {
+	rcu_read_lock();
+	for_each_page_ext(page, 1 << order, page_ext, iter) {
 		page_owner = get_page_owner(page_ext);
 		page_owner->handle = handle;
 		page_owner->order = order;
@@ -252,20 +254,22 @@ static inline void __update_page_owner_h
 			sizeof(page_owner->comm));
 		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 		__set_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
-		page_ext = page_ext_next(page_ext);
 	}
+	rcu_read_unlock();
 }
 
-static inline void __update_page_owner_free_handle(struct page_ext *page_ext,
+static inline void __update_page_owner_free_handle(struct page *page,
 						   depot_stack_handle_t handle,
 						   unsigned short order,
 						   pid_t pid, pid_t tgid,
 						   u64 free_ts_nsec)
 {
-	int i;
+	struct page_ext_iter iter;
+	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 
-	for (i = 0; i < (1 << order); i++) {
+	rcu_read_lock();
+	for_each_page_ext(page, 1 << order, page_ext, iter) {
 		page_owner = get_page_owner(page_ext);
 		/* Only __reset_page_owner() wants to clear the bit */
 		if (handle) {
@@ -275,8 +279,8 @@ static inline void __update_page_owner_f
 		page_owner->free_ts_nsec = free_ts_nsec;
 		page_owner->free_pid = current->pid;
 		page_owner->free_tgid = current->tgid;
-		page_ext = page_ext_next(page_ext);
 	}
+	rcu_read_unlock();
 }
 
 void __reset_page_owner(struct page *page, unsigned short order)
@@ -293,11 +297,11 @@ void __reset_page_owner(struct page *pag
 
 	page_owner = get_page_owner(page_ext);
 	alloc_handle = page_owner->handle;
+	page_ext_put(page_ext);
 
 	handle = save_stack(GFP_NOWAIT | __GFP_NOWARN);
-	__update_page_owner_free_handle(page_ext, handle, order, current->pid,
+	__update_page_owner_free_handle(page, handle, order, current->pid,
 					current->tgid, free_ts_nsec);
-	page_ext_put(page_ext);
 
 	if (alloc_handle != early_handle)
 		/*
@@ -313,19 +317,13 @@ void __reset_page_owner(struct page *pag
 noinline void __set_page_owner(struct page *page, unsigned short order,
 					gfp_t gfp_mask)
 {
-	struct page_ext *page_ext;
 	u64 ts_nsec = local_clock();
 	depot_stack_handle_t handle;
 
 	handle = save_stack(gfp_mask);
-
-	page_ext = page_ext_get(page);
-	if (unlikely(!page_ext))
-		return;
-	__update_page_owner_handle(page_ext, handle, order, gfp_mask, -1,
+	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
 				   ts_nsec, current->pid, current->tgid,
 				   current->comm);
-	page_ext_put(page_ext);
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
 }
 
@@ -344,44 +342,42 @@ void __set_page_owner_migrate_reason(str
 
 void __split_page_owner(struct page *page, int old_order, int new_order)
 {
-	int i;
-	struct page_ext *page_ext = page_ext_get(page);
+	struct page_ext_iter iter;
+	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 
-	if (unlikely(!page_ext))
-		return;
-
-	for (i = 0; i < (1 << old_order); i++) {
+	rcu_read_lock();
+	for_each_page_ext(page, 1 << old_order, page_ext, iter) {
 		page_owner = get_page_owner(page_ext);
 		page_owner->order = new_order;
-		page_ext = page_ext_next(page_ext);
 	}
-	page_ext_put(page_ext);
+	rcu_read_unlock();
 }
 
 void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 {
-	int i;
-	struct page_ext *old_ext;
-	struct page_ext *new_ext;
+	struct page_ext *page_ext;
+	struct page_ext_iter iter;
 	struct page_owner *old_page_owner;
 	struct page_owner *new_page_owner;
 	depot_stack_handle_t migrate_handle;
 
-	old_ext = page_ext_get(&old->page);
-	if (unlikely(!old_ext))
+	page_ext = page_ext_get(&old->page);
+	if (unlikely(!page_ext))
 		return;
 
-	new_ext = page_ext_get(&newfolio->page);
-	if (unlikely(!new_ext)) {
-		page_ext_put(old_ext);
+	old_page_owner = get_page_owner(page_ext);
+	page_ext_put(page_ext);
+
+	page_ext = page_ext_get(&newfolio->page);
+	if (unlikely(!page_ext))
 		return;
-	}
 
-	old_page_owner = get_page_owner(old_ext);
-	new_page_owner = get_page_owner(new_ext);
+	new_page_owner = get_page_owner(page_ext);
+	page_ext_put(page_ext);
+
 	migrate_handle = new_page_owner->handle;
-	__update_page_owner_handle(new_ext, old_page_owner->handle,
+	__update_page_owner_handle(&newfolio->page, old_page_owner->handle,
 				   old_page_owner->order, old_page_owner->gfp_mask,
 				   old_page_owner->last_migrate_reason,
 				   old_page_owner->ts_nsec, old_page_owner->pid,
@@ -391,7 +387,7 @@ void __folio_copy_owner(struct folio *ne
 	 * will be freed after migration. Keep them until then as they may be
 	 * useful.
 	 */
-	__update_page_owner_free_handle(new_ext, 0, old_page_owner->order,
+	__update_page_owner_free_handle(&newfolio->page, 0, old_page_owner->order,
 					old_page_owner->free_pid,
 					old_page_owner->free_tgid,
 					old_page_owner->free_ts_nsec);
@@ -400,14 +396,12 @@ void __folio_copy_owner(struct folio *ne
 	 * for the new one and the old folio otherwise there will be an imbalance
 	 * when subtracting those pages from the stack.
 	 */
-	for (i = 0; i < (1 << new_page_owner->order); i++) {
+	rcu_read_lock();
+	for_each_page_ext(&old->page, 1 << new_page_owner->order, page_ext, iter) {
+		old_page_owner = get_page_owner(page_ext);
 		old_page_owner->handle = migrate_handle;
-		old_ext = page_ext_next(old_ext);
-		old_page_owner = get_page_owner(old_ext);
 	}
-
-	page_ext_put(new_ext);
-	page_ext_put(old_ext);
+	rcu_read_unlock();
 }
 
 void pagetypeinfo_showmixedcount_print(struct seq_file *m,
@@ -813,7 +807,7 @@ static void init_pages_in_zone(pg_data_t
 				goto ext_put_continue;
 
 			/* Found early allocated page */
-			__update_page_owner_handle(page_ext, early_handle, 0, 0,
+			__update_page_owner_handle(page, early_handle, 0, 0,
 						   -1, local_clock(), current->pid,
 						   current->tgid, current->comm);
 			count++;
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-page_ext-add-an-iteration-api-for-page-extensions.patch
mm-page_table_check-use-new-iteration-api.patch
mm-page_owner-use-new-iteration-api.patch

