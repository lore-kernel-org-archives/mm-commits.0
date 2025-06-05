Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDC427E7F9
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 20:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749155987; cv=none; b=aRNLqnr37eJgW1mMv+IEofxSVdWVZH1sPjw27pny5xPe8PAcDJyiQlV6b6JytYQ6IbVOqouJ81hJndZ6rLTWpyZ4v/wbxBdwkmIjOs/nLizDmch3iUbuurT40YO3A9QfGWjEJ8tsM9G/BidF94R9SDvbll4IY4lUi+npFBKKItQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749155987; c=relaxed/simple;
	bh=1dAvdFznvDWb4QlVFuZ7I3N0kdI/l0mQS5u5e5l8E1k=;
	h=Date:To:From:Subject:Message-Id; b=Bz3sJL2uiU9Ag1/3R4sydTdpVPKibcorHDIfCXGIA1yxVPzocBPTG+sxrYpF6J+nfhtYcZrQurILa3vITk81LqykEMDuinmUz/vBjCZ5wugvsKcXFKyenck//FHE4JLxEHynCe6T07Bfe0zE+7G0qkTFONU+IVJFmvdHRGPIRfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZGImEJsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZGImEJsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFC4C4CEEB;
	Thu,  5 Jun 2025 20:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749155987;
	bh=1dAvdFznvDWb4QlVFuZ7I3N0kdI/l0mQS5u5e5l8E1k=;
	h=Date:To:From:Subject:From;
	b=ZGImEJsrSnwT7LUROLysKbhUVOMzuUudGl9kMmj03xy5rwFtNfX2j5ucmc3TlrbSp
	 aYzUdiLe09PSyZe1WLGK1xmZ7asSDst5f24u/SZOMYqgcC8yORUbjs5micFXv+yPCI
	 rBw5841xaVHKQWUaoTPcHo0J52cjbS+vSah2BsSA=
Date: Thu, 05 Jun 2025 13:39:46 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivershmat-use-node-notifier-instead-of-memory-notifier.patch added to mm-new branch
Message-Id: <20250605203947.2CFC4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers,hmat: use node-notifier instead of memory-notifier
has been added to the -mm mm-new branch.  Its filename is
     drivershmat-use-node-notifier-instead-of-memory-notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivershmat-use-node-notifier-instead-of-memory-notifier.patch

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
Subject: drivers,hmat: use node-notifier instead of memory-notifier
Date: Thu, 5 Jun 2025 16:22:58 +0200

hmat driver is only concerned when a numa node changes its memory state,
specifically when a numa node with memory comes into play for the first
time, because it will register the memory_targets belonging to that numa
node.  So stop using the memory notifier and use the new numa node notifer
instead.

Link: https://lkml.kernel.org/r/20250605142305.244465-8-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/hmat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/acpi/numa/hmat.c~drivershmat-use-node-notifier-instead-of-memory-notifier
+++ a/drivers/acpi/numa/hmat.c
@@ -962,10 +962,10 @@ static int hmat_callback(struct notifier
 			 unsigned long action, void *arg)
 {
 	struct memory_target *target;
-	struct memory_notify *mnb = arg;
-	int pxm, nid = mnb->status_change_nid;
+	struct node_notify *nb = arg;
+	int pxm, nid = nb->nid;
 
-	if (nid == NUMA_NO_NODE || action != MEM_ONLINE)
+	if (nid == NUMA_NO_NODE || action != NODE_ADDED_FIRST_MEMORY)
 		return NOTIFY_OK;
 
 	pxm = node_to_pxm(nid);
@@ -1118,7 +1118,7 @@ static __init int hmat_init(void)
 	hmat_register_targets();
 
 	/* Keep the table and structures if the notifier may use them */
-	if (hotplug_memory_notifier(hmat_callback, HMAT_CALLBACK_PRI))
+	if (hotplug_node_notifier(hmat_callback, HMAT_CALLBACK_PRI))
 		goto out_put;
 
 	if (!hmat_set_default_dram_perf())
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

