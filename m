From: akpm@linux-foundation.org
Subject: + mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
 added to -mm tree
Date: Wed, 25 Mar 2015 15:47:25 -0700
Message-ID: <55133afd.QJmu3PJgx1ONu2fk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbbCYWr0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 18:47:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid tail page refcounting on non-THP compound pages
has been added to the -mm tree.  Its filename is
     mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch

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
Subject: mm: avoid tail page refcounting on non-THP compound pages

THP uses tail page refcounting to be able to split huge pages at any time.
 Tail page refcounting is not needed for other users of compound pages and
it's harmful because of overhead.

We try to exclude non-THP pages from tail page refcounting using
__compound_tail_refcounted() check.  It excludes most common non-THP
compound pages: SL*B and hugetlb, but it doesn't catch rest of __GFP_COMP
users -- drivers.

And it's not only about overhead.

Drivers might want to use compound pages to get refcounting semantics
suitable for mapping high-order pages to userspace.  But tail page
refcounting breaks it.

Tail page refcounting uses ->_mapcount in tail pages to store GUP pins on
them.  It means GUP pins would affect page_mapcount() for tail pages. 
It's not a problem for THP, because it never maps tail pages.  But unlike
THP, drivers map parts of compound pages with PTEs and it makes
page_mapcount() be called for tail pages.

In particular, GUP pins would shift PSS up and affect /proc/kpagecount for
such pages.  But, I'm not aware about anything which can lead to crash or
other serious misbehaviour.

Since currently all THP pages are anonymous and all drivers pages are not,
we can fix the __compound_tail_refcounted() check by requiring PageAnon()
to enable tail page refcounting.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-avoid-tail-page-refcounting-on-non-thp-compound-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-avoid-tail-page-refcounting-on-non-thp-compound-pages
+++ a/include/linux/mm.h
@@ -456,7 +456,7 @@ static inline int page_count(struct page
 
 static inline bool __compound_tail_refcounted(struct page *page)
 {
-	return !PageSlab(page) && !PageHeadHuge(page);
+	return PageAnon(page) && !PageSlab(page) && !PageHeadHuge(page);
 }
 
 /*
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
alpha-expose-number-of-page-table-levels-on-kconfig-level.patch
arm64-expose-number-of-page-table-levels-on-kconfig-level.patch
arm-expose-number-of-page-table-levels-on-kconfig-level.patch
ia64-expose-number-of-page-table-levels-on-kconfig-level.patch
m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
mips-expose-number-of-page-table-levels-on-kconfig-level.patch
parisc-expose-number-of-page-table-levels-on-kconfig-level.patch
powerpc-expose-number-of-page-table-levels-on-kconfig-level.patch
s390-expose-number-of-page-table-levels.patch
sh-expose-number-of-page-table-levels.patch
sparc-expose-number-of-page-table-levels.patch
tile-expose-number-of-page-table-levels.patch
um-expose-number-of-page-table-levels.patch
x86-expose-number-of-page-table-levels-on-kconfig-level.patch
mm-define-default-pgtable_levels-to-two.patch
mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
linux-next.patch

