Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CA6C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E41B721D40
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881495;
	bh=WARkPvlaIcIzWZ0DeCKlusRIyezNb3jsZUpOuRe5AlY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Mmlr8yd9wazhanRvrV0mefBB+ONO3zeCj2ew8wo/AcG6w7FtD4d/oP8sLXZcbMfXO
	 ko7OjnElOEh5YtN3uw04fASZFjHkbWFxmIA+bhsGNNIrZQwdJoH3faMHh+SLsjwxHb
	 FipKcePLK8SD+RJfcZVfMlK9EU2ZgobDkRpjf4fM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406371AbgJPUve (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgJPUve (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:51:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D78E521D41;
        Fri, 16 Oct 2020 20:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881493;
        bh=WARkPvlaIcIzWZ0DeCKlusRIyezNb3jsZUpOuRe5AlY=;
        h=Date:From:To:Subject:From;
        b=FPtGbH1tn1dfQGOkbOgMvNduodCEtD3oNF/3hTe6IuW2s5osofcL62BXnMC3VM3ab
         a1ucWwTjXj1OJrdtllPv9a+EkQR859tQLzXj693pL1Gy3zHOBoABaR9TNRqqa5VpLe
         tyjXYCYFKkC7/PRe+0lJhyQkZR3h4340pnU62KsE=
Date:   Fri, 16 Oct 2020 13:51:32 -0700
From:   akpm@linux-foundation.org
To:     cheloha@linux.ibm.com, david@redhat.com, fenghua.yu@intel.com,
        gregkh@linuxfoundation.org, ldufour@linux.ibm.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, nathanl@linux.ibm.com,
        osalvador@suse.de, rafael@kernel.org, tony.luck@intel.com
Subject:  [merged]
 mm-dont-panic-when-links-cant-be-created-in-sysfs.patch removed from -mm
 tree
Message-ID: <20201016205132.WS8QCxGBs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't panic when links can't be created in sysfs
has been removed from the -mm tree.  Its filename was
     mm-dont-panic-when-links-cant-be-created-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.ibm.com>
Subject: mm: don't panic when links can't be created in sysfs

At boot time, or when doing memory hot-add operations, if the links in
sysfs can't be created, the system is still able to run, so just report
the error in the kernel log rather than BUG_ON and potentially make system
unusable because the callpath can be called with locks held.

Since the number of memory blocks managed could be high, the messages are
rate limited.

As a consequence, link_mem_sections() has no status to report anymore.

Link: https://lkml.kernel.org/r/20200915094143.79181-4-ldufour@linux.ibm.com
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |   33 +++++++++++++++++++++------------
 include/linux/node.h |   16 +++++++---------
 mm/memory_hotplug.c  |    5 ++---
 3 files changed, 30 insertions(+), 24 deletions(-)

--- a/drivers/base/node.c~mm-dont-panic-when-links-cant-be-created-in-sysfs
+++ a/drivers/base/node.c
@@ -772,8 +772,8 @@ static int __ref get_nid_for_pfn(unsigne
 	return pfn_to_nid(pfn);
 }
 
-static int do_register_memory_block_under_node(int nid,
-					       struct memory_block *mem_blk)
+static void do_register_memory_block_under_node(int nid,
+						struct memory_block *mem_blk)
 {
 	int ret;
 
@@ -786,12 +786,19 @@ static int do_register_memory_block_unde
 	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
 				       &mem_blk->dev.kobj,
 				       kobject_name(&mem_blk->dev.kobj));
-	if (ret)
-		return ret;
+	if (ret && ret != -EEXIST)
+		dev_err_ratelimited(&node_devices[nid]->dev,
+				    "can't create link to %s in sysfs (%d)\n",
+				    kobject_name(&mem_blk->dev.kobj), ret);
 
-	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
+	ret = sysfs_create_link_nowarn(&mem_blk->dev.kobj,
 				&node_devices[nid]->dev.kobj,
 				kobject_name(&node_devices[nid]->dev.kobj));
+	if (ret && ret != -EEXIST)
+		dev_err_ratelimited(&mem_blk->dev,
+				    "can't create link to %s in sysfs (%d)\n",
+				    kobject_name(&node_devices[nid]->dev.kobj),
+				    ret);
 }
 
 /* register memory section under specified node if it spans that node */
@@ -827,7 +834,8 @@ static int register_mem_block_under_node
 		if (page_nid != nid)
 			continue;
 
-		return do_register_memory_block_under_node(nid, mem_blk);
+		do_register_memory_block_under_node(nid, mem_blk);
+		return 0;
 	}
 	/* mem section does not span the specified node */
 	return 0;
@@ -842,7 +850,8 @@ static int register_mem_block_under_node
 {
 	int nid = *(int *)arg;
 
-	return do_register_memory_block_under_node(nid, mem_blk);
+	do_register_memory_block_under_node(nid, mem_blk);
+	return 0;
 }
 
 /*
@@ -860,8 +869,8 @@ void unregister_memory_block_under_nodes
 			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
-int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
-		      enum meminit_context context)
+void link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
+		       enum meminit_context context)
 {
 	walk_memory_blocks_func_t func;
 
@@ -870,9 +879,9 @@ int link_mem_sections(int nid, unsigned
 	else
 		func = register_mem_block_under_node_early;
 
-	return walk_memory_blocks(PFN_PHYS(start_pfn),
-				  PFN_PHYS(end_pfn - start_pfn), (void *)&nid,
-				  func);
+	walk_memory_blocks(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
+			   (void *)&nid, func);
+	return;
 }
 
 #ifdef CONFIG_HUGETLBFS
--- a/include/linux/node.h~mm-dont-panic-when-links-cant-be-created-in-sysfs
+++ a/include/linux/node.h
@@ -99,15 +99,14 @@ extern struct node *node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
-int link_mem_sections(int nid, unsigned long start_pfn,
-		      unsigned long end_pfn,
-		      enum meminit_context context);
+void link_mem_sections(int nid, unsigned long start_pfn,
+		       unsigned long end_pfn,
+		       enum meminit_context context);
 #else
-static inline int link_mem_sections(int nid, unsigned long start_pfn,
-				    unsigned long end_pfn,
-				    enum meminit_context context)
+static inline void link_mem_sections(int nid, unsigned long start_pfn,
+				     unsigned long end_pfn,
+				     enum meminit_context context)
 {
-	return 0;
 }
 #endif
 
@@ -130,8 +129,7 @@ static inline int register_one_node(int
 		if (error)
 			return error;
 		/* link memory sections under this node */
-		error = link_mem_sections(nid, start_pfn, end_pfn,
-					  MEMINIT_EARLY);
+		link_mem_sections(nid, start_pfn, end_pfn, MEMINIT_EARLY);
 	}
 
 	return error;
--- a/mm/memory_hotplug.c~mm-dont-panic-when-links-cant-be-created-in-sysfs
+++ a/mm/memory_hotplug.c
@@ -1092,9 +1092,8 @@ int __ref add_memory_resource(int nid, s
 	}
 
 	/* link memory sections under this node.*/
-	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
-				MEMINIT_HOTPLUG);
-	BUG_ON(ret);
+	link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
+			  MEMINIT_HOTPLUG);
 
 	/* create new memmap entry */
 	if (!strcmp(res->name, "System RAM"))
_

Patches currently in -mm which might be from ldufour@linux.ibm.com are


