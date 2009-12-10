From: akpm@linux-foundation.org
Subject: + memcg-fix-memorymemswusage_in_bytes-for-root-cgroup.patch added to -mm tree
Date: Wed, 09 Dec 2009 16:21:19 -0800
Message-ID: <200912100021.nBA0LJgr029246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758909AbZLJAV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2009 19:21:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, stable@kernel.org


The patch titled
     memcg: fix memory.memsw.usage_in_bytes for root cgroup
has been added to the -mm tree.  Its filename is
     memcg-fix-memorymemswusage_in_bytes-for-root-cgroup.patch

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
Subject: memcg: fix memory.memsw.usage_in_bytes for root cgroup
From: "Kirill A. Shutemov" <kirill@shutemov.name>

We really want to take MEM_CGROUP_STAT_SWAPOUT into account.

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
@@ -2544,6 +2544,7 @@ static u64 mem_cgroup_read(struct cgroup
 			val += idx_val;
 			mem_cgroup_get_recursive_idx_stat(mem,
 				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
+			val += idx_val;
 			val <<= PAGE_SHIFT;
 		} else
 			val = res_counter_read_u64(&mem->memsw, name);
_

Patches currently in -mm which might be from kirill@shutemov.name are

memcg-fix-memorymemswusage_in_bytes-for-root-cgroup.patch

