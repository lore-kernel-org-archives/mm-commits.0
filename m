From: akpm@linux-foundation.org
Subject: + thp-mm-locking-tail-page-is-a-bug-fix.patch added to -mm tree
Date: Mon, 05 Aug 2013 14:19:34 -0700
Message-ID: <520016e6.Jkh+Pjnlu0BDdC6n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3HEVTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 17:19:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: + thp-mm-locking-tail-page-is-a-bug-fix.patch added to -mm tree
To: kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 14:19:34 -0700


The patch titled
     Subject: thp-mm-locking-tail-page-is-a-bug-fix
has been added to the -mm tree.  Its filename is
     thp-mm-locking-tail-page-is-a-bug-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-mm-locking-tail-page-is-a-bug-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-mm-locking-tail-page-is-a-bug-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp-mm-locking-tail-page-is-a-bug-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/pagemap.h~thp-mm-locking-tail-page-is-a-bug-fix include/linux/pagemap.h
--- a/include/linux/pagemap.h~thp-mm-locking-tail-page-is-a-bug-fix
+++ a/include/linux/pagemap.h
@@ -339,6 +339,7 @@ static inline void __clear_page_locked(s
 
 static inline int trylock_page(struct page *page)
 {
+	VM_BUG_ON(PageTail(page));
 	return (likely(!test_and_set_bit_lock(PG_locked, &page->flags)));
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
mm-fix-potential-null-pointer-dereference.patch
thp-mm-locking-tail-page-is-a-bug.patch
thp-mm-locking-tail-page-is-a-bug-fix.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch

