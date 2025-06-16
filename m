Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CD6136349
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750117777; cv=none; b=EnOFzl7y6rq9U22PlgadHc4nfEv3GSZfISKaBhAsFKbH4Jlyqv7zWCtkd7HhVEzAHK+MPR6DWqlhzMpMOGoVu0f4sOZwuMx6zVXbjL49c/dkLSQe1tRHYumtpk4M3MRo8DNm1A2dBWxru+bW+B4eELTCyjGp/zDGV0Tv01gp248=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750117777; c=relaxed/simple;
	bh=e6J0twxD/OIeeCzgKHxoSWpWZDWPY9KYRvvptad1aFY=;
	h=Date:To:From:Subject:Message-Id; b=IYRdA9WX7AgU7AJ6A3WtAQtRd+OG0VGJJpmOmHAojBBExUGsG//A2s+ikvl7dnmBWeWxtqDDRq6hx2dO7cg0ljWxa6DEJKjFgflOkRdbQzjcjuM2Sb8YUcmqVi9x8hGgp9UDyOKJNViUDoFZzy4V3xDiT93YrSO3SxcemayvK6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hkl1UaA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hkl1UaA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEDCC4CEED;
	Mon, 16 Jun 2025 23:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750117777;
	bh=e6J0twxD/OIeeCzgKHxoSWpWZDWPY9KYRvvptad1aFY=;
	h=Date:To:From:Subject:From;
	b=hkl1UaA6MimBBZgcotCBrYY1m3sWM/AFcntzMs/XYzVitLTCq2KGXepeGgYcicT/f
	 S4lLEgwKE2Q2HpjJNz663a7Ffxe0Wz+bSMtatbHiyIq54xKc3ULgMpiPMUgkOU/ups
	 gQ5rOan21Td19WGBv1lZC2ZxAfP6/j9RohNXhyhY=
Date: Mon, 16 Jun 2025 16:49:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + driverscxl-use-node-notifier-instead-of-memory-notifier.patch added to mm-unstable branch
Message-Id: <20250616234937.9AEDCC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers,cxl: use node-notifier instead of memory-notifier
has been added to the -mm mm-unstable branch.  Its filename is
     driverscxl-use-node-notifier-instead-of-memory-notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/driverscxl-use-node-notifier-instead-of-memory-notifier.patch

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
Subject: drivers,cxl: use node-notifier instead of memory-notifier
Date: Mon, 16 Jun 2025 15:51:49 +0200

memory-tier is only concerned when a numa node changes its memory state,
specifically when a numa node with memory comes into play for the first
time, because it needs to get its performance attributes to build a proper
demotion chain.  So stop using the memory notifier and use the new numa
node notifer instead.

Link: https://lkml.kernel.org/r/20250616135158.450136-7-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cxl/core/region.c |   16 ++++++++--------
 drivers/cxl/cxl.h         |    4 ++--
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/cxl/core/region.c~driverscxl-use-node-notifier-instead-of-memory-notifier
+++ a/drivers/cxl/core/region.c
@@ -2451,12 +2451,12 @@ static int cxl_region_perf_attrs_callbac
 					  unsigned long action, void *arg)
 {
 	struct cxl_region *cxlr = container_of(nb, struct cxl_region,
-					       memory_notifier);
-	struct memory_notify *mnb = arg;
-	int nid = mnb->status_change_nid;
+					       node_notifier);
+	struct node_notify *nn = arg;
+	int nid = nn->nid;
 	int region_nid;
 
-	if (nid == NUMA_NO_NODE || action != MEM_ONLINE)
+	if (action != NODE_ADDED_FIRST_MEMORY)
 		return NOTIFY_DONE;
 
 	/*
@@ -3527,7 +3527,7 @@ static void shutdown_notifiers(void *_cx
 {
 	struct cxl_region *cxlr = _cxlr;
 
-	unregister_memory_notifier(&cxlr->memory_notifier);
+	unregister_node_notifier(&cxlr->node_notifier);
 	unregister_mt_adistance_algorithm(&cxlr->adist_notifier);
 }
 
@@ -3566,9 +3566,9 @@ out:
 	if (rc)
 		return rc;
 
-	cxlr->memory_notifier.notifier_call = cxl_region_perf_attrs_callback;
-	cxlr->memory_notifier.priority = CXL_CALLBACK_PRI;
-	register_memory_notifier(&cxlr->memory_notifier);
+	cxlr->node_notifier.notifier_call = cxl_region_perf_attrs_callback;
+	cxlr->node_notifier.priority = CXL_CALLBACK_PRI;
+	register_node_notifier(&cxlr->node_notifier);
 
 	cxlr->adist_notifier.notifier_call = cxl_region_calculate_adistance;
 	cxlr->adist_notifier.priority = 100;
--- a/drivers/cxl/cxl.h~driverscxl-use-node-notifier-instead-of-memory-notifier
+++ a/drivers/cxl/cxl.h
@@ -513,7 +513,7 @@ enum cxl_partition_mode {
  * @flags: Region state flags
  * @params: active + config params for the region
  * @coord: QoS access coordinates for the region
- * @memory_notifier: notifier for setting the access coordinates to node
+ * @node_notifier: notifier for setting the access coordinates to node
  * @adist_notifier: notifier for calculating the abstract distance of node
  */
 struct cxl_region {
@@ -526,7 +526,7 @@ struct cxl_region {
 	unsigned long flags;
 	struct cxl_region_params params;
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
-	struct notifier_block memory_notifier;
+	struct notifier_block node_notifier;
 	struct notifier_block adist_notifier;
 };
 
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

