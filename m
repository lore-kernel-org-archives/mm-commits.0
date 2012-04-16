From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-broken-boolen-expression.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:20 -0700
Message-ID: <20120416201520.6D428A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58458 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2DPUPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:22 -0400
Received: by qcsp5 with SMTP id p5so646133qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 13:15:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix broken boolen expression
has been removed from the -mm tree.  Its filename was
     memcg-fix-broken-boolen-expression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: memcg: fix broken boolen expression

action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-broken-boolen-expression mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-broken-boolen-expression
+++ a/mm/memcontrol.c
@@ -2165,7 +2165,7 @@ static int __cpuinit memcg_cpu_hotplug_c
 	if (action == CPU_ONLINE)
 		return NOTIFY_OK;
 
-	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
 	for_each_mem_cgroup(iter)
_

Patches currently in -mm which might be from kirill@shutemov.name are

memcg-mark-more-functions-variables-as-static.patch
memcg-remove-unused-variable.patch
memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu.patch
memcg-remove-redundant-parentheses.patch
memcg-make-threshold-index-in-the-right-position.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch

