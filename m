From: akpm@linux-foundation.org
Subject: + mm-alloc_large_system_hash-check-order.patch added to -mm tree
Date: Fri, 01 May 2009 15:44:09 -0700
Message-ID: <200905012244.n41Mi9L5016459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754476AbZEAWsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2009 18:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux.com, dada1@cosmosbay.com, davem@davemloft.net, mel@csn.ul.ie


The patch titled
     mm: alloc_large_system_hash check order
has been added to the -mm tree.  Its filename is
     mm-alloc_large_system_hash-check-order.patch

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
Subject: mm: alloc_large_system_hash check order
From: Hugh Dickins <hugh@veritas.com>

On an x86_64 with 4GB ram, tcp_init()'s call to alloc_large_system_hash(),
to allocate tcp_hashinfo.ehash, is now triggering an mmotm WARN_ON_ONCE on
order >= MAX_ORDER - it's hoping for order 11.  alloc_large_system_hash()
had better make its own check on the order.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Miller <davem@davemloft.net>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-alloc_large_system_hash-check-order mm/page_alloc.c
--- a/mm/page_alloc.c~mm-alloc_large_system_hash-check-order
+++ a/mm/page_alloc.c
@@ -4562,7 +4562,10 @@ void *__init alloc_large_system_hash(con
 			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
 		else {
 			unsigned long order = get_order(size);
-			table = (void*) __get_free_pages(GFP_ATOMIC, order);
+
+			if (order < MAX_ORDER)
+				table = (void *)__get_free_pages(GFP_ATOMIC,
+								order);
 			/*
 			 * If bucketsize is not a power-of-two, we may free
 			 * some pages at the end of hash table.
_

Patches currently in -mm which might be from hugh@veritas.com are

linux-next.patch
eliminate-thousands-of-warnings-with-gcc-32-build.patch
eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch
mm-disable-preemption-in-apply_to_pte_range.patch
integrity-nfsd-imbalance-bug-fix.patch
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
ksm-add-ksm-kernel-shared-memory-driver-borked-on-non-x86.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
getrusage-fill-ru_maxrss-value.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
prio_tree-debugging-patch.patch
use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic-v2.patch

