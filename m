Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E9A1D54FA
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450005; cv=none; b=ZKOUW6qygZA5xmrFz0vXfaD2l8j5Fz2SnluqJVxPD/iQ62emyl0g/P07ipl4BqE5DVwochM8Q/3plfJAXkfKQJUOBY6d9OOOCL4K4db51VxH7s4bQtl1PTl0qkg65p8BybZZkGVW7y3js+MI3pUZefplTll++7+wm9WMxeYyAMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450005; c=relaxed/simple;
	bh=3J0ElSxRN9MA+A7UhBa3QE6/Z9ERuCjH7abK3Faelzk=;
	h=Date:To:From:Subject:Message-Id; b=p+MV+bGQCrPciktzt7BuJi4arZRM/VBiRYcpJgvSYDoSrJNMDJE5qO9pOybC09AfycaKp6H3kt/x7h6ls3QM0//E8FnCe72fJb76MLrYAhr1v8cJiKkWgaU7tJNVE0FrCb1lTE80DQnF6Re1nORoZG44AAq4T+LKWIHPAvfDSx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HKBmjdb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HKBmjdb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8678C4CEE3;
	Sun, 13 Jul 2025 23:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450004;
	bh=3J0ElSxRN9MA+A7UhBa3QE6/Z9ERuCjH7abK3Faelzk=;
	h=Date:To:From:Subject:From;
	b=HKBmjdb1Z2vRun11JqUESUz9q/k+SHch8MjjHZSwMrg1Gv+861m/W3Ds233B33iAW
	 QOuPEUkFIWcfqCfbLTI67VZdmh+HY7iAFbe/4YuKcT5y+gKrkcFhrsH3eyzyo6TxwS
	 neKaCSpsvwPKyYTSrCsuPWyV5UwuAYK8L6soK50g=
Date: Sun, 13 Jul 2025 16:40:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch removed from -mm tree
Message-Id: <20250713234004.D8678C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel,cpuset: use node-notifier instead of memory-notifier
has been removed from the -mm tree.  Its filename was
     kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: kernel,cpuset: use node-notifier instead of memory-notifier
Date: Mon, 16 Jun 2025 15:51:51 +0200

cpuset is only concerned when a numa node changes its memory state, as it
needs to know the current numa nodes with memory to keep an updated
mems_allowed mask.  So stop using the memory notifier and use the new numa
node notifer instead.

Link: https://lkml.kernel.org/r/20250616135158.450136-9-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c~kernelcpuset-use-node-notifier-instead-of-memory-notifier
+++ a/kernel/cgroup/cpuset.c
@@ -4051,7 +4051,7 @@ void __init cpuset_init_smp(void)
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
 	top_cpuset.effective_mems = node_states[N_MEMORY];
 
-	hotplug_memory_notifier(cpuset_track_online_nodes, CPUSET_CALLBACK_PRI);
+	hotplug_node_notifier(cpuset_track_online_nodes, CPUSET_CALLBACK_PRI);
 
 	cpuset_migrate_mm_wq = alloc_ordered_workqueue("cpuset_migrate_mm", 0);
 	BUG_ON(!cpuset_migrate_mm_wq);
_

Patches currently in -mm which might be from osalvador@suse.de are


