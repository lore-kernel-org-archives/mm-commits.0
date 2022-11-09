Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0C2C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiKIB3v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiKIB3t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:29:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D706034E
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:29:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2239061812
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2CFC433C1;
        Wed,  9 Nov 2022 01:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957387;
        bh=ItWw+4JlzFaITYnE5EYB0aVOsiyIGUde/zHyyzoWbkI=;
        h=Date:To:From:Subject:From;
        b=sNNVpHs+r0xtw+gXHc72UCH03SmbY6R83KnuzplBcuP/P7P5d1e9AIxpdvFkBeqkB
         lDmSXOohpZZ1P4AWA6Qhmr5WlWE8vsIu2Pj7qHK4od+MAU1doGnkA5E90kDp5HlLmg
         IFN6Wq3dRMyRZPoBh8pDbSOcUFSWbUepcx6tYoxM=
Date:   Tue, 08 Nov 2022 17:29:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, npiggin@gmail.com, hch@infradead.org,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-use-trace_purge_vmap_area_lazy-event-fix.patch removed from -mm tree
Message-Id: <20221109012947.7D2CFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: simplify return boolean expression
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-trace_purge_vmap_area_lazy-event-fix.patch

This patch was dropped because it was folded into mm-vmalloc-use-trace_purge_vmap_area_lazy-event.patch

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: simplify return boolean expression
Date: Thu, 20 Oct 2022 14:52:47 +0200

A return expression of the __purge_vmap_area_lazy() function can be
simplified.  Basically a boolean expression anyway is converted to boolean
values either to true or false.

Link: https://lkml.kernel.org/r/20221020125247.5053-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-trace_purge_vmap_area_lazy-event-fix
+++ a/mm/vmalloc.c
@@ -1786,7 +1786,7 @@ static bool __purge_vmap_area_lazy(unsig
 
 out:
 	trace_purge_vmap_area_lazy(start, end, num_purged_areas);
-	return num_purged_areas > 0 ? true:false;
+	return num_purged_areas > 0;
 }
 
 /*
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-alloc_vmap_area-trace-event.patch
mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch
mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch
mm-vmalloc-use-trace_alloc_vmap_area-event.patch
mm-vmalloc-use-trace_purge_vmap_area_lazy-event.patch
mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch
vmalloc-add-reviewers-for-vmalloc-code.patch

