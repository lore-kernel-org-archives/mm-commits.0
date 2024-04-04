Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FF013AA59
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 21:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712265201; cv=none; b=V9gS2kJQcg5BPZwmcLgYL1pcU1sl8nUOgOW9V7i4QxAmRqtaN+XKW17XUtgO3hfxmoqBUUeYn+pQU79KJH6/NgiLtLJUPdGjin5J7HPOS1sgi2YBDFJs5cvwSLwmjpAuok/u5S1H2x9ek4sAddmpRdXcEmMvNihCb9WaYAHQQ18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712265201; c=relaxed/simple;
	bh=t9kbdfKyTLiMKOiBqunCZYmtWm1QbgnJpuxbfdf1et4=;
	h=Date:To:From:Subject:Message-Id; b=hCStSCG0M7Ut5FvqFVKbuVgZ8tDmnuN/qFUIguMGJSjjYApclyEJGlMZK5fHPwiLpDqUiJbpPxt+FYlm/hJd/N9NHWRq102FQAcd6fd6jOycL2TuXMEtgCoeJkanX+sA3PN84DGCkZRX1UNKl+Ixy9gqpH1VU8Bi2fRZXy2CdmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rUR+Xxvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rUR+Xxvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E428C43390;
	Thu,  4 Apr 2024 21:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712265201;
	bh=t9kbdfKyTLiMKOiBqunCZYmtWm1QbgnJpuxbfdf1et4=;
	h=Date:To:From:Subject:From;
	b=rUR+XxvuvWat1vcXByWtbrImxW/ZWOT5xfTfEaEGGlGD6IicXkpk1Lh0lUiHzTZx4
	 1N6j5W6rfOXnl7zAyyd2Ix54grQmPD2RN6to6DoC/J0ClfVJ0UWqWS9N8OEKP5YYJ+
	 dMHVj7Bf6CY0fxnWaSMt4a3Yvt5BZnGgRTqXkx4o=
Date: Thu, 04 Apr 2024 14:13:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,alexghiti@rivosinc.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-update-metadata-for-tail-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20240404211321.2E428C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: update metadata for tail pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmpage_owner-update-metadata-for-tail-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-update-metadata-for-tail-pages.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: update metadata for tail pages
Date: Thu, 4 Apr 2024 09:06:59 +0200

Patch series "page_owner: Fix refcount imbalance and print fixup", v4.

This series consists of a refactoring/correctness of updating the metadata
of tail pages, a couple of fixups for the refcounting part and a fixup for
the stack_start() function.

From this series on, instead of counting the stacks, we count the
outstanding nr_base_pages each stack has, which gives us a much better
memory overview.  The other fixup is for the migration part.

A more detailed explanation can be found in the changelog of the
respective patches.


This patch (of 4):

__set_page_owner_handle() and __reset_page_owner() update the metadata of
all pages when the page is of a higher-order, but we miss to do the same
when the pages are migrated.  __folio_copy_owner() only updates the
metadata of the head page, meaning that the information stored in the
first page and the tail pages will not match.

Strictly speaking that is not a big problem because 1) we do not print
tail pages and 2) upon splitting all tail pages will inherit the metadata
of the head page, but it is better to have all metadata in check should
there be any problem, so it can ease debugging.

For that purpose, a couple of helpers are created
__update_page_owner_handle() which updates the metadata on allocation, and
__update_page_owner_free_handle() which does the same when the page is
freed.

__folio_copy_owner() will make use of both as it needs to entirely replace
the page_owner metadata for the new page.

Link: https://lkml.kernel.org/r/20240404070702.2744-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20240404070702.2744-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |  137 ++++++++++++++++++++++++----------------------
 1 file changed, 74 insertions(+), 63 deletions(-)

--- a/mm/page_owner.c~mmpage_owner-update-metadata-for-tail-pages
+++ a/mm/page_owner.c
@@ -228,9 +228,58 @@ static void dec_stack_record_count(depot
 		refcount_dec(&stack_record->count);
 }
 
-void __reset_page_owner(struct page *page, unsigned short order)
+static inline void __update_page_owner_handle(struct page_ext *page_ext,
+					      depot_stack_handle_t handle,
+					      unsigned short order,
+					      gfp_t gfp_mask,
+					      short last_migrate_reason, u64 ts_nsec,
+					      pid_t pid, pid_t tgid, char *comm)
 {
 	int i;
+	struct page_owner *page_owner;
+
+	for (i = 0; i < (1 << order); i++) {
+		page_owner = get_page_owner(page_ext);
+		page_owner->handle = handle;
+		page_owner->order = order;
+		page_owner->gfp_mask = gfp_mask;
+		page_owner->last_migrate_reason = last_migrate_reason;
+		page_owner->pid = pid;
+		page_owner->tgid = tgid;
+		page_owner->ts_nsec = ts_nsec;
+		strscpy(page_owner->comm, comm,
+			sizeof(page_owner->comm));
+		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
+		__set_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
+		page_ext = page_ext_next(page_ext);
+	}
+}
+
+static inline void __update_page_owner_free_handle(struct page_ext *page_ext,
+						   depot_stack_handle_t handle,
+						   unsigned short order,
+						   pid_t pid, pid_t tgid,
+						   u64 free_ts_nsec)
+{
+	int i;
+	struct page_owner *page_owner;
+
+	for (i = 0; i < (1 << order); i++) {
+		page_owner = get_page_owner(page_ext);
+		/* Only __reset_page_owner() wants to clear the bit */
+		if (handle) {
+			__clear_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
+			page_owner->free_handle = handle;
+		}
+		page_owner->free_ts_nsec = free_ts_nsec;
+		page_owner->free_pid = current->pid;
+		page_owner->free_tgid = current->tgid;
+		page_ext = page_ext_next(page_ext);
+	}
+}
+
+void __reset_page_owner(struct page *page, unsigned short order)
+{
 	struct page_ext *page_ext;
 	depot_stack_handle_t handle;
 	depot_stack_handle_t alloc_handle;
@@ -245,16 +294,10 @@ void __reset_page_owner(struct page *pag
 	alloc_handle = page_owner->handle;
 
 	handle = save_stack(GFP_NOWAIT | __GFP_NOWARN);
-	for (i = 0; i < (1 << order); i++) {
-		__clear_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
-		page_owner->free_handle = handle;
-		page_owner->free_ts_nsec = free_ts_nsec;
-		page_owner->free_pid = current->pid;
-		page_owner->free_tgid = current->tgid;
-		page_ext = page_ext_next(page_ext);
-		page_owner = get_page_owner(page_ext);
-	}
+	__update_page_owner_free_handle(page_ext, handle, order, current->pid,
+					current->tgid, free_ts_nsec);
 	page_ext_put(page_ext);
+
 	if (alloc_handle != early_handle)
 		/*
 		 * early_handle is being set as a handle for all those
@@ -266,36 +309,11 @@ void __reset_page_owner(struct page *pag
 		dec_stack_record_count(alloc_handle);
 }
 
-static inline void __set_page_owner_handle(struct page_ext *page_ext,
-					depot_stack_handle_t handle,
-					unsigned short order, gfp_t gfp_mask)
-{
-	struct page_owner *page_owner;
-	int i;
-	u64 ts_nsec = local_clock();
-
-	for (i = 0; i < (1 << order); i++) {
-		page_owner = get_page_owner(page_ext);
-		page_owner->handle = handle;
-		page_owner->order = order;
-		page_owner->gfp_mask = gfp_mask;
-		page_owner->last_migrate_reason = -1;
-		page_owner->pid = current->pid;
-		page_owner->tgid = current->tgid;
-		page_owner->ts_nsec = ts_nsec;
-		strscpy(page_owner->comm, current->comm,
-			sizeof(page_owner->comm));
-		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
-		__set_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
-
-		page_ext = page_ext_next(page_ext);
-	}
-}
-
 noinline void __set_page_owner(struct page *page, unsigned short order,
 					gfp_t gfp_mask)
 {
 	struct page_ext *page_ext;
+	u64 ts_nsec = local_clock();
 	depot_stack_handle_t handle;
 
 	handle = save_stack(gfp_mask);
@@ -303,7 +321,9 @@ noinline void __set_page_owner(struct pa
 	page_ext = page_ext_get(page);
 	if (unlikely(!page_ext))
 		return;
-	__set_page_owner_handle(page_ext, handle, order, gfp_mask);
+	__update_page_owner_handle(page_ext, handle, order, gfp_mask, -1,
+				   current->pid, current->tgid, ts_nsec,
+				   current->comm);
 	page_ext_put(page_ext);
 	inc_stack_record_count(handle, gfp_mask);
 }
@@ -342,7 +362,7 @@ void __folio_copy_owner(struct folio *ne
 {
 	struct page_ext *old_ext;
 	struct page_ext *new_ext;
-	struct page_owner *old_page_owner, *new_page_owner;
+	struct page_owner *old_page_owner;
 
 	old_ext = page_ext_get(&old->page);
 	if (unlikely(!old_ext))
@@ -355,31 +375,21 @@ void __folio_copy_owner(struct folio *ne
 	}
 
 	old_page_owner = get_page_owner(old_ext);
-	new_page_owner = get_page_owner(new_ext);
-	new_page_owner->order = old_page_owner->order;
-	new_page_owner->gfp_mask = old_page_owner->gfp_mask;
-	new_page_owner->last_migrate_reason =
-		old_page_owner->last_migrate_reason;
-	new_page_owner->handle = old_page_owner->handle;
-	new_page_owner->pid = old_page_owner->pid;
-	new_page_owner->tgid = old_page_owner->tgid;
-	new_page_owner->free_pid = old_page_owner->free_pid;
-	new_page_owner->free_tgid = old_page_owner->free_tgid;
-	new_page_owner->ts_nsec = old_page_owner->ts_nsec;
-	new_page_owner->free_ts_nsec = old_page_owner->ts_nsec;
-	strcpy(new_page_owner->comm, old_page_owner->comm);
-
+	__update_page_owner_handle(new_ext, old_page_owner->handle,
+				   old_page_owner->order, old_page_owner->gfp_mask,
+				   old_page_owner->last_migrate_reason,
+				   old_page_owner->ts_nsec, old_page_owner->pid,
+				   old_page_owner->tgid, old_page_owner->comm);
 	/*
-	 * We don't clear the bit on the old folio as it's going to be freed
-	 * after migration. Until then, the info can be useful in case of
-	 * a bug, and the overall stats will be off a bit only temporarily.
-	 * Also, migrate_misplaced_transhuge_page() can still fail the
-	 * migration and then we want the old folio to retain the info. But
-	 * in that case we also don't need to explicitly clear the info from
-	 * the new page, which will be freed.
+	 * Do not proactively clear PAGE_EXT_OWNER{_ALLOCATED} bits as the folio
+	 * will be freed after migration. Keep them until then as they may be
+	 * useful.
 	 */
-	__set_bit(PAGE_EXT_OWNER, &new_ext->flags);
-	__set_bit(PAGE_EXT_OWNER_ALLOCATED, &new_ext->flags);
+	__update_page_owner_free_handle(new_ext, 0, old_page_owner->order,
+					old_page_owner->free_pid,
+					old_page_owner->free_tgid,
+					old_page_owner->free_ts_nsec);
+
 	page_ext_put(new_ext);
 	page_ext_put(old_ext);
 }
@@ -787,8 +797,9 @@ static void init_pages_in_zone(pg_data_t
 				goto ext_put_continue;
 
 			/* Found early allocated page */
-			__set_page_owner_handle(page_ext, early_handle,
-						0, 0);
+			__update_page_owner_handle(page_ext, early_handle, 0, 0,
+						   -1, local_clock(), current->pid,
+						   current->tgid, current->comm);
 			count++;
 ext_put_continue:
 			page_ext_put(page_ext);
_

Patches currently in -mm which might be from osalvador@suse.de are

mmpage_owner-update-metadata-for-tail-pages.patch
mmpage_owner-fix-refcount-imbalance.patch
mmpage_owner-fix-accounting-of-pages-when-migrating.patch
mmpage_owner-fix-printing-of-stack-records.patch

