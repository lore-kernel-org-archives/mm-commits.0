Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52017EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjFSXVM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjFSXUr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12A5E7D
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26D9060F53
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E43AC433C8;
        Mon, 19 Jun 2023 23:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216840;
        bh=APm5TjITRYl6aZYKMA6DNrGb2duiwot2CFSt21L92IQ=;
        h=Date:To:From:Subject:From;
        b=zaYkbbCB+ghV6AuP1cMdJAX/Gs7trLUqAEA9j/E7wIez0uU+nPDArBELPKShxki8t
         TQJyJF9bzxGgDrMu3XetzZ1BEu+u30kref0uoeiNLbSK8boB7kPkeOM/7JHXnzuKs1
         7kuFp/QItFxFUTEvBT4Wp3uwHO5jhFKNi2DMz95E=
Date:   Mon, 19 Jun 2023 16:20:39 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-unused-parameters-in-sparse_remove_section.patch removed from -mm tree
Message-Id: <20230619232040.7E43AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/sparse: remove unused parameters in sparse_remove_section()
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-unused-parameters-in-sparse_remove_section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
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

