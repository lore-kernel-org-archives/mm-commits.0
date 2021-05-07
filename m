Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67BEC43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7D23613D8
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhEGBGV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231297AbhEGBGU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBE10613C9;
        Fri,  7 May 2021 01:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349521;
        bh=88ivDJ1CXwhD6vBlUS1xYyAABpSgFwJ4ovGEuT2Yu9I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=r/a4OC9OMbZFTSoOcZD9G2T9q/+CvdLvlr5BqcLQFYraZeeRnP09v0BM+C5xcaxBZ
         HoNNKELlUoN6dv5VtFK0LXq22FUcFpBKgLc6BNPTWrgig7nJLQ7nrzxs075m6cYVdu
         fgLJbTQDdunUH4jh3DaZvcRobCu/XdNybjZIvxXU=
Date:   Thu, 06 May 2021 18:05:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bhe@redhat.com, bp@alien8.de, brijesh.singh@amd.com, cai@lca.pw,
        dan.j.williams@intel.com, daniel.vetter@ffwll.ch,
        dave.hansen@linux.intel.com, david@redhat.com, dyoung@redhat.com,
        ebiederm@xmission.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        keith.busch@intel.com, linux-mm@kvack.org,
        mchehab+huawei@kernel.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, tglx@linutronix.de,
        thomas.lendacky@amd.com, torvalds@linux-foundation.org,
        vgoyal@redhat.com
Subject:  [patch 63/91] kernel/resource: remove first_lvl /
 siblings_only logic
Message-ID: <20210507010520.ixz1VhOsz%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: kernel/resource: remove first_lvl / siblings_only logic

All functions that search for IORESOURCE_SYSTEM_RAM or IORESOURCE_MEM
resources now properly consider the whole resource tree, not just the
first level.  Let's drop the unused first_lvl / siblings_only logic.

Remove documentation that indicates that some functions behave differently,
all consider the full resource tree now.

Link: https://lkml.kernel.org/r/20210325115326.7826-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   45 +++++++++++---------------------------------
 1 file changed, 12 insertions(+), 33 deletions(-)

--- a/kernel/resource.c~kernel-resource-remove-first_lvl-siblings_only-logic
+++ a/kernel/resource.c
@@ -64,12 +64,8 @@ static DEFINE_RWLOCK(resource_lock);
 static struct resource *bootmem_resource_free;
 static DEFINE_SPINLOCK(bootmem_resource_lock);
 
-static struct resource *next_resource(struct resource *p, bool sibling_only)
+static struct resource *next_resource(struct resource *p)
 {
-	/* Caller wants to traverse through siblings only */
-	if (sibling_only)
-		return p->sibling;
-
 	if (p->child)
 		return p->child;
 	while (!p->sibling && p->parent)
@@ -81,7 +77,7 @@ static void *r_next(struct seq_file *m,
 {
 	struct resource *p = v;
 	(*pos)++;
-	return (void *)next_resource(p, false);
+	return (void *)next_resource(p);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -330,14 +326,10 @@ EXPORT_SYMBOL(release_resource);
  * of the resource that's within [@start..@end]; if none is found, returns
  * -ENODEV.  Returns -EINVAL for invalid parameters.
  *
- * This function walks the whole tree and not just first level children
- * unless @first_lvl is true.
- *
  * @start:	start address of the resource searched for
  * @end:	end address of same resource
  * @flags:	flags which the resource must have
  * @desc:	descriptor the resource must have
- * @first_lvl:	walk only the first level children, if set
  * @res:	return ptr, if resource found
  *
  * The caller must specify @start, @end, @flags, and @desc
@@ -345,9 +337,8 @@ EXPORT_SYMBOL(release_resource);
  */
 static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 			       unsigned long flags, unsigned long desc,
-			       bool first_lvl, struct resource *res)
+			       struct resource *res)
 {
-	bool siblings_only = true;
 	struct resource *p;
 
 	if (!res)
@@ -358,7 +349,7 @@ static int find_next_iomem_res(resource_
 
 	read_lock(&resource_lock);
 
-	for (p = iomem_resource.child; p; p = next_resource(p, siblings_only)) {
+	for (p = iomem_resource.child; p; p = next_resource(p)) {
 		/* If we passed the resource we are looking for, stop */
 		if (p->start > end) {
 			p = NULL;
@@ -369,13 +360,6 @@ static int find_next_iomem_res(resource_
 		if (p->end < start)
 			continue;
 
-		/*
-		 * Now that we found a range that matches what we look for,
-		 * check the flags and the descriptor. If we were not asked to
-		 * use only the first level, start looking at children as well.
-		 */
-		siblings_only = first_lvl;
-
 		if ((p->flags & flags) != flags)
 			continue;
 		if ((desc != IORES_DESC_NONE) && (desc != p->desc))
@@ -402,14 +386,14 @@ static int find_next_iomem_res(resource_
 
 static int __walk_iomem_res_desc(resource_size_t start, resource_size_t end,
 				 unsigned long flags, unsigned long desc,
-				 bool first_lvl, void *arg,
+				 void *arg,
 				 int (*func)(struct resource *, void *))
 {
 	struct resource res;
 	int ret = -EINVAL;
 
 	while (start < end &&
-	       !find_next_iomem_res(start, end, flags, desc, first_lvl, &res)) {
+	       !find_next_iomem_res(start, end, flags, desc, &res)) {
 		ret = (*func)(&res, arg);
 		if (ret)
 			break;
@@ -431,7 +415,6 @@ static int __walk_iomem_res_desc(resourc
  * @arg: function argument for the callback @func
  * @func: callback function that is called for each qualifying resource area
  *
- * This walks through whole tree and not just first level children.
  * All the memory ranges which overlap start,end and also match flags and
  * desc are valid candidates.
  *
@@ -441,7 +424,7 @@ static int __walk_iomem_res_desc(resourc
 int walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start,
 		u64 end, void *arg, int (*func)(struct resource *, void *))
 {
-	return __walk_iomem_res_desc(start, end, flags, desc, false, arg, func);
+	return __walk_iomem_res_desc(start, end, flags, desc, arg, func);
 }
 EXPORT_SYMBOL_GPL(walk_iomem_res_desc);
 
@@ -457,8 +440,8 @@ int walk_system_ram_res(u64 start, u64 e
 {
 	unsigned long flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 
-	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, false,
-				     arg, func);
+	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, arg,
+				     func);
 }
 
 /*
@@ -470,17 +453,14 @@ int walk_mem_res(u64 start, u64 end, voi
 {
 	unsigned long flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 
-	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, false,
-				     arg, func);
+	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, arg,
+				     func);
 }
 
 /*
  * This function calls the @func callback against all memory ranges of type
  * System RAM which are marked as IORESOURCE_SYSTEM_RAM and IORESOUCE_BUSY.
  * It is to be used only for System RAM.
- *
- * This will find System RAM ranges that are children of top-level resources
- * in addition to top-level System RAM resources.
  */
 int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 			  void *arg, int (*func)(unsigned long, unsigned long, void *))
@@ -495,8 +475,7 @@ int walk_system_ram_range(unsigned long
 	end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
 	flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 	while (start < end &&
-	       !find_next_iomem_res(start, end, flags, IORES_DESC_NONE,
-				    false, &res)) {
+	       !find_next_iomem_res(start, end, flags, IORES_DESC_NONE, &res)) {
 		pfn = PFN_UP(res.start);
 		end_pfn = PFN_DOWN(res.end + 1);
 		if (end_pfn > pfn)
_
