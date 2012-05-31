From: akpm@linux-foundation.org
Subject: [merged] memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:07 -0700
Message-ID: <20120531191707.5E37FA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:47005 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab2EaTRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:08 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so75419bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: mark stat field of mem_cgroup struct as __percpu
has been removed from the -mm tree.  Its filename was
     memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: memcg: mark stat field of mem_cgroup struct as __percpu

It fixes a lot of sparse warnings.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu
+++ a/mm/memcontrol.c
@@ -304,7 +304,7 @@ struct mem_cgroup {
 	/*
 	 * percpu counter.
 	 */
-	struct mem_cgroup_stat_cpu *stat;
+	struct mem_cgroup_stat_cpu __percpu *stat;
 	/*
 	 * used when a cpu is offlined or other synchronizations
 	 * See mem_cgroup_read_stat().
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

