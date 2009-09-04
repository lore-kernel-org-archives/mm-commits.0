From: akpm@linux-foundation.org
Subject: + memcg-show-swap-usage-in-stat-file-fix.patch added to -mm tree
Date: Thu, 03 Sep 2009 17:23:24 -0700
Message-ID: <200909040023.n840NOdp019992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755393AbZIDAX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 20:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg-show-swap-usage-in-stat-file-fix
has been added to the -mm tree.  Its filename is
     memcg-show-swap-usage-in-stat-file-fix.patch

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
Subject: memcg-show-swap-usage-in-stat-file-fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

The usage of swap should be showed in bytes.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-show-swap-usage-in-stat-file-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-show-swap-usage-in-stat-file-fix
+++ a/mm/memcontrol.c
@@ -2712,7 +2712,7 @@ static int mem_cgroup_get_local_stat(str
 	s->stat[MCS_PGPGOUT] += val;
 	if (do_swap_account) {
 		val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_SWAPOUT);
-		s->stat[MCS_SWAP] += val;
+		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
 
 	/* per zone stat */
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-add_to_swap_cache-does-not-return-eexist-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch

