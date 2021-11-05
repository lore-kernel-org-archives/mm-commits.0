Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C676FC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6AAD6135E
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhKEUp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232537AbhKEUp5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 515DA61351;
        Fri,  5 Nov 2021 20:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144997;
        bh=jmyhl32xkoAq0TuNyYb3SnywAkRCbzI4LXkENqNH3EU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=X4Omg7Y8PJWQJzen1OxC4tSkM5wxSjQ49zS39uLIktoqOfRa8kBEscF8ZIo/yTMa2
         H4u/iC9dO0w1ApE4gaLwUAKhnxNQrP2xZbdGA8j1NCgE7ISs4dK0dJfiZzX+FBeYxS
         k8hNP8y7UzEwAJW0LAWonmVnC1ueAkDcq7SPWN4o=
Date:   Fri, 05 Nov 2021 13:43:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christophe.leroy@csgroup.eu,
        jgross@suse.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, Shahab.Vahedi@synopsys.com,
        torvalds@linux-foundation.org
Subject:  [patch 165/262] memblock: stop aliasing
 __memblock_free_late with memblock_free_late
Message-ID: <20211105204316.KFtzxQkwE%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: stop aliasing __memblock_free_late with memblock_free_late

memblock_free_late() is a NOP wrapper for __memblock_free_late(), there is
no point to keep this indirection.

Drop the wrapper and rename __memblock_free_late() to
memblock_free_late().

Link: https://lkml.kernel.org/r/20210930185031.18648-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Juergen Gross <jgross@suse.com>
Cc: Shahab Vahedi <Shahab.Vahedi@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    7 +------
 mm/memblock.c            |    8 ++++----
 2 files changed, 5 insertions(+), 10 deletions(-)

--- a/include/linux/memblock.h~memblock-stop-aliasing-__memblock_free_late-with-memblock_free_late
+++ a/include/linux/memblock.h
@@ -133,7 +133,7 @@ void __next_mem_range_rev(u64 *idx, int
 			  struct memblock_type *type_b, phys_addr_t *out_start,
 			  phys_addr_t *out_end, int *out_nid);
 
-void __memblock_free_late(phys_addr_t base, phys_addr_t size);
+void memblock_free_late(phys_addr_t base, phys_addr_t size);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
 static inline void __next_physmem_range(u64 *idx, struct memblock_type *type,
@@ -441,11 +441,6 @@ static inline void *memblock_alloc_node(
 				      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
 }
 
-static inline void memblock_free_late(phys_addr_t base, phys_addr_t size)
-{
-	__memblock_free_late(base, size);
-}
-
 /*
  * Set the allocation direction to bottom-up or top-down.
  */
--- a/mm/memblock.c~memblock-stop-aliasing-__memblock_free_late-with-memblock_free_late
+++ a/mm/memblock.c
@@ -366,14 +366,14 @@ void __init memblock_discard(void)
 		addr = __pa(memblock.reserved.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.reserved.max);
-		__memblock_free_late(addr, size);
+		memblock_free_late(addr, size);
 	}
 
 	if (memblock.memory.regions != memblock_memory_init_regions) {
 		addr = __pa(memblock.memory.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.memory.max);
-		__memblock_free_late(addr, size);
+		memblock_free_late(addr, size);
 	}
 
 	memblock_memory = NULL;
@@ -1589,7 +1589,7 @@ void * __init memblock_alloc_try_nid(
 }
 
 /**
- * __memblock_free_late - free pages directly to buddy allocator
+ * memblock_free_late - free pages directly to buddy allocator
  * @base: phys starting address of the  boot memory block
  * @size: size of the boot memory block in bytes
  *
@@ -1597,7 +1597,7 @@ void * __init memblock_alloc_try_nid(
  * down, but we are still initializing the system.  Pages are released directly
  * to the buddy allocator.
  */
-void __init __memblock_free_late(phys_addr_t base, phys_addr_t size)
+void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 {
 	phys_addr_t cursor, end;
 
_
