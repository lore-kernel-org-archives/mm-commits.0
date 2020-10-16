Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22C8C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CFDD21D81
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881491;
	bh=Vd39FAG/DvurcAulzibJ6INcQm18TYFSYLqkk3W3az4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1NiHcuzjxj7ptUjksY+JcP7VWg5chQ4XWyMOqPX9yB4cUliUtFlUDQNRGlcmEFy2r
	 WsQbAcYmOFqrUGcYpulQw4TEZZCAEN94Nzg5yYWP9ZheCPCRHYwyRnprziwfHhsDmr
	 NXKuxlh8kYFgtaRk5hHmAhcCFWT/tDu2crcf5O9Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406340AbgJPUvb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgJPUvb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:51:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0283F21D40;
        Fri, 16 Oct 2020 20:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881490;
        bh=Vd39FAG/DvurcAulzibJ6INcQm18TYFSYLqkk3W3az4=;
        h=Date:From:To:Subject:From;
        b=wMtinSbVv0sZoRj86qW/yZHIajMCBo8wU4sDMIrYgRwsYKVinAMzt79T5MYsysX4S
         yQUlarnk6jDPANtdxVq1z24dUQYDA1V0R7Q8+/MYhygndnuhLymruBOjrdYfVA8d/Q
         KAk7iRWNXwAzhCNBEpRwhF5L2oFmio0SoiC+qar4=
Date:   Fri, 16 Oct 2020 13:51:29 -0700
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, bhe@redhat.com, dan.j.williams@intel.com,
        david@redhat.com, jgg@ziepe.ca, keescook@chromium.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com
Subject:  [merged]
 =?US-ASCII?Q?kernel-resource-make-iomem=5Fresource-implicit-in-release?=
 =?US-ASCII?Q?=5Fmem=5Fregion=5Fadjustable.patch?= removed from -mm tree
Message-ID: <20201016205129.y4wSm1NJO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: make iomem_resource implicit in release_mem_region_adjustable()
has been removed from the -mm tree.  Its filename was
     kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: kernel/resource: make iomem_resource implicit in release_mem_region_adjustable()

"mem" in the name already indicates the root, similar to
release_mem_region() and devm_request_mem_region().  Make it implicit. 
The only single caller always passes iomem_resource, other parents are not
applicable.

Link: https://lkml.kernel.org/r/20200916073041.10355-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    3 +--
 kernel/resource.c      |    5 ++---
 mm/memory_hotplug.c    |    2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/linux/ioport.h~kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable
+++ a/include/linux/ioport.h
@@ -251,8 +251,7 @@ extern struct resource * __request_regio
 extern void __release_region(struct resource *, resource_size_t,
 				resource_size_t);
 #ifdef CONFIG_MEMORY_HOTREMOVE
-extern void release_mem_region_adjustable(struct resource *, resource_size_t,
-					  resource_size_t);
+extern void release_mem_region_adjustable(resource_size_t, resource_size_t);
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern void merge_system_ram_resource(struct resource *res);
--- a/kernel/resource.c~kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable
+++ a/kernel/resource.c
@@ -1240,7 +1240,6 @@ EXPORT_SYMBOL(__release_region);
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /**
  * release_mem_region_adjustable - release a previously reserved memory region
- * @parent: parent resource descriptor
  * @start: resource start address
  * @size: resource region size
  *
@@ -1258,9 +1257,9 @@ EXPORT_SYMBOL(__release_region);
  *   assumes that all children remain in the lower address entry for
  *   simplicity.  Enhance this logic when necessary.
  */
-void release_mem_region_adjustable(struct resource *parent,
-				   resource_size_t start, resource_size_t size)
+void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
 {
+	struct resource *parent = &iomem_resource;
 	struct resource *new_res = NULL;
 	bool alloc_nofail = false;
 	struct resource **p;
--- a/mm/memory_hotplug.c~kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable
+++ a/mm/memory_hotplug.c
@@ -1767,7 +1767,7 @@ static int __ref try_remove_memory(int n
 		memblock_remove(start, size);
 	}
 
-	release_mem_region_adjustable(&iomem_resource, start, size);
+	release_mem_region_adjustable(start, size);
 
 	try_offline_node(nid);
 
_

Patches currently in -mm which might be from david@redhat.com are


