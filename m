From: akpm@linux-foundation.org
Subject: + mm-fix-negative-nr_isolated-counts.patch added to -mm tree
Date: Wed, 11 Feb 2015 13:10:21 -0800
Message-ID: <54dbc53d.kdjitPD4cmp98phA%akpm__39205.7808967822$1423689093$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbbBKVKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 16:10:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, iamjoonsoo.kim@lge.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix negative nr_isolated counts
has been added to the -mm tree.  Its filename is
     mm-fix-negative-nr_isolated-counts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-negative-nr_isolated-counts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-negative-nr_isolated-counts.patch

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
Subject: mm: fix negative nr_isolated counts

The vmstat interfaces are good at hiding negative counts (at least when
CONFIG_SMP); but if you peer behind the curtain, you find that
nr_isolated_anon and nr_isolated_file soon go negative, and grow ever more
negative: so they can absorb larger and larger numbers of isolated pages,
yet still appear to be zero.

I'm happy to avoid a congestion_wait() when too_many_isolated() myself;
but I guess it's there for a good reason, in which case we ought to get
too_many_isolated() working again.

The imbalance comes from isolate_migratepages()'s ISOLATE_ABORT case:
putback_movable_pages() decrements the NR_ISOLATED counts, but we forgot
to call acct_isolated() to increment them.

Fixes: edc2ca612496 ("mm, compaction: move pageblock checks up from isolate_migratepages_range()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>	[3.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-fix-negative-nr_isolated-counts mm/compaction.c
--- a/mm/compaction.c~mm-fix-negative-nr_isolated-counts
+++ a/mm/compaction.c
@@ -1103,8 +1103,10 @@ static isolate_migrate_t isolate_migrate
 		low_pfn = isolate_migratepages_block(cc, low_pfn, end_pfn,
 								isolate_mode);
 
-		if (!low_pfn || cc->contended)
+		if (!low_pfn || cc->contended) {
+			acct_isolated(zone, cc);
 			return ISOLATE_ABORT;
+		}
 
 		/*
 		 * Either we isolated something and proceed with migration. Or
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
arm-define-__pagetable_pmd_folded-for-lpae.patch
mm-account-pmd-page-tables-to-the-process.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch
mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
mm-fix-negative-nr_isolated-counts.patch

