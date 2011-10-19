From: akpm@linux-foundation.org
Subject: + mm-munlock-use-mapcount-to-avoid-terrible-overhead.patch added to -mm tree
Date: Tue, 18 Oct 2011 17:14:35 -0700
Message-ID: <201110190014.p9J0Eamb021276@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:4140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1JSAOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 20:14:42 -0400
Received: from hpaq7.eem.corp.google.com (hpaq7.eem.corp.google.com [172.25.149.7])
	by smtp-out.google.com with ESMTP id p9J0Ecg0026994
	for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2011 17:14:38 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, walken@google.com


The patch titled
     Subject: mm: munlock use mapcount to avoid terrible overhead
has been added to the -mm tree.  Its filename is
     mm-munlock-use-mapcount-to-avoid-terrible-overhead.patch

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
Subject: mm: munlock use mapcount to avoid terrible overhead

A process spent 30 minutes exiting, just munlocking the pages of a large
anonymous area that had been alternately mprotected into page-sized vmas:
for every single page there's an anon_vma walk through all the other
little vmas to find the right one.

A general fix to that would be a lot more complicated (use prio_tree on
anon_vma?), but there's one very simple thing we can do to speed up the
common case: if a page to be munlocked is mapped only once, then it is our
vma that it is mapped into, and there's no need whatever to walk through
all the others.

Okay, there is a very remote race in munlock_vma_pages_range(), if between
its follow_page() and lock_page(), another process were to munlock the
same page, then page reclaim remove it from our vma, then another process
mlock it again.  We would find it with page_mapcount 1, yet it's still
mlocked in another process.  But never mind, that's much less likely than
the down_read_trylock() failure which munlocking already tolerates (in
try_to_unmap_one()): in due course page reclaim will discover and move the
page to unevictable instead.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-munlock-use-mapcount-to-avoid-terrible-overhead mm/mlock.c
--- a/mm/mlock.c~mm-munlock-use-mapcount-to-avoid-terrible-overhead
+++ a/mm/mlock.c
@@ -110,7 +110,10 @@ void munlock_vma_page(struct page *page)
 	if (TestClearPageMlocked(page)) {
 		dec_zone_page_state(page, NR_MLOCK);
 		if (!isolate_lru_page(page)) {
-			int ret = try_to_munlock(page);
+			int ret = SWAP_AGAIN;
+
+			if (page_mapcount(page) > 1)
+				ret = try_to_munlock(page);
 			/*
 			 * did try_to_unlock() succeed or punt?
 			 */
_
Subject: Subject: mm: munlock use mapcount to avoid terrible overhead

Patches currently in -mm which might be from hughd@google.com are

origin.patch
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

