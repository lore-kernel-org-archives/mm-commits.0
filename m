From: akpm@linux-foundation.org
Subject: +
 mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch added to
 -mm tree
Date: Mon, 19 Oct 2015 15:03:32 -0700
Message-ID: <562568b4.6pITIXJHkOCMF4wp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbbJSWDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 18:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page migration trylock newpage at same level as oldpage
has been added to the -mm tree.  Its filename is
     mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: page migration trylock newpage at same level as oldpage

Clean up page migration a little by moving the trylock of newpage from
move_to_new_page() into __unmap_and_move(), where the old page has been
locked.  Adjust unmap_and_move_huge_page() and balloon_page_migrate()
accordingly.

But make one kind-of-functional change on the way: whereas trylock of
newpage used to BUG() if it failed, now simply return -EAGAIN if so. 
Cutting out BUG()s is good, right?  But, to be honest, this is really to
extend the usefulness of the custom put_new_page feature, allowing a pool
of new pages to be shared perhaps with racing uses.

Use an "else" instead of that "skip_unmap" label.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/balloon_compaction.c |   10 +-------
 mm/migrate.c            |   46 +++++++++++++++++++++-----------------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff -puN mm/balloon_compaction.c~mm-page-migration-trylock-newpage-at-same-level-as-oldpage mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-page-migration-trylock-newpage-at-same-level-as-oldpage
+++ a/mm/balloon_compaction.c
@@ -199,23 +199,17 @@ int balloon_page_migrate(struct page *ne
 	struct balloon_dev_info *balloon = balloon_page_device(page);
 	int rc = -EAGAIN;
 
-	/*
-	 * Block others from accessing the 'newpage' when we get around to
-	 * establishing additional references. We should be the only one
-	 * holding a reference to the 'newpage' at this point.
-	 */
-	BUG_ON(!trylock_page(newpage));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
 	if (WARN_ON(!__is_movable_balloon_page(page))) {
 		dump_page(page, "not movable balloon page");
-		unlock_page(newpage);
 		return rc;
 	}
 
 	if (balloon && balloon->migratepage)
 		rc = balloon->migratepage(balloon, newpage, page, mode);
 
-	unlock_page(newpage);
 	return rc;
 }
 #endif /* CONFIG_BALLOON_COMPACTION */
diff -puN mm/migrate.c~mm-page-migration-trylock-newpage-at-same-level-as-oldpage mm/migrate.c
--- a/mm/migrate.c~mm-page-migration-trylock-newpage-at-same-level-as-oldpage
+++ a/mm/migrate.c
@@ -727,13 +727,8 @@ static int move_to_new_page(struct page
 	struct address_space *mapping;
 	int rc;
 
-	/*
-	 * Block others from accessing the page when we get around to
-	 * establishing additional references. We are the only one
-	 * holding a reference to the new page at this point.
-	 */
-	if (!trylock_page(newpage))
-		BUG();
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
 	/* Prepare mapping for the new page.*/
 	newpage->index = page->index;
@@ -774,9 +769,6 @@ static int move_to_new_page(struct page
 			remove_migration_ptes(page, newpage);
 		page->mapping = NULL;
 	}
-
-	unlock_page(newpage);
-
 	return rc;
 }
 
@@ -861,6 +853,17 @@ static int __unmap_and_move(struct page
 		}
 	}
 
+	/*
+	 * Block others from accessing the new page when we get around to
+	 * establishing additional references. We are usually the only one
+	 * holding a reference to newpage at this point. We used to have a BUG
+	 * here if trylock_page(newpage) fails, but would like to allow for
+	 * cases where there might be a race with the previous use of newpage.
+	 * This is much like races on refcount of oldpage: just don't BUG().
+	 */
+	if (unlikely(!trylock_page(newpage)))
+		goto out_unlock;
+
 	if (unlikely(isolated_balloon_page(page))) {
 		/*
 		 * A ballooned page does not need any special attention from
@@ -870,7 +873,7 @@ static int __unmap_and_move(struct page
 		 * the page migration right away (proteced by page lock).
 		 */
 		rc = balloon_page_migrate(newpage, page, mode);
-		goto out_unlock;
+		goto out_unlock_both;
 	}
 
 	/*
@@ -889,30 +892,27 @@ static int __unmap_and_move(struct page
 		VM_BUG_ON_PAGE(PageAnon(page), page);
 		if (page_has_private(page)) {
 			try_to_free_buffers(page);
-			goto out_unlock;
+			goto out_unlock_both;
 		}
-		goto skip_unmap;
-	}
-
-	/* Establish migration ptes or remove ptes */
-	if (page_mapped(page)) {
+	} else if (page_mapped(page)) {
+		/* Establish migration ptes */
 		try_to_unmap(page,
 			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 		page_was_mapped = 1;
 	}
 
-skip_unmap:
 	if (!page_mapped(page))
 		rc = move_to_new_page(newpage, page, page_was_mapped, mode);
 
 	if (rc && page_was_mapped)
 		remove_migration_ptes(page, page);
 
+out_unlock_both:
+	unlock_page(newpage);
+out_unlock:
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
 		put_anon_vma(anon_vma);
-
-out_unlock:
 	unlock_page(page);
 out:
 	return rc;
@@ -1056,6 +1056,9 @@ static int unmap_and_move_huge_page(new_
 	if (PageAnon(hpage))
 		anon_vma = page_get_anon_vma(hpage);
 
+	if (unlikely(!trylock_page(new_hpage)))
+		goto put_anon;
+
 	if (page_mapped(hpage)) {
 		try_to_unmap(hpage,
 			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
@@ -1068,6 +1071,9 @@ static int unmap_and_move_huge_page(new_
 	if (rc != MIGRATEPAGE_SUCCESS && page_was_mapped)
 		remove_migration_ptes(hpage, hpage);
 
+	unlock_page(new_hpage);
+
+put_anon:
 	if (anon_vma)
 		put_anon_vma(anon_vma);
 
_

Patches currently in -mm which might be from hughd@google.com are

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
mm-use-unsigned-int-for-page-order-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch

