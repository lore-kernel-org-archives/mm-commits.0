Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8EAC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA8D23159
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgLPEq6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:46:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgLPEq6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:46:58 -0500
Date:   Tue, 15 Dec 2020 20:46:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093978;
        bh=uuiLKgaTD/wLMGatg9kbyBFVKZ8lHx956y4YDKehknE=;
        h=From:To:Subject:In-Reply-To:From;
        b=MnJz1U2PlHviRBzoaOYAcQ9HtzA/DDwIeIW2UKTS8L3yJ1DlB1ElsdgOhQBsHrBC7
         rrwSBGL56HtJTwU8ahYmaZMP/HbvOA1rUWYZHo4/cq8OP75aqKkwvnHosOsJnBcNab
         rMHQFkEEkm/kw7XpMpePXBNCAQDVHBJ/atVVvaes=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 73/95] kernel/resource.c: fix kernel-doc markups
Message-ID: <20201216044616.DTy68TR4-%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: kernel/resource.c: fix kernel-doc markups

Kernel-doc markups should use this format:
        identifier - description

While here, fix a kernel-doc tag that was using, instead,
a normal comment block.

[akpm@linux-foundation.org: coding style fixes]
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
+ *	merge it with adjacent, mergeable resources
  * @res: resource descriptor
  *
  * This interface is intended for memory hotplug, whereby lots of contiguous
_
