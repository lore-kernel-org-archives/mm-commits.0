Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3E1C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79D8D64FBA
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhCKAvO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhCKAu5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 19:50:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA0EF64F7B;
        Thu, 11 Mar 2021 00:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615423856;
        bh=PrJHJY1ahXzDW3DIqoVGauX5nlNpulZWUwNT7lrVesM=;
        h=Date:From:To:Subject:From;
        b=P8XqQ3lz5cOpSZ5nnJBM7KER6V+4owpxNAhsKU+VvCWzTaUoUD+BzciwmVdiBFzCT
         bnaioEy8tatr0GLItZZkgMUnskUNpLa7kCmXDqEBskIQkTFHoC98X8vGiV0VMGfxem
         woVEK7DnIm6iUyAeW94WduSgh4JhD5J5WjcZnllY=
Date:   Wed, 10 Mar 2021 16:50:55 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  +
 mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
 added to -mm tree
Message-ID: <20210311005055.fR-mgId1r%akpm@linux-foundation.org>
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

reflow comment

Cc: Oscar Salvador <osalvador@suse.de>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix
+++ a/include/linux/mmzone.h
@@ -436,9 +436,9 @@ enum zone_type {
 	 *    situations where ZERO_PAGE(0) which is allocated differently
 	 *    on different platforms may end up in a movable zone. ZERO_PAGE(0)
 	 *    cannot be migrated.
-	 * 7. Memory-hotplug: when using memmap_on_memory and onlining the memory
-	 *    to the MOVABLE zone, the vmemmap pages are also placed in such
-	 *    zone. Such pages cannot be really moved around as they are
+	 * 7. Memory-hotplug: when using memmap_on_memory and onlining the
+	 *    memory to the MOVABLE zone, the vmemmap pages are also placed in
+	 *    such zone. Such pages cannot be really moved around as they are
 	 *    self-stored in the range, but they are treated as movable when
 	 *    the range they describe is about to be offlined.
 	 *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

