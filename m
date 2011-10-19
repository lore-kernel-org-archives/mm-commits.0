From: akpm@linux-foundation.org
Subject: + mm-fix-race-between-mremap-and-removing-migration-entry.patch added to -mm tree
Date: Wed, 19 Oct 2011 13:22:42 -0700
Message-ID: <201110192022.p9JKMg3Y017780@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5928 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab1JSUW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2011 16:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, mgorman@suse.de, pluto@agmk.net, stable@vger.kernel.org


The patch titled
     Subject: mm: fix race between mremap and removing migration entry
has been added to the -mm tree.  Its filename is
     mm-fix-race-between-mremap-and-removing-migration-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix race between mremap and removing migration entry

I don't usually pay much attention to the stale "?  " addresses in stack
backtraces, but this lucky report from Pawel Sikora hints that mremap's
move_ptes() has inadequate locking against page migration.

 3.0 BUG_ON(!PageLocked(p)) in migration_entry_to_page():
 kernel BUG at include/linux/swapops.h:105!
 RIP: 0010:[<ffffffff81127b76>]  [<ffffffff81127b76>]
                       migration_entry_wait+0x156/0x160
  [<ffffffff811016a1>] handle_pte_fault+0xae1/0xaf0
  [<ffffffff810feee2>] ? __pte_alloc+0x42/0x120
  [<ffffffff8112c26b>] ? do_huge_pmd_anonymous_page+0xab/0x310
  [<ffffffff81102a31>] handle_mm_fault+0x181/0x310
  [<ffffffff81106097>] ? vma_adjust+0x537/0x570
  [<ffffffff81424bed>] do_page_fault+0x11d/0x4e0
  [<ffffffff81109a05>] ? do_mremap+0x2d5/0x570
  [<ffffffff81421d5f>] page_fault+0x1f/0x30

mremap's down_write of mmap_sem, together with i_mmap_mutex or lock, and
pagetable locks, were good enough before page migration (with its
requirement that every migration entry be found) came in, and enough while
migration always held mmap_sem; but not enough nowadays, when there's
memory hotremove and compaction.

The danger is that move_ptes() lets a migration entry dodge around behind
remove_migration_pte()'s back, so it's in the old location when looking at
the new, then in the new location when looking at the old.

Either mremap's move_ptes() must additionally take anon_vma lock(), or
migration's remove_migration_pte() must stop peeking for is_swap_entry()
before it takes pagetable lock.

Consensus chooses the latter: we prefer to add overhead to migration than
to mremapping, which gets used by JVMs and by exec stack setup.

Reported-by: Pawel Sikora <pluto@agmk.net>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/migrate.c~mm-fix-race-between-mremap-and-removing-migration-entry mm/migrate.c
--- a/mm/migrate.c~mm-fix-race-between-mremap-and-removing-migration-entry
+++ a/mm/migrate.c
@@ -120,10 +120,10 @@ static int remove_migration_pte(struct p
 
 		ptep = pte_offset_map(pmd, addr);
 
-		if (!is_swap_pte(*ptep)) {
-			pte_unmap(ptep);
-			goto out;
-		}
+		/*
+		 * Peek to check is_swap_pte() before taking ptlock?  No, we
+		 * can race mremap's move_ptes(), which skips anon_vma lock.
+		 */
 
 		ptl = pte_lockptr(mm, pmd);
 	}
_
Subject: Subject: mm: fix race between mremap and removing migration entry

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-fix-race-between-mremap-and-removing-migration-entry.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
linux-next.patch
drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch
radix_tree-clean-away-saw_unset_tag-leftovers.patch
tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious.patch
mm-distinguish-between-mlocked-and-pinned-pages.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch
ksm-fix-the-comment-of-try_to_unmap_one.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch
prio_tree-debugging-patch.patch

