Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A063A7F48
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 03:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783999264; cv=none; b=oRnyiwkcJxw8iUl26ahA6VxLmFUAuiQweOz3EO+iVxSsFy2BYnepXtv7B/o7qlM9WK3hZtXaWRdLwoBjXkVW6MzEIhjJgfLiiMdZIZjqf01jiDOJfNxfzl3hW9bHQtFKoZqSeqFu+I5IPPln4qnvkvYUP5RvDp8ZF20hV191B8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783999264; c=relaxed/simple;
	bh=qpvExZqCyQ2DYRnf5U7TPeWAUPgouqoQSsDkTRUPgAs=;
	h=Date:To:From:Subject:Message-Id; b=FR5+TroHhct94ypkf3uI7YkrPsGWyAbDOM54gvpS75e2g2PSDxe5QOAEFwuFsbldzvNL5xERum7SReMFP6wpxoCAB/6pVK96FZ6QmEXDFuCsAWucp3/D5Ih9WHvrhq8DMIAfZ6KrfdN3Ydfza+J37rLSwH8Q/aJ57NYoMtWkQqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=neLFO9+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="neLFO9+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CF91F000E9;
	Tue, 14 Jul 2026 03:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783999262;
	bh=iJww7fmMiI9eSXEkuzxroBsM/mX6uligA21JsgC3P4g=;
	h=Date:To:From:Subject;
	b=neLFO9+7BK3SSnBFBzVpfF3/fu+zFB7WHxwvuAX6DICmldZBdsISiuQj5AA7K5kNj
	 7ENLgNHz1/3ckv8suta2YUQkMOpNPxbsaQyKxxvuJ5MSE5w/SFHhdzfrnZ3iQYz3zz
	 mnJx2KeqnDynPRVd7FgEr56ml80StF7bP2qlxA+g=
Date: Mon, 13 Jul 2026 20:21:02 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-use-memcg_data-snapshot-to-avoid-toctou-in-print_page_owner_memcg.patch added to mm-unstable branch
Message-Id: <20260714032102.99CF91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-use-memcg_data-snapshot-to-avoid-toctou-in-print_page_owner_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-use-memcg_data-snapshot-to-avoid-toctou-in-print_page_owner_memcg.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
Date: Tue, 14 Jul 2026 09:51:08 +0800

print_page_owner_memcg() takes a snapshot of page->memcg_data via
READ_ONCE at the top of the function and guards against tail pages and
NULL memcg_data.  However, it later calls two functions that re-read
page->memcg_data locklessly:

  1) page_memcg_check(page) — re-reads page->memcg_data;
  2) PageMemcgKmem(page) — calls folio_memcg_kmem(), which re-reads
     folio->memcg_data and folio->page->compound_head, wrapping both
     in VM_BUG_ON assertions:

        VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
        VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);

If the page is concurrently freed and reallocated as a THP tail page or a
slab page between the initial guards and these later calls, the VM_BUG_ON
assertions can fire on debug builds (CONFIG_DEBUG_VM=y), causing a kernel
panic.

Fix both TOCTOU issues by using the memcg_data snapshot throughout:
  - Extract objcg from the snapshot via objcg = (void *)(memcg_data &
    ~OBJEXTS_FLAGS_MASK) instead of calling page_memcg_check(page);
  - Test (memcg_data & MEMCG_DATA_KMEM) instead of calling
    PageMemcgKmem(page), which is semantically equivalent:
    PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data &
    MEMCG_DATA_KMEM.
  - When memcg_data has MEMCG_DATA_OBJEXTS set, early-return after
    printing "Slab cache page\n" since objcg != memcg for slab pages
    and there is no meaningful cgroup to look up.

This avoids both TOCTOU windows and the assertions entirely.

Link: https://lore.kernel.org/20260714015117.78351-10-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-use-memcg_data-snapshot-to-avoid-toctou-in-print_page_owner_memcg
+++ a/mm/page_owner.c
@@ -540,6 +540,7 @@ static inline int print_page_owner_memcg
 					 struct page *page)
 {
 	unsigned long memcg_data;
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	bool online;
 	char name[80];
@@ -549,11 +550,14 @@ static inline int print_page_owner_memcg
 	if (!memcg_data || PageTail(page))
 		goto out_unlock;
 
-	if (memcg_data & MEMCG_DATA_OBJEXTS)
+	if (memcg_data & MEMCG_DATA_OBJEXTS) {
 		ret += scnprintf(kbuf + ret, count - ret,
 				"Slab cache page\n");
+		goto out_unlock;
+	}
 
-	memcg = page_memcg_check(page);
+	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
+	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
 	if (!memcg)
 		goto out_unlock;
 
@@ -561,7 +565,7 @@ static inline int print_page_owner_memcg
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-			PageMemcgKmem(page) ? "(via objcg) " : "",
+			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
 			online ? "" : "offline ",
 			name);
 out_unlock:
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch
mm-use-enum-migrate_reason-instead-of-int-for-migration-reason-parameters.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-to-avoid-toctou-in-print_page_owner_memcg.patch

