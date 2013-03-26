From: akpm@linux-foundation.org
Subject: + sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix.patch added to -mm tree
Date: Tue, 26 Mar 2013 12:23:52 -0700
Message-ID: <20130326192352.6A5005A409A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:56789 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3CZTXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 15:23:53 -0400
Received: by mail-ve0-f201.google.com with SMTP id ox1so75604veb.2
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 12:23:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, fengguang.wu@intel.com


The patch titled
     Subject: sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix
has been added to the -mm tree.  Its filename is
     sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/vmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/mm/vmem.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix
+++ a/arch/s390/mm/vmem.c
@@ -259,7 +259,7 @@ int __meminit vmemmap_populate(unsigned
 		}
 		address += PAGE_SIZE;
 	}
-	memset(start, 0, nr * sizeof(struct page));
+	memset((void *)start, 0, end - start);
 	ret = 0;
 out:
 	flush_tlb_kernel_range(start, end);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch
memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch
memcg-relax-memcg-iter-caching.patch
memcg-simplify-mem_cgroup_iter.patch
memcg-further-simplify-mem_cgroup_iter.patch
cgroup-remove-css_get_next.patch
memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch
mm-try-harder-to-allocate-vmemmap-blocks.patch
sparse-vmemmap-specify-vmemmap-population-range-in-bytes.patch
sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix.patch
x86-64-remove-dead-debugging-code-for-pse-setups.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix.patch
x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
ipc-refactor-msg-list-search-into-separate-function-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

