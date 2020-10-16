Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8511FC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D96A20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817758;
	bh=C5jIIUAAEdWsLo34nPRoDaB1pKuxd4AGb5OYRqWxTwY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gL5VY7YYHDKI4T5tIz3OiHhdz18DcAIr78u9yGJXk5Uxlu/n2Fhnrbr/vYNUlmVsR
	 VUzt3rz5rlnQfqtKHvxqgRS04jL03zduMcsLMyNh+6N38a3DRmUGcRBl60dCK1HhND
	 WYgtmjKpy4l9ToVyt+QmFMyQwC4KTb4gS1XFAygg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732480AbgJPDJR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgJPDJR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:09:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7175520878;
        Fri, 16 Oct 2020 03:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817757;
        bh=C5jIIUAAEdWsLo34nPRoDaB1pKuxd4AGb5OYRqWxTwY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=V7y9DSDJd5rAY/0wSCXVsegUpQGPAuYiJstWglPVZaeogxj0NBRQK/brPp7fSXxy0
         RyOb8Ce50EsCz5zpwNgjlvB1XkGtLJlijrjEV4Pl/iP+/sJ8xBucSVhoREBwlniCxK
         DcQTrL/hIaH3fwQB+vuKuSXLrFxCIKR+8owZnxxs=
Date:   Thu, 15 Oct 2020 20:09:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cheloha@linux.ibm.com, david@redhat.com,
        fenghua.yu@intel.com, gregkh@linuxfoundation.org,
        ldufour@linux.ibm.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        nathanl@linux.ibm.com, osalvador@suse.de, rafael@kernel.org,
        tony.luck@intel.com, torvalds@linux-foundation.org
Subject:  [patch 078/156] mm: don't panic when links can't be
 created in sysfs
Message-ID: <20201016030915.43TD8VflO%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
