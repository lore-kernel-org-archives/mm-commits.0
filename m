Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3659E1D54FA
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450002; cv=none; b=lzghdDYd5NsTJmugzafbk6eU/EpjXrVkQRm/YImCRTLmFDhhwiwsnnpzZ+2yPCJvdKP6t0cr2HRiE+OabwtDfm3wGvjpT4/WOf40fVIRNCNXW6WAjSF9n1T3RgrLVN8FiwLgwM4V1OP+PAQBJ9xOtluwGBfvR7/f9kkQZpZ9vRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450002; c=relaxed/simple;
	bh=joFDuhn8bwtS0IkG5aRgixtd8LKFb2mwCzASsDgrQII=;
	h=Date:To:From:Subject:Message-Id; b=ADRhaggTUBWpfN0D+sXsdbtdbTh1adJirsr34ySx4BUS0tCDKbE2TFhp7pPjPkYXzWy1QFcaoJDQY4FukVRHF6yyU+5achI/VUJKapcXjhboGj4iSrO63Yc+RYOGzJUx81rXuj6OwT4n2yqIvgyoPM4PllYx4CWyeWSqE89ZK5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aDkkpnnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aDkkpnnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09834C4CEE3;
	Sun, 13 Jul 2025 23:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450002;
	bh=joFDuhn8bwtS0IkG5aRgixtd8LKFb2mwCzASsDgrQII=;
	h=Date:To:From:Subject:From;
	b=aDkkpnnpXbZBq5NzqhcRHAvxpdyMocUEC1Cmh/57qNFqu3XmtqRKqoe0YvgESQKmB
	 0zU45f62TCaB6o54MdAgyS0shewCj5EKBl/aTocVm9wHtbMVuI9QD0UFn+J6p/DiBe
	 MsM7sb1x6wSlutt1oVdOu5G8OL/pKgRBkWVA/4NQ=
Date: Sun, 13 Jul 2025 16:40:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] driverscxl-use-node-notifier-instead-of-memory-notifier.patch removed from -mm tree
Message-Id: <20250713234002.09834C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers,cxl: use node-notifier instead of memory-notifier
has been removed from the -mm tree.  Its filename was
     driverscxl-use-node-notifier-instead-of-memory-notifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


