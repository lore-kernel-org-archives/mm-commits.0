From: akpm@linux-foundation.org
Subject: [merged] memcg-extract-mem_group_usage-from-mem_cgroup_read.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:59:05 -0400
Message-ID: <201003150659.o2F6xcg5016563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935633Ab0COG76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, davidel@xmailserver.org, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, vbuz


The patch titled
     memcg: extract mem_group_usage() from mem_cgroup_read()
has been removed from the -mm tree.  Its filename was
     memcg-extract-mem_group_usage-from-mem_cgroup_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: extract mem_group_usage() from mem_cgroup_read()
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Helper to get memory or mem+swap usage of the cgroup.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dan Malek <dan@embeddedalley.com>
Cc: Vladislav Buzov <vbuzov@embeddedalley.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Alexander Shishkin <virtuoso@slind.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   54 +++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~memcg-extract-mem_group_usage-from-mem_cgroup_read mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-extract-mem_group_usage-from-mem_cgroup_read
+++ a/mm/memcontrol.c
@@ -2857,40 +2857,50 @@ mem_cgroup_get_recursive_idx_stat(struct
 	*val = d.val;
 }
 
+static inline u64 mem_cgroup_usage(struct mem_cgroup *mem, bool swap)
+{
+	u64 idx_val, val;
+
+	if (!mem_cgroup_is_root(mem)) {
+		if (!swap)
+			return res_counter_read_u64(&mem->res, RES_USAGE);
+		else
+			return res_counter_read_u64(&mem->memsw, RES_USAGE);
+	}
+
+	mem_cgroup_get_recursive_idx_stat(mem, MEM_CGROUP_STAT_CACHE, &idx_val);
+	val = idx_val;
+	mem_cgroup_get_recursive_idx_stat(mem, MEM_CGROUP_STAT_RSS, &idx_val);
+	val += idx_val;
+
+	if (swap) {
+		mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
+		val += idx_val;
+	}
+
+	return val << PAGE_SHIFT;
+}
+
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	u64 idx_val, val;
+	u64 val;
 	int type, name;
 
 	type = MEMFILE_TYPE(cft->private);
 	name = MEMFILE_ATTR(cft->private);
 	switch (type) {
 	case _MEM:
-		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
-			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_CACHE, &idx_val);
-			val = idx_val;
-			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_RSS, &idx_val);
-			val += idx_val;
-			val <<= PAGE_SHIFT;
-		} else
+		if (name == RES_USAGE)
+			val = mem_cgroup_usage(mem, false);
+		else
 			val = res_counter_read_u64(&mem->res, name);
 		break;
 	case _MEMSWAP:
-		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
-			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_CACHE, &idx_val);
-			val = idx_val;
-			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_RSS, &idx_val);
-			val += idx_val;
-			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
-			val += idx_val;
-			val <<= PAGE_SHIFT;
-		} else
+		if (name == RES_USAGE)
+			val = mem_cgroup_usage(mem, true);
+		else
 			val = res_counter_read_u64(&mem->memsw, name);
 		break;
 	default:
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

