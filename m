Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10288204F93
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 20:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749155989; cv=none; b=RByInh0NFb8WR//boG3dazvSnEvHhvcZgEKO4TILvBO7BzBUmPkTy8EqmcHPFj3XlfdhRl0Jhrw5Gp/gRwzqo22K0B1x06OJXn/2ROySWYoN7edxL/JZpb7WrH9MmM6PiIy4GhBXt9IO3ZYv8bKA2QRwdcA+uHsQXSj/sNWwdaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749155989; c=relaxed/simple;
	bh=Vmm0joe/FQR5wJesbxj5TwaqAFyjGufZVZXSP/PPeoM=;
	h=Date:To:From:Subject:Message-Id; b=CvSVlVI3m17uMzo13zlzLYR9K16CleGpSNV5jLbFajmuz4zkgCC9GEW4uoAUDp4rcGnI+g/+TeYQhTvJz2k489kAmnuXHr6a/2BVBmsnYJHhIPE1fK15Qggk8q+6WNQyLiZz5Jr6HmGSShSxvdSHC1GPM6YY2SS4BkUJyu5YAsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=de3VWIf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="de3VWIf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774EBC4CEEB;
	Thu,  5 Jun 2025 20:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749155988;
	bh=Vmm0joe/FQR5wJesbxj5TwaqAFyjGufZVZXSP/PPeoM=;
	h=Date:To:From:Subject:From;
	b=de3VWIf/kPtFM6pTkMmWDT/GZOOW/0leCXu8tVEz4Z6b4pdx0umBfFFZJVwKLCIBe
	 PPjntM4DHn9k/vaX1PK2+ic6YNSXp+qXhgHIVnTRWK1UhsDGTImIlmix9p5PbdlMZu
	 fUZis0e4zzBHQ1gygPtFurYQKF2BcYU6G44OF0Cg=
Date: Thu, 05 Jun 2025 13:39:47 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch added to mm-new branch
Message-Id: <20250605203948.774EBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel,cpuset: use node-notifier instead of memory-notifier
has been added to the -mm mm-new branch.  Its filename is
     kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch

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
Subject: kernel,cpuset: use node-notifier instead of memory-notifier
Date: Thu, 5 Jun 2025 16:22:59 +0200

cpuset is only concerned when a numa node changes its memory state, as it
needs to know the current numa nodes with memory to keep an updated
mems_allowed mask.  So stop using the memory notifier and use the new numa
node notifer instead.

Link: https://lkml.kernel.org/r/20250605142305.244465-9-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
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

