Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A73C43616
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17E3261421
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhEEBke (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231991AbhEEBkd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13B24610A1;
        Wed,  5 May 2021 01:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178777;
        bh=9xmxFiV0bSIGgt/eX3B2Nz5YeCjM/YwnOzkybcUylYE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2vS8fn3rp0xxv6wH4g9aK6CikpIPl9Lh9/9scrCUMoLB2Q8mFQNIz9RiMx6VoAYj4
         raVdFUecGh9jL2QL8AazAn+NWD05i3Z4GEhybuyc5X/l6lnNuXsHH7V5WjskvUHT4k
         2lr4K5r+gjZbKBbhYcixnxG64NyqydyIlz2E5oLE=
Date:   Tue, 04 May 2021 18:39:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 126/143] mm,memory_hotplug: relax fully spanned
 sections check
Message-ID: <20210505013936.UBlNm_lxU%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,memory_hotplug: relax fully spanned sections check

We want {online,offline}_pages to operate on whole memblocks, but
memmap_on_memory will poke pageblock_nr_pages aligned holes in the
beginning, which is a special case we want to allow.  Relax the check to
account for that case.

Link: https://lkml.kernel.org/r/20210421102701.25051-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/mm/memory_hotplug.c~mmmemory_hotplug-relax-fully-spanned-sections-check
+++ a/mm/memory_hotplug.c
@@ -838,9 +838,16 @@ int __ref online_pages(unsigned long pfn
 	int ret;
 	struct memory_notify arg;
 
-	/* We can only online full sections (e.g., SECTION_IS_ONLINE) */
+	/*
+	 * {on,off}lining is constrained to full memory sections (or more
+	 * precisly to memory blocks from the user space POV).
+	 * memmap_on_memory is an exception because it reserves initial part
+	 * of the physical memory space for vmemmaps. That space is pageblock
+	 * aligned.
+	 */
 	if (WARN_ON_ONCE(!nr_pages ||
-			 !IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION)))
+			 !IS_ALIGNED(pfn, pageblock_nr_pages) ||
+			 !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
 	mem_hotplug_begin();
@@ -1573,9 +1580,16 @@ int __ref offline_pages(unsigned long st
 	int ret, node;
 	char *reason;
 
-	/* We can only offline full sections (e.g., SECTION_IS_ONLINE) */
+	/*
+	 * {on,off}lining is constrained to full memory sections (or more
+	 * precisly to memory blocks from the user space POV).
+	 * memmap_on_memory is an exception because it reserves initial part
+	 * of the physical memory space for vmemmaps. That space is pageblock
+	 * aligned.
+	 */
 	if (WARN_ON_ONCE(!nr_pages ||
-			 !IS_ALIGNED(start_pfn | nr_pages, PAGES_PER_SECTION)))
+			 !IS_ALIGNED(start_pfn, pageblock_nr_pages) ||
+			 !IS_ALIGNED(start_pfn + nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
 	mem_hotplug_begin();
_
