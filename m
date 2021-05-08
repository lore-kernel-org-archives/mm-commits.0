Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4032DC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2391461421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhEHWlH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWlH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97BB761402;
        Sat,  8 May 2021 22:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513604;
        bh=TZMT8oB3AhwRqmNso11SjOf3jwuhkd+bUdbxKEKNT28=;
        h=Date:From:To:Subject:From;
        b=P4qlyd8cpzXDHv8WevfK6SroUp+0ivwqJILW6ZdTeAzP3U1IkU/2aAj1T+kvj63Zi
         1ksZWzP6Jjy4P+sGNhPW/sEQQXOtrKP+zLxFN8Y9E9MbdHHuoZ1F8GeysA3q8YdC2z
         BorZzM6L3zquBdLjPGdJZbpm4zvvy/+G3Z7j4jRM=
Date:   Sat, 08 May 2021 15:40:04 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com
Subject:  [merged] mm-slubc-trivial-typo-fixes.patch removed from
 -mm tree
Message-ID: <20210508224004.ujmUdFu5S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: trivial typo fixes
has been removed from the -mm tree.  Its filename was
     mm-slubc-trivial-typo-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: mm/slub.c: trivial typo fixes

s/operatios/operations/
s/Mininum/Minimum/
s/mininum/minimum/  ......two different places.

Link: https://lkml.kernel.org/r/20210325044940.14516-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/slub.c~mm-slubc-trivial-typo-fixes
+++ a/mm/slub.c
@@ -3,7 +3,7 @@
  * SLUB: A slab allocator that limits cache line use instead of queuing
  * objects in per cpu and per node lists.
  *
- * The allocator synchronizes using per slab locks or atomic operatios
+ * The allocator synchronizes using per slab locks or atomic operations
  * and only uses a centralized lock to manage a pool of partial slabs.
  *
  * (C) 2007 SGI, Christoph Lameter
@@ -157,7 +157,7 @@ static inline bool kmem_cache_has_cpu_pa
 #undef SLUB_DEBUG_CMPXCHG
 
 /*
- * Mininum number of partial slabs. These will be left on the partial
+ * Minimum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
  */
 #define MIN_PARTIAL 5
@@ -838,7 +838,7 @@ static int check_bytes_and_report(struct
  *
  * 	A. Free pointer (if we cannot overwrite object on free)
  * 	B. Tracking data for SLAB_STORE_USER
- * 	C. Padding to reach required alignment boundary or at mininum
+ *	C. Padding to reach required alignment boundary or at minimum
  * 		one word if debugging is on to be able to detect writes
  * 		before the word boundary.
  *
@@ -3434,7 +3434,7 @@ static unsigned int slub_min_objects;
  *
  * Higher order allocations also allow the placement of more objects in a
  * slab and thereby reduce object handling overhead. If the user has
- * requested a higher mininum order then we start with that one instead of
+ * requested a higher minimum order then we start with that one instead of
  * the smallest order which will fit the object.
  */
 static inline unsigned int slab_order(unsigned int size,
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are


