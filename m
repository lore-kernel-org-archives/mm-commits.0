From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-memorymemswusage_in_bytes-for-root-cgroup.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:26 -0800
Message-ID: <200912162037.nBGKbQE4013335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964835AbZLPUiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     memcg: fix memory.memsw.usage_in_bytes for root cgroup
has been removed from the -mm tree.  Its filename was
     memcg-fix-memorymemswusage_in_bytes-for-root-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix memory.memsw.usage_in_bytes for root cgroup
From: "Kirill A. Shutemov" <kirill@shutemov.name>

A memory cgroup has a memory.memsw.usage_in_bytes file.  It shows the sum
of the usage of pages and swapents in the cgroup.  Presently the root
cgroup's memsw.usage_in_bytes shows the wrong value - the number of
swapents are not added.

So take MEM_CGROUP_STAT_SWAPOUT into account.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~memcg-fix-memorymemswusage_in_bytes-for-root-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-memorymemswusage_in_bytes-for-root-cgroup
+++ a/mm/memcontrol.c
@@ -2542,6 +2542,7 @@ static u64 mem_cgroup_read(struct cgroup
 			val += idx_val;
 			mem_cgroup_get_recursive_idx_stat(mem,
 				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
+			val += idx_val;
 			val <<= PAGE_SHIFT;
 		} else
 			val = res_counter_read_u64(&mem->memsw, name);
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

