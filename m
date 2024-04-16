Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4DE1E511
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 22:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307221; cv=none; b=Xav/73KWfTTXFxWthhpOpcgBueJhfIa/oQnqZNWLuV11EEL7j0agWDc15B1Y7qcjRxoC4dmP71rNQcbFlYpaA8wEONtwt4L7a2eUvIw95rSzBvF5sfReX3jUt+BLCdmS1NXfK2RKLgoCH+Lgq47/SGtE0y6CWSDZjWOwXk16ldA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307221; c=relaxed/simple;
	bh=oIdPBl8eFlnHNN25HX7uiLmr0j+hW6wOz2DVjWBDy3k=;
	h=Date:To:From:Subject:Message-Id; b=kFcJQmZLHtNFVQ+/2aAeAx7OAISdF0s3XWu+8SfoQTHzuDjf6IwdKuOOPVmE8aLiNzg5l4GjEmd6tcciLYvgmINu+G8OS5KWatoh2Uw1sAL4BNJnwRjeb/fWxjIgQfvS0DCweijf07qBLpO0arl3mCse9EVTK39YaAxa5GHugGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aO+TZ2D1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aO+TZ2D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DA6C3277B;
	Tue, 16 Apr 2024 22:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307221;
	bh=oIdPBl8eFlnHNN25HX7uiLmr0j+hW6wOz2DVjWBDy3k=;
	h=Date:To:From:Subject:From;
	b=aO+TZ2D1XGdKgDFxM8NKaA6h+Lil7DIScB2QfdfkGV0WRzb6uUi9xUDVth89b1uck
	 q7oJ66wTO7FfozFZE3bIiaxB57I1CZSGKUlODINqXfKANbMtyCrgOEENaW7h62DbxH
	 t5ILY1ulR8p5hJJhmjq1HxmOtO3TASdc+cZxTkqc=
Date: Tue, 16 Apr 2024 15:40:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,palmer@dabbelt.com,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,alexghiti@rivosinc.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmpage_owner-fix-accounting-of-pages-when-migrating.patch removed from -mm tree
Message-Id: <20240416224021.93DA6C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,page_owner: fix accounting of pages when migrating
has been removed from the -mm tree.  Its filename was
     mmpage_owner-fix-accounting-of-pages-when-migrating.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: fix accounting of pages when migrating
Date: Thu, 4 Apr 2024 09:07:01 +0200

Upon migration, new allocated pages are being given the handle of the old
pages.  This is problematic because it means that for the stack which
allocated the old page, we will be substracting the old page + the new one
when that page is freed, creating an accounting imbalance.

There is an interest in keeping it that way, as otherwise the output will
biased towards migration stacks should those operations occur often, but
that is not really helpful.

The link from the new page to the old stack is being performed by calling
__update_page_owner_handle() in __folio_copy_owner().  The only thing that
is left is to link the migrate stack to the old page, so the old page will
be subtracted from the migrate stack, avoiding by doing so any possible
imbalance.

Link: https://lkml.kernel.org/r/20240404070702.2744-4-osalvador@suse.de
Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/page_owner.c~mmpage_owner-fix-accounting-of-pages-when-migrating
+++ a/mm/page_owner.c
@@ -366,9 +366,12 @@ void __split_page_owner(struct page *pag
 
 void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 {
+	int i;
 	struct page_ext *old_ext;
 	struct page_ext *new_ext;
 	struct page_owner *old_page_owner;
+	struct page_owner *new_page_owner;
+	depot_stack_handle_t migrate_handle;
 
 	old_ext = page_ext_get(&old->page);
 	if (unlikely(!old_ext))
@@ -381,6 +384,8 @@ void __folio_copy_owner(struct folio *ne
 	}
 
 	old_page_owner = get_page_owner(old_ext);
+	new_page_owner = get_page_owner(new_ext);
+	migrate_handle = new_page_owner->handle;
 	__update_page_owner_handle(new_ext, old_page_owner->handle,
 				   old_page_owner->order, old_page_owner->gfp_mask,
 				   old_page_owner->last_migrate_reason,
@@ -395,6 +400,16 @@ void __folio_copy_owner(struct folio *ne
 					old_page_owner->free_pid,
 					old_page_owner->free_tgid,
 					old_page_owner->free_ts_nsec);
+	/*
+	 * We linked the original stack to the new folio, we need to do the same
+	 * for the new one and the old folio otherwise there will be an imbalance
+	 * when subtracting those pages from the stack.
+	 */
+	for (i = 0; i < (1 << new_page_owner->order); i++) {
+		old_page_owner->handle = migrate_handle;
+		old_ext = page_ext_next(old_ext);
+		old_page_owner = get_page_owner(old_ext);
+	}
 
 	page_ext_put(new_ext);
 	page_ext_put(old_ext);
_

Patches currently in -mm which might be from osalvador@suse.de are


