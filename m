Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25DE22DFBE
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 23:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749512288; cv=none; b=kolIaVlFc+xL2lud8rikziElMLIE0ovfk+870RVuor9nIMu0osNtWTdopS+OFd+tZxcYGt3b0IF54igcyJOPIEfSM+12clKAx3ThwatPMfXx8obl3H8U+myNFjwRurrmceak6TOUBWkRTtuGROOK0CAmCWWwvqAwwszi3AwjAes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749512288; c=relaxed/simple;
	bh=KIN5izvLJ/RsbtDRaLznBfPLTuGANCpF7anF9J+CHiI=;
	h=Date:To:From:Subject:Message-Id; b=QR4NXsqlFdN9c2FKRUt+z8vz7YA5BD6llNHiogxXyn2QOdC6FtziIOcGROhml4vTGoedfD8IOI0T2ZFaocFWH2w+jTRc/XmNzWLedJH30fnPpCu6mI50v5n4Nkd5jS5UgXfEKhBfCt4XgrgnbBdWoD7yAuE1asKFkX1LvKZJFfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IN+GmPp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IN+GmPp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDC2C4CEEB;
	Mon,  9 Jun 2025 23:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749512288;
	bh=KIN5izvLJ/RsbtDRaLznBfPLTuGANCpF7anF9J+CHiI=;
	h=Date:To:From:Subject:From;
	b=IN+GmPp3F+stPSFIyGu2iFgIryg3vyg0K+VrobcsoWU49J4sW4VMElu+qVRwvPDGl
	 DBMiNOizOpsSvNhfZ0Gi8ajwla7jGvVacR4/59tIE12kVLWRkZvJZQgj/oZIUWp4a4
	 ybWMWSwQ4SJFBt5G5iR4CkceOJLE3jlTwx2Y9vfw=
Date: Mon, 09 Jun 2025 16:38:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivershmat-use-node-notifier-instead-of-memory-notifier.patch added to mm-new branch
Message-Id: <20250609233808.4CDC2C4CEEB@smtp.kernel.org>
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
Date: Mon, 9 Jun 2025 11:21:44 +0200

hmat driver is only concerned when a numa node changes its memory state,
specifically when a numa node with memory comes into play for the first
time, because it will register the memory_targets belonging to that numa
node.  So stop using the memory notifier and use the new numa node notifer
instead.

Link: https://lkml.kernel.org/r/20250609092149.312114-8-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
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
+	struct node_notify *nn = arg;
+	int pxm, nid = nn->nid;
 
-	if (nid == NUMA_NO_NODE || action != MEM_ONLINE)
+	if (action != NODE_ADDED_FIRST_MEMORY)
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
mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch

