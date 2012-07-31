From: akpm@linux-foundation.org
Subject: [folded] memcg-add-mem_cgroup_from_css-helper-fix-2.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:35:39 -0700
Message-ID: <20120731233539.E96D2A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:54752 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab2GaXfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:35:41 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4820389obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:35:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwanp@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, shangw@linux.vnet.ibm.com, sjenning@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix mm/memcontrol.c build error against linux-next
has been removed from the -mm tree.  Its filename was
     memcg-add-mem_cgroup_from_css-helper-fix-2.patch

This patch was dropped because it was folded into memcg-add-mem_cgroup_from_css-helper.patch

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: memcg: fix mm/memcontrol.c build error against linux-next

As Fengguang Wu reported, linux-next failed to build with

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
head:   37e2ad4953983527f7bdb6831bf478eedcc84082
commit: 442d53f161093de78f0aafcd3ec2a6345de42890 [164/309] memcg: add mem_cgroup_from_css() helper

mem_cgroup_from_css() is defined inside CONFIG_MEMCG_KMEM and used
outside of it, move mem_cgroup_from_css() out of the #ifdef
CONFIG_MEMCG_KMEM can address this issue.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_from_css-helper-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_from_css-helper-fix-2
+++ a/mm/memcontrol.c
@@ -405,17 +405,17 @@ enum charge_type {
 static void mem_cgroup_get(struct mem_cgroup *memcg);
 static void mem_cgroup_put(struct mem_cgroup *memcg);
 
-/* Writing them here to avoid exposing memcg's inner layout */
-#ifdef CONFIG_MEMCG_KMEM
-#include <net/sock.h>
-#include <net/ip.h>
