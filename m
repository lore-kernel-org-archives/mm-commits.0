From: akpm@linux-foundation.org
Subject: [merged]
 memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:45:46 -0700
Message-ID: <55f08c6a.oqOcetdNjPvShg4S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbbIITpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: get rid of mem_cgroup_root_css for !CONFIG_MEMCG
has been removed from the -mm tree.  Its filename was
     memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: get rid of mem_cgroup_root_css for !CONFIG_MEMCG

The only user is cgwb_bdi_init and that one depends on
CONFIG_CGROUP_WRITEBACK which in turn depends on CONFIG_MEMCG so it
doesn't make much sense to definte an empty stub for !CONFIG_MEMCG. 
Moreover ERR_PTR(-EINVAL) is ugly and would lead to runtime crashes if
used in unguarded code paths.  Better fail during compilation.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg
+++ a/include/linux/memcontrol.h
@@ -498,8 +498,6 @@ void mem_cgroup_split_huge_fixup(struct
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
-#define mem_cgroup_root_css ((struct cgroup_subsys_state *)ERR_PTR(-EINVAL))
