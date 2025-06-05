Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D08204F93
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 20:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749155980; cv=none; b=eN3bnXsJn8HkG91vTaSdytVWehanHwbcfLh9ojhveeqCA/5dnXNiiYJYVk34n3L4Mouu8xLKZ6GL7cmz3snePyD6WDU8XLuTaNlhp//qt0wiAebGzA++kJMsfL1ZiQmOCRm16FNxtBsAF6BgsxCgQBuJ4+d7SY+fR8GJI0BmC+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749155980; c=relaxed/simple;
	bh=cJX1Q1SjVp5CyMd3TQMW6ORJEZfRdf41fneLoUuEe2A=;
	h=Date:To:From:Subject:Message-Id; b=N6VrMWkoRNCSm5rpQtNhkheWV66VjLMJmtWyGXapTAZfKxLADhEM4b6z3jeGeaAjgw9uP6ARiLTdii1ZP53cg41MvyhQKJmDOWLBZjRdo7wn57BQSGk7uEzrmceQvDIXiKhLEHQTcI8TBcZpSE4zfIPPi9RpOGIC04FX0ZXkCso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KLluevqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KLluevqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A80C4CEEB;
	Thu,  5 Jun 2025 20:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749155979;
	bh=cJX1Q1SjVp5CyMd3TQMW6ORJEZfRdf41fneLoUuEe2A=;
	h=Date:To:From:Subject:From;
	b=KLluevqEW225Opy3QAflfokq5mK8CYVMFq/6e2AZutwDuTZgpZw1IjJGg6ouxVsK2
	 drJhF/md2HvWHbzi1baRUO9Y3hWvr5IftObKMuJUO4ebeqAEmiKPkLNK/6XgdTyQnp
	 pGn/Hi/JdaWzAq5fZqqItIZV+CobcgmVLSJYx9PE=
Date: Thu, 05 Jun 2025 13:39:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch added to mm-new branch
Message-Id: <20250605203939.B9A80C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,memory_hotplug: remove status_change_nid_normal and update documentation
has been added to the -mm mm-new branch.  Its filename is
     mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,memory_hotplug: remove status_change_nid_normal and update documentation
Date: Thu, 5 Jun 2025 16:22:53 +0200

Now that the last user of status_change_nid_normal is gone, we can remove
it.  Update documentation accordingly.

Link: https://lkml.kernel.org/r/20250605142305.244465-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/memory-hotplug.rst                    |    3 --
 Documentation/translations/zh_CN/core-api/memory-hotplug.rst |    3 --
 include/linux/memory.h                                       |    1 
 mm/memory_hotplug.c                                          |   12 ----------
 4 files changed, 19 deletions(-)

--- a/Documentation/core-api/memory-hotplug.rst~mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation
+++ a/Documentation/core-api/memory-hotplug.rst
@@ -56,14 +56,11 @@ The third argument (arg) passes a pointe
 	struct memory_notify {
 		unsigned long start_pfn;
 		unsigned long nr_pages;
-		int status_change_nid_normal;
 		int status_change_nid;
 	}
 
 - start_pfn is start_pfn of online/offline memory.
 - nr_pages is # of pages of online/offline memory.
-- status_change_nid_normal is set node id when N_NORMAL_MEMORY of nodemask
-  is (will be) set/clear, if this is -1, then nodemask status is not changed.
 - status_change_nid is set node id when N_MEMORY of nodemask is (will be)
   set/clear. It means a new(memoryless) node gets new memory by online and a
   node loses all memory. If this is -1, then nodemask status is not changed.
--- a/Documentation/translations/zh_CN/core-api/memory-hotplug.rst~mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation
+++ a/Documentation/translations/zh_CN/core-api/memory-hotplug.rst
@@ -62,7 +62,6 @@ memory_notify结构体的指针::
 	struct memory_notify {
 		unsigned long start_pfn;
 		unsigned long nr_pages;
-		int status_change_nid_normal;
 		int status_change_nid;
 	}
 
@@ -70,8 +69,6 @@ memory_notify结构体的指针::
 
 - nr_pages是在线/离线内存的页数。
 
-- status_change_nid_normal是当nodemask的N_NORMAL_MEMORY被设置/清除时设置节
-  点id，如果是-1，则nodemask状态不改变。
 
 - status_change_nid是当nodemask的N_MEMORY被（将）设置/清除时设置的节点id。这
   意味着一个新的（没上线的）节点通过联机获得新的内存，而一个节点失去了所有的内
--- a/include/linux/memory.h~mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation
+++ a/include/linux/memory.h
@@ -109,7 +109,6 @@ struct memory_notify {
 	unsigned long altmap_nr_pages;
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-	int status_change_nid_normal;
 	int status_change_nid;
 };
 
--- a/mm/memory_hotplug.c~mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation
+++ a/mm/memory_hotplug.c
@@ -706,19 +706,13 @@ static void node_states_check_changes_on
 	int nid = zone_to_nid(zone);
 
 	arg->status_change_nid = NUMA_NO_NODE;
-	arg->status_change_nid_normal = NUMA_NO_NODE;
 
 	if (!node_state(nid, N_MEMORY))
 		arg->status_change_nid = nid;
-	if (zone_idx(zone) <= ZONE_NORMAL && !node_state(nid, N_NORMAL_MEMORY))
-		arg->status_change_nid_normal = nid;
 }
 
 static void node_states_set_node(int node, struct memory_notify *arg)
 {
-	if (arg->status_change_nid_normal >= 0)
-		node_set_state(node, N_NORMAL_MEMORY);
-
 	if (arg->status_change_nid >= 0)
 		node_set_state(node, N_MEMORY);
 }
@@ -1894,7 +1888,6 @@ static void node_states_check_changes_of
 	enum zone_type zt;
 
 	arg->status_change_nid = NUMA_NO_NODE;
-	arg->status_change_nid_normal = NUMA_NO_NODE;
 
 	/*
 	 * Check whether node_states[N_NORMAL_MEMORY] will be changed.
@@ -1906,8 +1899,6 @@ static void node_states_check_changes_of
 	 */
 	for (zt = 0; zt <= ZONE_NORMAL; zt++)
 		present_pages += pgdat->node_zones[zt].present_pages;
-	if (zone_idx(zone) <= ZONE_NORMAL && nr_pages >= present_pages)
-		arg->status_change_nid_normal = zone_to_nid(zone);
 
 	/*
 	 * We have accounted the pages from [0..ZONE_NORMAL); ZONE_HIGHMEM
@@ -1926,9 +1917,6 @@ static void node_states_check_changes_of
 
 static void node_states_clear_node(int node, struct memory_notify *arg)
 {
-	if (arg->status_change_nid_normal >= 0)
-		node_clear_state(node, N_NORMAL_MEMORY);
-
 	if (arg->status_change_nid >= 0)
 		node_clear_state(node, N_MEMORY);
 }
_

Patches currently in -mm which might be from osalvador@suse.de are

mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch
mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch
mmmemory_hotplug-implement-numa-node-notifier.patch
mmslub-use-node-notifier-instead-of-memory-notifier.patch
mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch
driverscxl-use-node-notifier-instead-of-memory-notifier.patch
drivershmat-use-node-notifier-instead-of-memory-notifier.patch
kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch
mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch
mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify.patch

