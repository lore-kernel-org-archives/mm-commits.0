Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38786CDB474
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjJPW11 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjJPW11 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:27:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB24AC
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:27:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F6EC433C7;
        Mon, 16 Oct 2023 22:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697495245;
        bh=OYosnyF77dd0C/fxbca0mUK3leqwkp5YZP2fGozsgfY=;
        h=Date:To:From:Subject:From;
        b=aS4L9OFFeGtrsLzr0hZHP5iBYkTbx1Ea7JQrAcCVltkaAzN3dXZWhZYYVCKiVdgVd
         bhUryKVikIznx6wSOgBIMuB7sUZuDySE3oKlT390xFAWLvzSmau9oCY2NzL2vpBEcd
         Fr2bUbvxgByr9UTuG3cg8CCpEal3P7GumYYzIeTs=
Date:   Mon, 16 Oct 2023 15:27:23 -0700
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, pedro.falcato@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-panic-on-failure-to-allocate-early-boot-metadata.patch added to mm-unstable branch
Message-Id: <20231016222725.56F6EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmsan: panic on failure to allocate early boot metadata
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmsan-panic-on-failure-to-allocate-early-boot-metadata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-panic-on-failure-to-allocate-early-boot-metadata.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mm: kmsan: panic on failure to allocate early boot metadata
Date: Mon, 16 Oct 2023 16:34:46 +0100

Given large enough allocations and a machine with low enough memory (i.e a
default QEMU VM), it's entirely possible that
kmsan_init_alloc_meta_for_range's shadow+origin allocation fails.

Instead of eating a NULL deref kernel oops, check explicitly for
memblock_alloc() failure and panic with a nice error message.

Alexander Potapenko said:

For posterity, it is generally quite important for the allocated shadow
and origin to be contiguous, otherwise an unaligned memory write may
result in memory corruption (the corresponding unaligned shadow write will
be assuming that shadow pages are adjacent).  So instead of panicking we
could have split the range into smaller ones until the allocation
succeeds, but that would've led to hard-to-debug problems in the future.

Link: https://lkml.kernel.org/r/20231016153446.132763-1-pedro.falcato@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/shadow.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/kmsan/shadow.c~mm-kmsan-panic-on-failure-to-allocate-early-boot-metadata
+++ a/mm/kmsan/shadow.c
@@ -285,12 +285,17 @@ void __init kmsan_init_alloc_meta_for_ra
 	size = PAGE_ALIGN((u64)end - (u64)start);
 	shadow = memblock_alloc(size, PAGE_SIZE);
 	origin = memblock_alloc(size, PAGE_SIZE);
+
+	if (!shadow || !origin)
+		panic("%s: Failed to allocate metadata memory for early boot range of size %llu",
+		      __func__, size);
+
 	for (u64 addr = 0; addr < size; addr += PAGE_SIZE) {
 		page = virt_to_page_or_null((char *)start + addr);
-		shadow_p = virt_to_page_or_null((char *)shadow + addr);
+		shadow_p = virt_to_page((char *)shadow + addr);
 		set_no_shadow_origin_page(shadow_p);
 		shadow_page_for(page) = shadow_p;
-		origin_p = virt_to_page_or_null((char *)origin + addr);
+		origin_p = virt_to_page((char *)origin + addr);
 		set_no_shadow_origin_page(origin_p);
 		origin_page_for(page) = origin_p;
 	}
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

mm-kmsan-panic-on-failure-to-allocate-early-boot-metadata.patch

