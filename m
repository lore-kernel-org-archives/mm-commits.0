From: akpm@linux-foundation.org
Subject: [folded] memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:47:23 -0700
Message-ID: <200906172247.n5HMlN8X007584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756336AbZFQWs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:48:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.cn, menage@google.com


The patch titled
     memcg: fix mem_cgroup_update_mapped_file_stat oops
has been removed from the -mm tree.  Its filename was
     memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

This patch was dropped because it was folded into memcg-add-file-based-rss-accounting.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix mem_cgroup_update_mapped_file_stat oops
From: Hugh Dickins <hugh@veritas.com>

CONFIG_SPARSEMEM=y CONFIG_CGROUP_MEM_RES_CTLR=y cgroup_disable=memory
bootup is oopsing in mem_cgroup_update_mapped_file_stat().  !SPARSEMEM is
fine because its lookup_page_cgroup() contains an explicit check for NULL
node_page_cgroup, but the SPARSEMEM version was missing a check for NULL
section->page_cgroup.

Should go in as a fix to memcg-add-file-based-rss-accounting.patch but
it's curious that's the first thing to suffer from this divergence.

Perhaps this is the wrong fix, and there should be an explicit
mem_cgroup_disable() check somewhere else; but it would then seem
dangerous that SPARSEMEM and !SPARSEMEM diverge in this way, and there are
lots of lookup_page_cgroup NULL tests around.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.cn>
Cc: Paul Menage <menage@google.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_cgroup.c~memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops
+++ a/mm/page_cgroup.c
@@ -99,6 +99,8 @@ struct page_cgroup *lookup_page_cgroup(s
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
 
+	if (!section->page_cgroup)
+		return NULL;
 	return section->page_cgroup + pfn;
 }
 
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch

