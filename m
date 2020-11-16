Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC23C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4102420781
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="eI6RdKKo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732017AbgKPUV6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgKPUV6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 15:21:58 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B7520776;
        Mon, 16 Nov 2020 20:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605558117;
        bh=BXNnDmDfiojH17iq6CTw+p3Sez8y5SyAtpHqlJtl/cg=;
        h=Date:From:To:Subject:From;
        b=eI6RdKKoCrUTzXFSGbVHk68aZlVXBqlCQiCqsjyB9xVciTC7dkMHXkyyspYN5P8m+
         EKU68mgrWw5nTUfR5sxdwmSVu39Z8ziNXv9F5ZrVvqQhcx/fb0RMyApIBixS9+0xvH
         FrzUx9e5h8yMNrSscq8pcipv347KtkZ2aDlP1Jb0=
Date:   Mon, 16 Nov 2020 12:21:56 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + resource-fix-kernel-doc-markups.patch added to -mm tree
Message-ID: <20201116202156.prKE2IAdH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource.c: fix kernel-doc markups
has been added to the -mm tree.  Its filename is
     resource-fix-kernel-doc-markups.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/resource-fix-kernel-doc-markups.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/resource-fix-kernel-doc-markups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: kernel/resource.c: fix kernel-doc markups

Kernel-doc markups should use this format:
        identifier - description

While here, fix a kernel-doc tag that was using, instead,
a normal comment block.

Link: https://lkml.kernel.org/r/c5e38e1070f8dbe2f9607a10b44afe2875bd966c.1605521731.git.mchehab+huawei@kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: "Jonathan Corbet" <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/kernel/resource.c~resource-fix-kernel-doc-markups
+++ a/kernel/resource.c
@@ -320,9 +320,8 @@ int release_resource(struct resource *ol
 EXPORT_SYMBOL(release_resource);
 
 /**
- * Finds the lowest iomem resource that covers part of [@start..@end].  The
- * caller must specify @start, @end, @flags, and @desc (which may be
- * IORES_DESC_NONE).
+ * find_next_iomem_res - Finds the lowest iomem resource that covers part of
+ *			 [@start..@end].
  *
  * If a resource is found, returns 0 and @*res is overwritten with the part
  * of the resource that's within [@start..@end]; if none is found, returns
@@ -337,6 +336,9 @@ EXPORT_SYMBOL(release_resource);
  * @desc:	descriptor the resource must have
  * @first_lvl:	walk only the first level children, if set
  * @res:	return ptr, if resource found
+ *
+ * The caller must specify @start, @end, @flags, and @desc
+ * (which may be IORES_DESC_NONE).
  */
 static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 			       unsigned long flags, unsigned long desc,
@@ -416,11 +418,9 @@ static int __walk_iomem_res_desc(resourc
 }
 
 /**
- * Walks through iomem resources and calls func() with matching resource
- * ranges. This walks through whole tree and not just first level children.
- * All the memory ranges which overlap start,end and also match flags and
- * desc are valid candidates.
- *
+ * walk_iomem_res_desc - Walks through iomem resources and calls func()
+ *			 with matching resource ranges.
+ * *
  * @desc: I/O resource descriptor. Use IORES_DESC_NONE to skip @desc check.
  * @flags: I/O resource flags
  * @start: start addr
@@ -428,6 +428,10 @@ static int __walk_iomem_res_desc(resourc
  * @arg: function argument for the callback @func
  * @func: callback function that is called for each qualifying resource area
  *
+ * This walks through whole tree and not just first level children.
+ * All the memory ranges which overlap start,end and also match flags and
+ * desc are valid candidates.
+ *
  * NOTE: For a new descriptor search, define a new IORES_DESC in
  * <linux/ioport.h> and set it in 'desc' of a target resource entry.
  */
@@ -1372,9 +1376,9 @@ static bool system_ram_resources_mergeab
 	       !r1->child && !r2->child;
 }
 
-/*
+/**
  * merge_system_ram_resource - mark the System RAM resource mergeable and try to
- * merge it with adjacent, mergeable resources
+ * 	merge it with adjacent, mergeable resources
  * @res: resource descriptor
  *
  * This interface is intended for memory hotplug, whereby lots of contiguous
_

Patches currently in -mm which might be from mchehab+huawei@kernel.org are

resource-fix-kernel-doc-markups.patch
mm-fix-kernel-doc-markups.patch

