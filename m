Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A00C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 22:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJRWRM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJRWRC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 18:17:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6FD102F
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 15:17:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D6FAB82173
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 22:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C10C433C1;
        Tue, 18 Oct 2022 22:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666131419;
        bh=cjW25ku+rro0ebBy3rmjl54WCNSrv0Rs8llOufegkRQ=;
        h=Date:To:From:Subject:From;
        b=is7/wmJIN9s8X5uGrci0EN+WiiNIrYm2l5WjEdfeMzpDUmUu+X/TWB+gC/yPf0cDW
         WE66Tdgq+6J0JvdWcyLJ3vxeAADQVGfHWEUM+GZSwY3e2CVhs4RRYcwMUYizB2Lus8
         87YRVRTBwjyM2QrNiWa17mUIeDvLSV5WCAJhL+T8=
Date:   Tue, 18 Oct 2022 15:16:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@infradead.org, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-trace_alloc_vmap_area-event.patch added to mm-unstable branch
Message-Id: <20221018221659.31C10C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: use trace_alloc_vmap_area event
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-use-trace_alloc_vmap_area-event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-trace_alloc_vmap_area-event.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: use trace_alloc_vmap_area event
Date: Tue, 18 Oct 2022 20:10:50 +0200

This is for debug purpose and is called when an allocation attempt occurs.
This event gives some information about:

- start address of allocated area;
- size that is requested;
- alignment that is required;
- vstart/vend restriction;
- if an allocation fails.

Link: https://lkml.kernel.org/r/20221018181053.434508-5-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-use-trace_alloc_vmap_area-event
+++ a/mm/vmalloc.c
@@ -43,6 +43,9 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/vmalloc.h>
+
 #include "internal.h"
 #include "pgalloc-track.h"
 
@@ -1620,6 +1623,8 @@ retry:
 		size, align, vstart, vend);
 	spin_unlock(&free_vmap_area_lock);
 
+	trace_alloc_vmap_area(addr, size, align, vstart, vend, addr == vend);
+
 	/*
 	 * If an allocation fails, the "vend" address is
 	 * returned. Therefore trigger the overflow path.
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-alloc_vmap_area-trace-event.patch
mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch
mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch
mm-vmalloc-use-trace_alloc_vmap_area-event.patch
mm-vmalloc-use-trace_purge_vmap_area_lazy-event.patch
mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch
vmalloc-add-reviewers-for-vmalloc-code.patch

