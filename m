From: akpm@linux-foundation.org
Subject: + memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch added to -mm tree
Date: Thu, 03 Feb 2011 15:31:09 -0800
Message-ID: <201102032331.p13NV99F031208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368Ab1BCXb0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 18:31:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: no uncharged pages reach page_cgroup_zoneinfo
has been added to the -mm tree.  Its filename is
     memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch

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
Subject: memcg: no uncharged pages reach page_cgroup_zoneinfo
From: Johannes Weiner <hannes@cmpxchg.org>

This patch series removes the direct page pointer from struct page_cgroup,
which saves 20% of per-page memcg memory overhead (Fedora and Ubuntu
enable memcg per default, openSUSE apparently too).

The node id or section number is encoded in the remaining free bits of
pc->flags which allows calculating the corresponding page without the
extra pointer.

I ran, what I think is, a worst-case microbenchmark that just cats a large
sparse file to /dev/null, because it means that walking the LRU list on
behalf of per-cgroup reclaim and looking up pages from page_cgroups is
happening constantly and at a high rate.  But it made no measurable
difference.  A profile reported a 0.11% share of the new
lookup_cgroup_page() function in this benchmark.


This patch:

All callsites check PCG_USED before passing pc->mem_cgroup, so the latter
is never NULL.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo
+++ a/mm/memcontrol.c
@@ -370,9 +370,6 @@ page_cgroup_zoneinfo(struct page_cgroup 
 	int nid = page_cgroup_nid(pc);
 	int zid = page_cgroup_zid(pc);
 
-	if (!mem)
-		return NULL;
-
 	return mem_cgroup_zoneinfo(mem, nid, zid);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

