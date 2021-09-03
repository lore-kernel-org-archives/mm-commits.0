Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A23C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E736113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350130AbhICVAh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350144AbhICVAf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E1DF61107;
        Fri,  3 Sep 2021 20:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702775;
        bh=i6uT+fjTaYlrtoHQD3lKfrT+oGsisnCyvhkrQg2Q/EA=;
        h=Date:From:To:Subject:From;
        b=W3olY4YWIZ97FsTVV37Fr40Usdb4PsmEDwqudMn1cH4BRgYmPZLZJOhuNoUPvEt/T
         xDUUhiNOZHgPPdVS5oc29Ugc2NODZ2zxoLJkhmM7xz1gfsEynWakOLssGIfORpx1DR
         a2U+3dauuZlsoP6VyKjAshc29iDR/FxMGASxsacE=
Date:   Fri, 03 Sep 2021 13:59:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, monstr@monstr.eu, rppt@linux.ibm.com
Subject:  [merged] memblock-stop-poisoning-raw-allocations.patch
 removed from -mm tree
Message-ID: <20210903205935.a5emgGl6j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: stop poisoning raw allocations
has been removed from the -mm tree.  Its filename was
     memblock-stop-poisoning-raw-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1491,18 +1491,12 @@ void * __init memblock_alloc_exact_nid_r
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
@@ -1529,18 +1523,12 @@ void * __init memblock_alloc_try_nid_raw
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

mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

