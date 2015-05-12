From: akpm@linux-foundation.org
Subject: +
 rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch
 added to -mm tree
Date: Tue, 12 May 2015 15:28:48 -0700
Message-ID: <55527ea0.WBUp1VUFJV1DJpa8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbbELW2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 18:28:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hughd@google.com, kirill.shutemov@linux.intel.com, paulmck@linux.vnet.ibm.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: fix theoretical race between do_wp_page and shrink_active_list
has been added to the -mm tree.  Its filename is
     rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: rmap: fix theoretical race between do_wp_page and shrink_active_list

As noted by Paul the compiler is free to store a temporary result in a
variable on stack, heap or global unless it is explicitly marked as
volatile, see:

  http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/n4455.html#sample-optimizations

This can result in a race between do_wp_page() and shrink_active_list() as
follows.

In do_wp_page() we can call page_move_anon_rmap(), which sets
page->mapping as follows:

  anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
  page->mapping = (struct address_space *) anon_vma;

The page in question may be on an LRU list, because nowhere in
do_wp_page() we remove it from the list, neither do we take any LRU
related locks.  Although the page is locked, shrink_active_list() can
still call page_referenced() on it concurrently, because the latter does
not require an anonymous page to be locked:

  CPU0                          CPU1
  ----                          ----
  do_wp_page                    shrink_active_list
   lock_page                     page_referenced
                                  PageAnon->yes, so skip trylock_page
   page_move_anon_rmap
    page->mapping = anon_vma
                                  rmap_walk
                                   PageAnon->no
                                   rmap_walk_file
                                    BUG
    page->mapping += PAGE_MAPPING_ANON

This patch fixes this race by explicitly forbidding the compiler to split
page->mapping store in page_move_anon_rmap() with the aid of WRITE_ONCE.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list mm/rmap.c
--- a/mm/rmap.c~rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list
+++ a/mm/rmap.c
@@ -950,7 +950,7 @@ void page_move_anon_rmap(struct page *pa
 	VM_BUG_ON_PAGE(page->index != linear_page_index(vma, address), page);
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
-	page->mapping = (struct address_space *) anon_vma;
+	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
 }
 
 /**
_

Patches currently in -mm which might be from vdavydov@parallels.com are

gfp-add-__gfp_noaccount.patch
gfp-add-__gfp_noaccount-v2.patch
gfp-add-__gfp_noaccount-v2-fix.patch
kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
linux-next.patch

