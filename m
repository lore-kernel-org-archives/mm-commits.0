Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1786AC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDB45206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027125;
	bh=h2ZlLSTxrFgFVLjrQf0N4Eu3XlDQV0Gs3KDWOnVMBUw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=T4GQjd4c57nJkJNIy98ZQD0W99S9QpK8bdaUULX1l4+ofkZGNajKIohRmeD9FAXIy
	 CTO25V7K9IK/Zg+zMFhrTfsFxR1qp1gm7k4koe/ggZ0rpCmJxU4qNS1oh0pivY46fw
	 937Y+nALIkgQ960wLxuP8NZTDG/fEsurdxrOR6wE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHJCip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgHJCip (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 936162065D;
        Mon, 10 Aug 2020 02:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027124;
        bh=h2ZlLSTxrFgFVLjrQf0N4Eu3XlDQV0Gs3KDWOnVMBUw=;
        h=Date:From:To:Subject:From;
        b=Co/x2N8StaqfphYRRJTWNIunAysXaj6SsMUJNthRhcNjDcbAicE0Y/V7TtAPjwTA9
         LrLdG4BD3KDI6YmgfzHu2fclc7hau+QGyKuQlS04gVWZP+2oLOJNVOMnH6oEFh2I0F
         DuwXL4Xudfx/x5n/r2DbLoKf/3PWBEDjf0lJ71bs=
Date:   Sun, 09 Aug 2020 19:38:44 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  [merged]
 mm-sparse-only-sub-section-aligned-range-would-be-populated.patch removed
 from -mm tree
Message-ID: <20200810023844.t_E0Mpky2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: only sub-section aligned range would be populated
has been removed from the -mm tree.  Its filename was
     mm-sparse-only-sub-section-aligned-range-would-be-populated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/sparse: only sub-section aligned range would be populated

There are two code path which invoke __populate_section_memmap()

  * sparse_init_nid()
  * sparse_add_section()

For both case, we are sure the memory range is sub-section aligned.

  * we pass PAGES_PER_SECTION to sparse_init_nid()
  * we check range by check_pfn_span() before calling
    sparse_add_section()

Also, the counterpart of __populate_section_memmap(), we don't do such
calculation and check since the range is checked by check_pfn_span() in
__remove_pages().

Clear the calculation and check to keep it simple and comply with its
counterpart.

Link: http://lkml.kernel.org/r/20200703031828.14645-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-only-sub-section-aligned-range-would-be-populated
+++ a/mm/sparse-vmemmap.c
@@ -251,20 +251,12 @@ int __meminit vmemmap_populate_basepages
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
-	unsigned long start;
-	unsigned long end;
+	unsigned long start = (unsigned long) pfn_to_page(pfn);
+	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	/*
-	 * The minimum granularity of memmap extensions is
-	 * PAGES_PER_SUBSECTION as allocations are tracked in the
-	 * 'subsection_map' bitmap of the section.
-	 */
-	end = ALIGN(pfn + nr_pages, PAGES_PER_SUBSECTION);
-	pfn &= PAGE_SUBSECTION_MASK;
-	nr_pages = end - pfn;
-
-	start = (unsigned long) pfn_to_page(pfn);
-	end = start + nr_pages * sizeof(struct page);
+	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
+		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
+		return NULL;
 
 	if (vmemmap_populate(start, end, nid, altmap))
 		return NULL;
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are


