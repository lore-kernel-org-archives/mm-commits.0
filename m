Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7917C43219
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiKIBkd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiKIBjR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:39:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EB666C8A
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 104A561820
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCF0C433D6;
        Wed,  9 Nov 2022 01:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957935;
        bh=w8+NYBljBij/AHw+Dm8GnTzOD/mn84JSFBd0a44FnLc=;
        h=Date:To:From:Subject:From;
        b=J/iiKw+HRBA1pmO6dX9KZKhIB+5WWUUuUYwyf/uqXzdiKXfD66/4DZPQt3HXSzviO
         p8lW0UQU9gDXxHXrPlCSOUWk6FBpATaVtd7aqI5xmJLTMgbKfgSB0hFmfMRmHgWK+S
         e6Cgvf/eC3AMCcwhyeBPC2jRVLBsfIq8YwW2jqTQ=
Date:   Tue, 08 Nov 2022 17:38:54 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@lst.de, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-use-trace_alloc_vmap_area-event.patch removed from -mm tree
Message-Id: <20221109013855.6BCF0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: use trace_alloc_vmap_area event
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-trace_alloc_vmap_area-event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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


