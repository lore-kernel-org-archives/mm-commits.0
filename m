From: akpm@linux-foundation.org
Subject: + x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix.patch added to -mm tree
Date: Mon, 25 Mar 2013 13:03:19 -0700
Message-ID: <20130325200319.6EA8A31C253@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62437 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab3CYUDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 16:03:20 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so655462vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 13:03:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, fengguang.wu@intel.com


The patch titled
     Subject: x86-64: use vmemmap_populate_basepages() for !pse setups fix
has been added to the -mm tree.  Its filename is
     x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix.patch

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
Subject: x86-64: use vmemmap_populate_basepages() for !pse setups fix

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/init_64.c~x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix
+++ a/arch/x86/mm/init_64.c
@@ -1285,11 +1285,14 @@ static int __meminit vmemmap_populate_hu
 						unsigned long end, int node)
 {
 	unsigned long addr;
+	unsigned long next;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 
-	for (addr = start; addr < end; addr += PMD_SIZE) {
+	for (addr = start; addr < end; addr = next) {
+		next = pmd_addr_end(addr, end);
+
 		pgd = vmemmap_pgd_populate(addr, node);
 		if (!pgd)
 			return -ENOMEM;
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
x86-64-remove-dead-debugging-code-for-pse-setups.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix.patch
x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
ipc-refactor-msg-list-search-into-separate-function-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

