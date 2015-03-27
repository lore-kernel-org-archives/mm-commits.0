From: akpm@linux-foundation.org
Subject: +
 thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch added to -mm tree
Date: Fri, 27 Mar 2015 14:47:27 -0700
Message-ID: <5515cfef.w08Mg+czh8MvU93w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbC0Vr2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 17:47:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: do not adjust zone water marks if khugepaged is not started
has been added to the -mm tree.  Its filename is
     thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch

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
Subject: thp: do not adjust zone water marks if khugepaged is not started

set_recommended_min_free_kbytes() adjusts zone water marks to be suitable
for khugepaged. We avoid doing this if khugepaged is disabled, but don't
catch the case when khugepaged is failed to start.

Let's address this by checking khugepaged_thread instead of
khugepaged_enabled() in set_recommended_min_free_kbytes().
It's NULL if the kernel thread is stopped or failed to start.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started mm/huge_memory.c
--- a/mm/huge_memory.c~thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started
+++ a/mm/huge_memory.c
@@ -110,7 +110,8 @@ static int set_recommended_min_free_kbyt
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!khugepaged_enabled())
+	/* khugepaged thread has stopped to failed to start */
+	if (!khugepaged_thread)
 		return 0;
 
 	for_each_populated_zone(zone)
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
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
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
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
linux-next.patch

