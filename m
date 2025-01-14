Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748321DA53
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 01:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736817368; cv=none; b=cetTu6cqhZjHTtE2ny9N3oZG3N96Qo7kxjJ02jq8iFPo+3v1Y66gZ+85IUBR/3w3w5XG4Tjp5PEN2eP3CpKROB+QcoTUjwGOV6Xfv5jye2P5/+frJ9zG98yqZe2zC8vY8cDyIAAuSuhFARaX///WRjXRGCUjPTjUTl97tHlB/n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736817368; c=relaxed/simple;
	bh=dOZpifmc5K563ztfu44d7qqgatRHqABVJTrbTkpti+Y=;
	h=Date:To:From:Subject:Message-Id; b=njpNxHLnJ0nXtyXwlsCXJQnD6AllDE0pdERHbLh3yEpNzOcww2r2u100efrKoauxyS0H+a3h5QtcgiLwgg3HzYdIhYZ3mXQi4J5UgpzEw47ohtFXq2tJMboUI7NX92CYkxhnKt7fmHukCP8tS1tyLco3ilFEFwXUKrqVWDT6MfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=02jcwPTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="02jcwPTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1443C4CED6;
	Tue, 14 Jan 2025 01:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736817368;
	bh=dOZpifmc5K563ztfu44d7qqgatRHqABVJTrbTkpti+Y=;
	h=Date:To:From:Subject:From;
	b=02jcwPTgx4ycEJqNTRwpVofqzS3apv4ExpP76T4XHUnqIeHBZhi5RSXr0/aYrKqD5
	 tEjI0CIgWSQ3/k6O5czA3gf2C11lRBwWSF3w9+QXlZDPfiQnwiPo7pS4bEpKrUXoyD
	 ux2Mmk9ADx128lJNiI92hZa22MiWGRC7cpjYIS60=
Date: Mon, 13 Jan 2025 17:16:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch added to mm-unstable branch
Message-Id: <20250114011607.E1443C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio
Date: Mon, 13 Jan 2025 14:16:08 +0100

We replaced a simple put_page() by a putback_active_hugepage() call in
commit 3aaa76e125c1 ("mm: migrate: hugetlb: putback destination hugepage
to active list"), to set the "active" flag on the dst hugetlb folio.

Nowadays, we decoupled the "active" list from the flag, by calling the
flag "migratable".

Calling "putback" on something that wasn't allocated is weird and not
future proof, especially if we might reach that path when migration failed
and we just want to free the freshly allocated hugetlb folio.

Let's simply handle the migratable flag and the active list flag in
move_hugetlb_state(), where we know that allocation succeeded and already
handle the temporary flag; use a simple folio_put() to return our
reference.

Link: https://lkml.kernel.org/r/20250113131611.2554758-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ++++++++++
 mm/migrate.c |    8 ++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio
+++ a/mm/hugetlb.c
@@ -7533,6 +7533,16 @@ void move_hugetlb_state(struct folio *ol
 		}
 		spin_unlock_irq(&hugetlb_lock);
 	}
+
+	/*
+	 * Our old folio is isolated and has "migratable" cleared until it
+	 * is putback. As migration succeeded, set the new folio "migratable"
+	 * and add it to the active list.
+	 */
+	spin_lock_irq(&hugetlb_lock);
+	folio_set_hugetlb_migratable(new_folio);
+	list_move_tail(&new_folio->lru, &(folio_hstate(new_folio))->hugepage_activelist);
+	spin_unlock_irq(&hugetlb_lock);
 }
 
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
--- a/mm/migrate.c~mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio
+++ a/mm/migrate.c
@@ -1539,14 +1539,14 @@ out:
 		list_move_tail(&src->lru, ret);
 
 	/*
-	 * If migration was not successful and there's a freeing callback, use
-	 * it.  Otherwise, put_page() will drop the reference grabbed during
-	 * isolation.
+	 * If migration was not successful and there's a freeing callback,
+	 * return the folio to that special allocator. Otherwise, simply drop
+	 * our additional reference.
 	 */
 	if (put_new_folio)
 		put_new_folio(dst, private);
 	else
-		folio_putback_active_hugetlb(dst);
+		folio_put(dst);
 
 	return rc;
 }
_

Patches currently in -mm which might be from david@redhat.com are

docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch
mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

