From: akpm@linux-foundation.org
Subject: +
 mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom.patch added to
 -mm tree
Date: Tue, 29 Apr 2014 15:39:46 -0700
Message-ID: <53602a32.e/Cezw1qeDGjUW1T%akpm__23554.3140247048$1398811205$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbaD2Wjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Apr 2014 18:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, sandeen@redhat.com, mpatlasov@parallels.com, mhocko@suse.cz, jweiner@redhat.com, fengguang.wu@intel.com, Kosaki.motohiro@jp.fujitsu.com, riel@redhat.com

Subject: + mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom.patch added to -mm tree
To: riel@redhat.com,Kosaki.motohiro@jp.fujitsu.com,fengguang.wu@intel.com,jweiner@redhat.com,mhocko@suse.cz,mpatlasov@parallels.com,sandeen@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 29 Apr 2014 15:39:46 -0700


The patch titled
     Subject: mm/page-writeback.c: fix divide by zero in pos_ratio_polynom()
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm/page-writeback.c: fix divide by zero in pos_ratio_polynom()

It is possible for "limit - setpoint + 1" to equal zero, leading to a
divide by zero error.  Blindly adding 1 to "limit - setpoint" is not
working, so we need to actually test the divisor before calling div64.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: KOSAKI Motohiro <Kosaki.motohiro@jp.fujitsu.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Maxim Patlasov <mpatlasov@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom
+++ a/mm/page-writeback.c
@@ -597,11 +597,16 @@ static inline long long pos_ratio_polyno
 					  unsigned long dirty,
 					  unsigned long limit)
 {
+	unsigned int divisor;
 	long long pos_ratio;
 	long x;
 
+	divisor = limit - setpoint;
+	if (!divisor)
+		divisor = 1;
+
 	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
-		    limit - setpoint + 1);
+		    divisor);
 	pos_ratio = x;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
_

Patches currently in -mm which might be from riel@redhat.com are

mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom.patch
mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix.patch
mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

