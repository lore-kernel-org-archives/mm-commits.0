Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA87C7EE2F
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240805AbjFGCvC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbjFGCvB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3901990
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16922639F8
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66590C433D2;
        Wed,  7 Jun 2023 02:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686106259;
        bh=UmxtAPZYdrwP9e83EcCE+oxaLIw27OVLkp1G6dnQueE=;
        h=Date:To:From:Subject:From;
        b=xhkc9vEfSkgmpgfImZaBknUWqCG61ci84zx7d5U4QVMcd0lERjvuqztJsUhKPuFQz
         6Y1etJKAen4mvAHmIEqMACiu0tMOe0E2tCR6JtaQ2rN3VjWSkWqES1Y+lxbVc+BCnU
         ghPR9U6Pm1BBvX5eG4yORE5Z7+aE/FMOtbGKQn/c=
Date:   Tue, 06 Jun 2023 19:50:58 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-remove-unused-parameters-in-sparse_remove_section.patch added to mm-unstable branch
Message-Id: <20230607025059.66590C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: remove unused parameters in sparse_remove_section()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-remove-unused-parameters-in-sparse_remove_section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-remove-unused-parameters-in-sparse_remove_section.patch

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
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/sparse: remove unused parameters in sparse_remove_section()
Date: Wed, 7 Jun 2023 10:39:52 +0800

These parameters ms and map_offset are not used in
sparse_remove_section(), so remove them.

The __remove_section() is only called by __remove_pages(), remove it.  And
put the WARN_ON_ONCE() in sparse_remove_section().

Link: https://lkml.kernel.org/r/20230607023952.2247489-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    5 ++---
 mm/memory_hotplug.c            |   18 +-----------------
 mm/sparse.c                    |   10 +++++++---
 3 files changed, 10 insertions(+), 23 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-sparse-remove-unused-parameters-in-sparse_remove_section
+++ a/include/linux/memory_hotplug.h
@@ -344,9 +344,8 @@ extern void remove_pfn_range_from_zone(s
 extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
-extern void sparse_remove_section(struct mem_section *ms,
-		unsigned long pfn, unsigned long nr_pages,
-		unsigned long map_offset, struct vmem_altmap *altmap);
+extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
+				  struct vmem_altmap *altmap);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
 extern struct zone *zone_for_pfn_range(int online_type, int nid,
--- a/mm/memory_hotplug.c~mm-sparse-remove-unused-parameters-in-sparse_remove_section
+++ a/mm/memory_hotplug.c
@@ -492,18 +492,6 @@ void __ref remove_pfn_range_from_zone(st
 	set_zone_contiguous(zone);
 }
 
-static void __remove_section(unsigned long pfn, unsigned long nr_pages,
-			     unsigned long map_offset,
-			     struct vmem_altmap *altmap)
-{
-	struct mem_section *ms = __pfn_to_section(pfn);
-
-	if (WARN_ON_ONCE(!valid_section(ms)))
-		return;
-
-	sparse_remove_section(ms, pfn, nr_pages, map_offset, altmap);
-}
-
 /**
  * __remove_pages() - remove sections of pages
  * @pfn: starting pageframe (must be aligned to start of a section)
@@ -520,9 +508,6 @@ void __remove_pages(unsigned long pfn, u
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
-	unsigned long map_offset = 0;
-
-	map_offset = vmem_altmap_offset(altmap);
 
 	if (check_pfn_span(pfn, nr_pages)) {
 		WARN(1, "Misaligned %s start: %#lx end: %#lx\n", __func__, pfn, pfn + nr_pages - 1);
@@ -534,8 +519,7 @@ void __remove_pages(unsigned long pfn, u
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		__remove_section(pfn, cur_nr_pages, map_offset, altmap);
-		map_offset = 0;
+		sparse_remove_section(pfn, cur_nr_pages, altmap);
 	}
 }
 
--- a/mm/sparse.c~mm-sparse-remove-unused-parameters-in-sparse_remove_section
+++ a/mm/sparse.c
@@ -922,10 +922,14 @@ int __meminit sparse_add_section(int nid
 	return 0;
 }
 
-void sparse_remove_section(struct mem_section *ms, unsigned long pfn,
-		unsigned long nr_pages, unsigned long map_offset,
-		struct vmem_altmap *altmap)
+void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
+			   struct vmem_altmap *altmap)
 {
+	struct mem_section *ms = __pfn_to_section(pfn);
+
+	if (WARN_ON_ONCE(!valid_section(ms)))
+		return;
+
 	section_deactivate(pfn, nr_pages, altmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

dma-contiguous-support-per-numa-cma-for-all-architectures.patch
mm-sparse-remove-unused-parameters-in-sparse_remove_section.patch

