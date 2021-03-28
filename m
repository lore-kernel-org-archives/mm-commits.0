Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3731C433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 20:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 687C961951
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 20:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhC1UUq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 16:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhC1UUf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 16:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2FD06194A;
        Sun, 28 Mar 2021 20:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616962834;
        bh=RhftaL4Me4aLa6vxLOoN3oIxsl9unpYcNSjlwQ4dgv8=;
        h=Date:From:To:Subject:From;
        b=ySMzgihiCszLzQAOS59ZNGF8V6vxXGjUvAYtWT1C/m/adLRA5JwnQ6NPFF9eClAVS
         KbqrjdA2yBXKVLyQ1hG4xg3b268sQMjkf9osstP5yMrrOgUaAKxo6roGUt9dEGIvnR
         iQm3ioi0W0dEKlMKqhvotjFusAehHaHSiKDWUofU=
Date:   Sun, 28 Mar 2021 13:20:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com
Subject:  + mm-slubc-trivial-typo-fixes.patch added to -mm tree
Message-ID: <20210328202034.MnsV59Tz3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: trivial typo fixes
has been added to the -mm tree.  Its filename is
     mm-slubc-trivial-typo-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slubc-trivial-typo-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slubc-trivial-typo-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -829,7 +829,7 @@ static int check_bytes_and_report(struct
  *
  * 	A. Free pointer (if we cannot overwrite object on free)
  * 	B. Tracking data for SLAB_STORE_USER
- * 	C. Padding to reach required alignment boundary or at mininum
+ * 	C. Padding to reach required alignment boundary or at minimum
  * 		one word if debugging is on to be able to detect writes
  * 		before the word boundary.
  *
@@ -3418,7 +3418,7 @@ static unsigned int slub_min_objects;
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

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
ocfs2-fix-a-typo.patch
mm-slubc-trivial-typo-fixes.patch
mm-kmemleak-fix-a-typo.patch
mm-typo-fix-in-the-file-utilc.patch
lib-fix-a-typo-in-the-file-bchc.patch
lib-genallocc-fix-a-typo.patch
ipc-semc-mundane-typo-fixes.patch
mm-few-spelling-fixes.patch
kernel-fix-a-typo-in-the-file-upc.patch
ipc-semc-couple-of-spelling-fixes.patch

