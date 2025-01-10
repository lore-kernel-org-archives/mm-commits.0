Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98230207DFD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 23:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550281; cv=none; b=ckOu99+dbUZ+fZQ5aH/Or0qJoUksoN/4ZlVh73PdBdbcK2AqHbG7JkiQFa38FewO0ZELjslpZxv1ncSbHXDPo6D6MHN24vzFWmgrpX0ByMZZwSq4JOei1WCHHp8cGeHIydBkAowHvJq8FzRMpfI996Am8sww0zX544X8b5YVmbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550281; c=relaxed/simple;
	bh=9MmnrRfIVejmCSGQ3kX18/OqlJooaCtiIr1XqSeruKw=;
	h=Date:To:From:Subject:Message-Id; b=aXE7F86YewjJrp2INCw83nBSTnPwYfWihbrMqh8XzZZH8FKJyQoKdz91MN7XDKwk144CZijkWvFm1DDJDQ7XzuGXGBTNmJwGKVhWNatQc9C+Du/YhL6MCgde+F1OU6N+7u4kRGOMhPeEqxreu0AkK9+ckmzPPT+azJUAl7nQRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0fkEkgfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0fkEkgfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E24C4CED6;
	Fri, 10 Jan 2025 23:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736550281;
	bh=9MmnrRfIVejmCSGQ3kX18/OqlJooaCtiIr1XqSeruKw=;
	h=Date:To:From:Subject:From;
	b=0fkEkgfxaC3NXl9TU7N+DjGuWruIJ1W9lNq7KQV9tDV2bDgaivmiOzbXP7EW1WLoU
	 S8/cfRnQJnDq7kiNYOz6lI78gZs+8fRs1MGcK0aXv+53Ji84+BVvmh5Uho1v0SvtYz
	 sHSTstP8WZaHPq/VfxElJMej41yg6W7Ftla2akxE=
Date: Fri, 10 Jan 2025 15:04:40 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch added to mm-unstable branch
Message-Id: <20250110230441.16E24C4CED6@smtp.kernel.org>
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
Date: Fri, 10 Jan 2025 19:21:46 +0100

We replaced a simple put_page() by a putback_active_hugepage() call in
commit 3aaa76e125c1 ("mm: migrate: hugetlb: putback destination hugepage
to active list"), to set the "active" flag on the dst hugetlb folio.

Nowadays, we decoupled the "active" list from the flag, by calling the
flag "migratable".

Calling "putback" on something that wasn't allocated is weird and not
future proof, especially if we might reach that path when migration failed
and we just want to free the freshly allocated hugetlb folio.

Let's simply set the "migratable" flag in move_hugetlb_state(), where we
know that allocation succeeded, and use simple folio_put() to return our
reference.

Do we need the hugetlb_lock for setting that flag?  Staring at other users
of folio_set_hugetlb_migratable(), it does not look like it.  After all,
the dst folio should already be on the active list, and we are not
modifying that list.

Link: https://lkml.kernel.org/r/20250110182149.746551-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++++
 mm/migrate.c |    8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio
+++ a/mm/hugetlb.c
@@ -7529,6 +7529,11 @@ void move_hugetlb_state(struct folio *ol
 		}
 		spin_unlock_irq(&hugetlb_lock);
 	}
+	/*
+	 * Our old folio is isolated and has "migratable" cleared until it
+	 * is putback. As migration succeeded, set the new folio "migratable".
+	 */
+	folio_set_hugetlb_migratable(new_folio);
 }
 
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
--- a/mm/migrate.c~mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio
+++ a/mm/migrate.c
@@ -1542,14 +1542,14 @@ out:
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

