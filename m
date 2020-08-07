Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECFEC433E1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BEBB22CB3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781441;
	bh=cZLwUj13ml3wJX9dyoNRSrj8qUJ1+Vkfmrc5G7DJAWk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=EKeViIBhirRAbUzMwUS3W5vQmXUrk/a+B4dH7Czzta2EbnuWrySBA8Jg/N9UkdsuO
	 pKyQgsqGeOCmA/MXUui63IRWElpYnJdRUeIKz+ec8JMquqc7gfpkD0ryENNwonvpDa
	 jVQJgpW2aXUel40JTAMXb56tk8nnPWPxIIcd23yk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHGGYB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:32958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGGYA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC87222D0B;
        Fri,  7 Aug 2020 06:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781440;
        bh=cZLwUj13ml3wJX9dyoNRSrj8qUJ1+Vkfmrc5G7DJAWk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=f8N6pgOaRG6TPxELiQcCFIkS/kG7XrZYBYqEhX12Itv7IyaSh7vpgA/Tc3B8IMQOW
         94u2H6sgT111em/4SJ+YfTSh1lo3NDm7ZHJcFU0LYLOimPm7ST8PdhC/Dyo00aygAX
         OK1yNAOesxgcRiYsX0wRp32MtIlfyffRwjZVggN0=
Date:   Thu, 06 Aug 2020 23:23:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 119/163] mm/sparse: only sub-section aligned range
 would be populated
Message-ID: <20200807062359.Hd_vkkVYt%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
