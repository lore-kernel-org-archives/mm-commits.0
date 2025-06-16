Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E22136349
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750117782; cv=none; b=N19c3D/EFBrW6SngTBRm1DhQXQiaTJ8s8x7EdSG5szkK1Yde02V6TMnHH5vqlqbWpkY4GtvRuxeixrQDIiIFjVlxKUFj66Ch2+waRDOjT6Fa1Jbg4hBa8H1TZkhksGb/iT15RSO2pdr8tw7J9seiDFjtbP0esp8n3DxBJpe52N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750117782; c=relaxed/simple;
	bh=5WZjNVD68ChujsqVZrhEnOhalYaJlCTdtrNkAaOWKhM=;
	h=Date:To:From:Subject:Message-Id; b=RR7BBngbQjpFN8qcbZXbetsoEJidu6hetpe2j+mZyIPDgdqB7C1AFzr6aYOJ/JE0FcyvapfROqzwQg9kX1pNvXe4ZHQnkCeSuqYtXvhI9NXown8LCt88qjHxyQBuTfZycX1GjkVQJdZFCdHVND2zgHn+ucD70tC8rtdYlkWBxXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=brtjxi10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="brtjxi10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C13C4CEEA;
	Mon, 16 Jun 2025 23:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750117781;
	bh=5WZjNVD68ChujsqVZrhEnOhalYaJlCTdtrNkAaOWKhM=;
	h=Date:To:From:Subject:From;
	b=brtjxi10fvQ8Si/sH8KeXlXxF9pRvmIEisM21wbfxl3x5ReQvfn2L7HPNFIXxK3nX
	 NgGMwo5F3v8vaNHRSpwEUVg7ylP21zMynJaAJSk2ZC+8wtskIfGcCX/WG/7n/R4idn
	 gipxC8FcFo0m439JkODL8z5vMLHOMgr4xVt5S15I=
Date: Mon, 16 Jun 2025 16:49:41 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch added to mm-unstable branch
Message-Id: <20250616234941.D9C13C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel,cpuset: use node-notifier instead of memory-notifier
has been added to the -mm mm-unstable branch.  Its filename is
     kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch

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

mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch
mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch
mmmemory_hotplug-implement-numa-node-notifier.patch
mmslub-use-node-notifier-instead-of-memory-notifier.patch
mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch
driverscxl-use-node-notifier-instead-of-memory-notifier.patch
drivershmat-use-node-notifier-instead-of-memory-notifier.patch
kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch
mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch
mmpage_ext-derive-the-node-from-the-pfn.patch
mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch

