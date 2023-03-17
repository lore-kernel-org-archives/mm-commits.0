Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A897DC6FD1D
	for <mm-commits@archiver.kernel.org>; Fri, 17 Mar 2023 04:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCQEZH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Mar 2023 00:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCQEY6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2023 00:24:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD17D23107
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 21:24:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F1F16217B
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 04:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB391C433EF;
        Fri, 17 Mar 2023 04:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679027084;
        bh=vUsDT8OGq/lGWUJRqOx5Yn1YJYdGZ0rc9gilRr5On8U=;
        h=Date:To:From:Subject:From;
        b=EsIQtbxWhIUyKaGLee6LaTGQi6XG5MpJfHqLxQl89S9WLI8Yb1tog79kXtEzAPnLA
         295UP+VV6HEUcve7mubBChyqTfYPUw0ZG34mb6cqYejm9Xu92k7vARnRwxWXOdqcRP
         rtyxrPkWoZf5Q8kPa/gxUUWdHqPnkU7jzdVsoKuQ=
Date:   Thu, 16 Mar 2023 21:24:43 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-treewide-redefine-max_order-sanely-fix-3.patch added to mm-unstable branch
Message-Id: <20230317042444.AB391C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix-3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-treewide-redefine-max_order-sanely-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-treewide-redefine-max_order-sanely-fix-3.patch

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
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-treewide-redefine-max_order-sanely-fix-3
Date: Fri, 17 Mar 2023 02:21:44 +0300

fixups per Zi Yan

Link: https://lkml.kernel.org/r/20230316232144.b7ic4cif4kjiabws@box.shutemov.name
Signed-off-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~mm-treewide-redefine-max_order-sanely-fix-3
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -189,7 +189,7 @@ Offsets of the vmap_area's members. They
 information. Makedumpfile gets the start address of the vmalloc region
 from this.
 
-(zone.free_area, MAX_ORDER)
+(zone.free_area, MAX_ORDER + 1)
 ---------------------------
 
 Free areas descriptor. User-space tools use this value to iterate the
--- a/kernel/events/ring_buffer.c~mm-treewide-redefine-max_order-sanely-fix-3
+++ a/kernel/events/ring_buffer.c
@@ -814,7 +814,7 @@ struct perf_buffer *rb_alloc(int nr_page
 	size = sizeof(struct perf_buffer);
 	size += nr_pages * sizeof(void *);
 
-	if (order_base_2(size) >= PAGE_SHIFT+MAX_ORDER)
+	if (order_base_2(size) > PAGE_SHIFT+MAX_ORDER)
 		goto fail;
 
 	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
--- a/mm/Kconfig~mm-treewide-redefine-max_order-sanely-fix-3
+++ a/mm/Kconfig
@@ -666,8 +666,8 @@ config HUGETLB_PAGE_SIZE_VARIABLE
 	  HUGETLB_PAGE_ORDER when there are multiple HugeTLB page sizes available
 	  on a platform.
 
-	  Note that the pageblock_order cannot exceed MAX_ORDER - 1 and will be
-	  clamped down to MAX_ORDER - 1.
+	  Note that the pageblock_order cannot exceed MAX_ORDER and will be
+	  clamped down to MAX_ORDER.
 
 config CONTIG_ALLOC
 	def_bool (MEMORY_ISOLATION && COMPACTION) || CMA
--- a/mm/slub.c~mm-treewide-redefine-max_order-sanely-fix-3
+++ a/mm/slub.c
@@ -4697,7 +4697,7 @@ __setup("slub_min_order=", setup_slub_mi
 static int __init setup_slub_max_order(char *str)
 {
 	get_option(&str, (int *)&slub_max_order);
-	slub_max_order = min(slub_max_order, (unsigned int)MAX_ORDER);
+	slub_max_order = min_t(unsigned int, slub_max_order, MAX_ORDER);
 
 	return 1;
 }
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-treewide-redefine-max_order-sanely-fix.patch
mm-treewide-redefine-max_order-sanely-fix-3.patch

