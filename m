Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FCF254848
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 20:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131265; cv=none; b=pgE9TNjfXjvdZ22gZgmkRKkR6d/IGhogGfL9iKqMu51Nn3yKCv901q0SmLUOBYvKSwV+xqa67Ng62mxIbQt8qnT8oMBwzgrbbuEC+/DPp29+gklwgdGDe2wS1cYo0eosugAAzFbzs/sSfP3hftN9/sieN44wiW5P/TDIzGEw1Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131265; c=relaxed/simple;
	bh=brr6yCXxb5NRDD6ZHbxoLEVz5zROK2fg5tHukUAtGUQ=;
	h=Date:To:From:Subject:Message-Id; b=occyMIpID5T1RICIh/dd2V7fEd/y7/4Mcnzpo5TCUWhypLvG5LNDzoQ531UL0v+lME9G3H5G89VDfHhwKIYckKD8ArYCLOuudXFE2v66PNRCY/bpqqKq45EA87Sn4MxxSAxWIVqoZFaiI+42irmRpXO085yH1ddS/OVN30azv9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ijUnTz0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ijUnTz0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D35C4CEE3;
	Thu,  1 May 2025 20:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746131264;
	bh=brr6yCXxb5NRDD6ZHbxoLEVz5zROK2fg5tHukUAtGUQ=;
	h=Date:To:From:Subject:From;
	b=ijUnTz0ekBZSPANwbzJpcRnJRwAWHsmlU98Rp8Kk3Z4G0jvXQsFx3bQeGUUpl0hgp
	 NZAMe4pyEbIFnu7CqiYtGteXztamW4UIP4LlIwM8kDPuSo/af6fgKsPjW1xfyPoLnq
	 RRi3UUKg5eKIWe2tWXsNSmCj/9AHFpUhMPXSkGUs=
Date: Thu, 01 May 2025 13:27:43 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch added to mm-new branch
Message-Id: <20250501202744.15D35C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: add ksm_stat description in cgroup-v1/memory.rst
has been added to the -mm mm-new branch.  Its filename is
     documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: Documentation: add ksm_stat description in cgroup-v1/memory.rst
Date: Thu, 1 May 2025 04:17:13 +0000

This updates ksm_stat description in cgroup-v1/memory.rst.

Link: https://lkml.kernel.org/r/20250501041713.3324621-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Haonan Chen <chen.haonan2@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |   36 +++++++++++++++
 1 file changed, 36 insertions(+)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -97,6 +97,8 @@ Brief summary of control files.
                                      used.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
+ memory.ksm_stat                     show the statistic information about various ksm
+                                     counters
  memory.kmem.limit_in_bytes          Deprecated knob to set and read the kernel
                                      memory hard limit. Kernel hard limit is not
                                      supported since 5.16. Writing any value to
@@ -674,6 +676,40 @@ The output format of memory.numa_stat is
 
 The "total" count is sum of file + anon + unevictable.
 
+.. _memcg_ksm_stat:
+
+5.7 ksm_stat
+------------
+
+When CONFIG_KSM is enabled, the ksm_stat file can be used to observe the ksm
+merging status of the processes within an memory cgroup.
+
+The output format of memory.ksm_stat is::
+
+  ksm_rmap_items <number>
+  ksm_zero_pages <number>
+  ksm_merging_pages <number>
+  ksm_profit <number>
+
+The "ksm_rmap_items" count specifies the number of ksm_rmap_item structures in
+use. The structureksm_rmap_item stores the reverse mapping information for
+virtual addresses.  KSM will generate a ksm_rmap_item for each ksm-scanned page
+of the process.
+
+The "ksm_zero_pages" count specifies represent how many empty pages are merged
+with kernel zero pages by KSM, which is useful when /sys/kernel/mm/ksm/use_zero_pages
+is enabled.
+
+The "ksm_merging_pages" count specifies how many pages of this process are involved
+in KSM merging (not including ksm_zero_pages).
+
+The "ksm_process_profit" count specifies the profit that KSM brings (Saved bytes).
+KSM can save memory by merging identical pages, but also can consume additional
+memory, because it needs to generate a number of rmap_items to save each scanned
+page's brief rmap information. Some of these pages may be merged, but some may not
+be abled to be merged after being checked several times, which are unprofitable
+memory consumed.
+
 6. Hierarchy support
 ====================
 
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

memcontrol-rename-mem_cgroup_scan_tasks.patch
memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch
memcontrol-introduce-ksm_stat-at-memcg-v2.patch
memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_merging_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat.patch
memcontrol-v1-add-ksm_stat-at-memcg-v1.patch
documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch
documentation-add-ksm_stat-description-in-cgroup-v2rst.patch

