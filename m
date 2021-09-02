Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA5AC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE0E6610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347719AbhIBV7U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347884AbhIBV7E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91F7960E8B;
        Thu,  2 Sep 2021 21:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619885;
        bh=Og+GOAuj7voyhARj/SgfS/eHJXHoF9ZLFY7U8V/7uVI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0On6S6eErRZH+Cr4An+dmcdMyZ/FyEQrNpiHKnQ40Qj2Pdkpq9QOrPLMkHP9ZRojd
         3cvymsrmkqCBXrWL3NzYaudM86d0qgcryWO5sUZzG4dCxOTZkfl2uNN5BRXYkKirEi
         faBMdrD3+K56yrVKCgRGNmFp3di/n1kAbJVTYC1c=
Date:   Thu, 02 Sep 2021 14:58:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, monstr@monstr.eu, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 153/212] memblock: stop poisoning raw allocations
Message-ID: <20210902215805.Bc3UTOsY9%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
