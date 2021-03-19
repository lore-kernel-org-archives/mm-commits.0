Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A20C433E5
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 16:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B2156197D
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 16:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhCSQsL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229967AbhCSQrk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 12:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B45061963;
        Fri, 19 Mar 2021 16:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616172460;
        bh=sEsG1dnfr8kxFlMEri7HnmWh+zoAbx2tP+w/kCp2zKE=;
        h=Date:From:To:Subject:From;
        b=J9lNXOKsfIiR1+ysywNouTg7LHrtXUUwWwgZlE/CUOZ2wF2vDXzcXxbZXu5C2j3pa
         1l/8gH27ZkpjOa654LrzBbKlR8yvy1Dae6yGfsIH8gh8BdhZVxIrt7bgmwVz4JQCwZ
         LpDXBKr2VyvatXr9ggLcfELcwLEKI+Nrpbr7jWcI=
Date:   Fri, 19 Mar 2021 09:47:40 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  +
 mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
 added to -mm tree
Message-ID: <20210319164740.hga4E5DWt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix
has been added to the -mm tree.  Its filename is
     mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix

typo & code cleanup, per David

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix
+++ a/mm/memory_hotplug.c
@@ -1097,7 +1097,7 @@ bool mhp_supports_memmap_on_memory(unsig
 	 * Besides having arch support and the feature enabled at runtime, we
 	 * need a few more assumptions to hold true:
 	 *
-	 * a) We span a single memory block: memory onlining/offlinin;g happens
+	 * a) We span a single memory block: memory onlining/offlining happens
 	 *    in memory block granularity. We don't want the vmemmap of online
 	 *    memory blocks to reside on offline memory blocks. In the future,
 	 *    we might want to support variable-sized memory blocks to make the
@@ -1123,7 +1123,7 @@ bool mhp_supports_memmap_on_memory(unsig
 	       IS_ENABLED(CONFIG_MHP_MEMMAP_ON_MEMORY) &&
 	       size == memory_block_size_bytes() &&
 	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
-	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
+	       IS_ALIGNED(remaining_size, pageblock_nr_pages << PAGE_SHIFT);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

