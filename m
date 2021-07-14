Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF27C12002
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 23:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D452613BA
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 23:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbhGNXOU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhGNXOU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 19:14:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88444613BA;
        Wed, 14 Jul 2021 23:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626304287;
        bh=fQIzIK8yCCGrIL/sOPsmi0dMM3ffE4oU3dx/7bto9CM=;
        h=Date:From:To:Subject:From;
        b=TQ8hx3505Fbqd09lW0poHtsWoRQYPAsNIYyzT1JLDcJQBglbEqqu2GFlEjs8nRPWZ
         GgxCfBqhqUYITujGZBCtodRyBHE1Z8q08vAEYTDmZzYbOyGU8lOTmFf6x3w4uKshXx
         6BEl+o4mvwt9+vRCnTQ3cedGsvOpoz7Bp48qQr08=
Date:   Wed, 14 Jul 2021 16:11:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, monstr@monstr.eu, rppt@linux.ibm.com
Subject:  + memblock-stop-poisoning-raw-allocations.patch added to
 -mm tree
Message-ID: <20210714231127.Dan5RRdYW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: stop poisoning raw allocations
has been added to the -mm tree.  Its filename is
     memblock-stop-poisoning-raw-allocations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-stop-poisoning-raw-allocations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-stop-poisoning-raw-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: stop poisoning raw allocations

Functions memblock_alloc_exact_nid_raw() and memblock_alloc_try_nid_raw()
are intended for early memory allocation without overhead of zeroing the
allocated memory.  Since these functions were used to allocate the memory
map, they have ended up with addition of a call to page_init_poison() that
poisoned the allocated memory when CONFIG_PAGE_POISON was set.

Since the memory map is allocated using a dedicated memmep_alloc()
function that takes care of the poisoning, remove page poisoning from the
memblock_alloc_*_raw() functions.

Link: https://lkml.kernel.org/r/20210714123739.16493-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/mm/memblock.c~memblock-stop-poisoning-raw-allocations
+++ a/mm/memblock.c
@@ -1490,18 +1490,12 @@ void * __init memblock_alloc_exact_nid_r
 			phys_addr_t min_addr, phys_addr_t max_addr,
 			int nid)
 {
-	void *ptr;
-
 	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa %pS\n",
 		     __func__, (u64)size, (u64)align, nid, &min_addr,
 		     &max_addr, (void *)_RET_IP_);
 
-	ptr = memblock_alloc_internal(size, align,
-					   min_addr, max_addr, nid, true);
-	if (ptr && size > 0)
-		page_init_poison(ptr, size);
-
-	return ptr;
+	return memblock_alloc_internal(size, align, min_addr, max_addr, nid,
+				       true);
 }
 
 /**
@@ -1528,18 +1522,12 @@ void * __init memblock_alloc_try_nid_raw
 			phys_addr_t min_addr, phys_addr_t max_addr,
 			int nid)
 {
-	void *ptr;
-
 	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa %pS\n",
 		     __func__, (u64)size, (u64)align, nid, &min_addr,
 		     &max_addr, (void *)_RET_IP_);
 
-	ptr = memblock_alloc_internal(size, align,
-					   min_addr, max_addr, nid, false);
-	if (ptr && size > 0)
-		page_init_poison(ptr, size);
-
-	return ptr;
+	return memblock_alloc_internal(size, align, min_addr, max_addr, nid,
+				       false);
 }
 
 /**
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-page_alloc-always-initialize-memory-map-for-the-holes.patch
microblaze-simplify-pte_alloc_one_kernel.patch
mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch
memblock-stop-poisoning-raw-allocations.patch
mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

