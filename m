From: akpm@linux-foundation.org
Subject: [merged] memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:49 -0700
Message-ID: <20130430184749.7D84531C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:55690 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3D3Sru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:50 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so84681yha.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not check for do_swap_account in mem_cgroup_{read,write,reset}
has been removed from the -mm tree.  Its filename was
     memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: do not check for do_swap_account in mem_cgroup_{read,write,reset}

Since 2d11085e ("memcg: do not create memsw files if swap accounting is
disabled") memsw files are created only if memcg swap accounting is
enabled so it doesn't make any sense to check for it explicitly in
mem_cgroup_read(), mem_cgroup_write() and mem_cgroup_reset().

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset
+++ a/mm/memcontrol.c
@@ -5025,9 +5025,6 @@ static ssize_t mem_cgroup_read(struct cg
 	type = MEMFILE_TYPE(cft->private);
 	name = MEMFILE_ATTR(cft->private);
 
-	if (!do_swap_account && type == _MEMSWAP)
-		return -EOPNOTSUPP;
-
 	switch (type) {
 	case _MEM:
 		if (name == RES_USAGE)
@@ -5162,9 +5159,6 @@ static int mem_cgroup_write(struct cgrou
 	type = MEMFILE_TYPE(cft->private);
 	name = MEMFILE_ATTR(cft->private);
 
-	if (!do_swap_account && type == _MEMSWAP)
-		return -EOPNOTSUPP;
-
 	switch (name) {
 	case RES_LIMIT:
 		if (mem_cgroup_is_root(memcg)) { /* Can't set limit on root */
@@ -5241,9 +5235,6 @@ static int mem_cgroup_reset(struct cgrou
 	type = MEMFILE_TYPE(event);
 	name = MEMFILE_ATTR(event);
 
-	if (!do_swap_account && type == _MEMSWAP)
-		return -EOPNOTSUPP;
