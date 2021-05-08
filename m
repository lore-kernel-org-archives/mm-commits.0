Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0998BC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA2AF6142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWwF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWwE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94C86613EA;
        Sat,  8 May 2021 22:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514262;
        bh=zjFUbrRSCL50msefKBCqX2L024BX5Uw5+ch+U57rqhg=;
        h=Date:From:To:Subject:From;
        b=1VJwVLv5vdPOx8lG0kbOoJW2Rg/7dusB+crRhaB8Orkvs69fCsEN/oFgl72WzSSfn
         Wco3N1BNgZEePk9sKiLh2IByNKnyoYwr4mGzIFQ76bTRfQH4SlYNZBqQOtt38wreGP
         2zvYjxWO4ZTa1O11Myyog34v/gYYlA0/W4m8s43Q=
Date:   Sat, 08 May 2021 15:51:02 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [merged]
 mmmemory_hotplug-relax-fully-spanned-sections-check.patch removed from -mm
 tree
Message-ID: <20210508225102.sR0pZa711%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,memory_hotplug: relax fully spanned sections check
has been removed from the -mm tree.  Its filename was
     mmmemory_hotplug-relax-fully-spanned-sections-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from osalvador@suse.de are


