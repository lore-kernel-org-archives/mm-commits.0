Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62BD82866
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 23:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738019347; cv=none; b=s2mOTJ4NE5zME3rRd4ODuuB7x6nBCN1ozSC1JQqWk8bevbWbzwICZIUsrgmsiHkXtB/7f+W4a8Ffc9TroWVdJtiybTtonOBzdeSbMAarBVpofkd0VITk0lJfg+na89QHUCiazRVNAP6IlO+5cj9iYX9MWbQXu107Dy/bjh3r6+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738019347; c=relaxed/simple;
	bh=5CcmhFmZgzvU8ty7X1ML+8MFWwCA/q7CXTjb15BrHjw=;
	h=Date:To:From:Subject:Message-Id; b=H96VpniPe32aIhdtU0WKZmODjMbodM/5pyxuoDP0Bvgz7JmBqgGCDUcflM8pfxuKEyn5cfyalgrd1VOsU5pkX4wQ1sqOIH+bG8hwCK4S7/q3UricbPAfiNS+mXx7KUqcJPQ8EWPRv6xpgiW79jDJdBb8DU9EAsB02U+Jacd9qfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tmM32SQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tmM32SQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18501C4CED2;
	Mon, 27 Jan 2025 23:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738019346;
	bh=5CcmhFmZgzvU8ty7X1ML+8MFWwCA/q7CXTjb15BrHjw=;
	h=Date:To:From:Subject:From;
	b=tmM32SQc0mzu7HYRkZ0AppYvu0zKfNSw0MSyRJYQOjzmIz4yTNpjQhW5jcOqg5Vw/
	 424a0Y8hBmavsyhYJkf7NUMttAEtMXQ+ALEhRt5d0A+89lac8FsOHoSzf6osrG5ug/
	 JeoZl3CIaXkrqwyr/kj7Ti21lYaJZPRAZCr6cf/k=
Date: Mon, 27 Jan 2025 15:09:05 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,wangweiyang2@huawei.com,vbabka@suse.cz,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-add-config_memcg_v1-for-local-functions.patch added to mm-unstable branch
Message-Id: <20250127230906.18501C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: add CONFIG_MEMCG_V1 for 'local' functions
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-add-config_memcg_v1-for-local-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-add-config_memcg_v1-for-local-functions.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chen Ridong <chenridong@huawei.com>
Subject: memcg: add CONFIG_MEMCG_V1 for 'local' functions
Date: Fri, 24 Jan 2025 07:35:14 +0000

Add CONFIG_MEMCG_V1 for the 'local' functions, which are only used in
memcg v1, so that they won't be built for v2.

Link: https://lkml.kernel.org/r/20250124073514.2375622-5-chenridong@huaweicloud.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Finkel <davidf@vimeo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |    6 +++---
 mm/memcontrol.c    |    6 ++++++
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~memcg-add-config_memcg_v1-for-local-functions
+++ a/mm/memcontrol.c
@@ -706,6 +706,7 @@ void __mod_memcg_state(struct mem_cgroup
 	trace_mod_memcg_state(memcg, idx, val);
 }
 
+#ifdef CONFIG_MEMCG_V1
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
 unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 {
@@ -722,6 +723,7 @@ unsigned long memcg_page_state_local(str
 #endif
 	return x;
 }
+#endif
 
 static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
 				     enum node_stat_item idx,
@@ -869,6 +871,7 @@ unsigned long memcg_events(struct mem_cg
 	return READ_ONCE(memcg->vmstats->events[i]);
 }
 
+#ifdef CONFIG_MEMCG_V1
 unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
 {
 	int i = memcg_events_index(event);
@@ -878,6 +881,7 @@ unsigned long memcg_events_local(struct
 
 	return READ_ONCE(memcg->vmstats->events_local[i]);
 }
+#endif
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
@@ -1447,11 +1451,13 @@ unsigned long memcg_page_state_output(st
 		memcg_page_state_output_unit(item);
 }
 
+#ifdef CONFIG_MEMCG_V1
 unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item)
 {
 	return memcg_page_state_local(memcg, item) *
 		memcg_page_state_output_unit(item);
 }
+#endif
 
 #ifdef CONFIG_HUGETLB_PAGE
 static bool memcg_accounts_hugetlb(void)
--- a/mm/memcontrol-v1.h~memcg-add-config_memcg_v1-for-local-functions
+++ a/mm/memcontrol-v1.h
@@ -60,15 +60,15 @@ unsigned long mem_cgroup_usage(struct me
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
-unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
-unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
+unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
+unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
 bool memcg1_alloc_events(struct mem_cgroup *memcg);
 void memcg1_free_events(struct mem_cgroup *memcg);
 
_

Patches currently in -mm which might be from chenridong@huawei.com are

memcg-use-ofp_peak_unset-instead-of-1.patch
memcg-call-the-free-function-when-allocation-of-pn-fails.patch
memcg-factor-out-the-replace_stock_objcg-function.patch
memcg-add-config_memcg_v1-for-local-functions.patch

