Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF61C3DA7A
	for <mm-commits@archiver.kernel.org>; Thu, 29 Dec 2022 23:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiL2XO5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Dec 2022 18:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiL2XOz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2022 18:14:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B45CFF5
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 15:14:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED6F561978
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 23:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504D6C433EF;
        Thu, 29 Dec 2022 23:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672355692;
        bh=vG5M2XLwlhDcFPCi30cxaY31PPFJf/3kDwIUlulmkb8=;
        h=Date:To:From:Subject:From;
        b=yA+/cQVmXT48gKS+KQSNbHw5pfXI/c3A/OK3bRkxRpdjJQ16G5YmD/Jz+6QMTeWMA
         PSzveFXzGxdp1mlSRGVEmFLEzvtvHGQujYZKy8Hi/lXUIHQkm9KV6wFRfVEryvXRJF
         IrgqPhh8cBrg47tzLeU3/An7GHvw1WvI3T1aMLpI=
Date:   Thu, 29 Dec 2022 15:14:51 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        roman.gushchin@linux.dev, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, lstoakes@gmail.com, hch@lst.de,
        hch@infradead.org, bhe@redhat.com, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch removed from -mm tree
Message-Id: <20221229231452.504D6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: switch to find_unlink_vmap_area() in vm_unmap_ram()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch

This patch was dropped because it was folded into mm-vmalloc-avoid-calling-__find_vmap_area-twice-in-__vunmap.patch

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: switch to find_unlink_vmap_area() in vm_unmap_ram()
Date: Thu, 22 Dec 2022 20:00:21 +0100

Switch from find_vmap_area() to find_unlink_vmap_area() to prevent a
double access to the vmap_area_lock: one for finding area, second time is
for unlinking from a tree.

Link: https://lkml.kernel.org/r/20221222190022.134380-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram
+++ a/mm/vmalloc.c
@@ -2252,7 +2252,7 @@ void vm_unmap_ram(const void *mem, unsig
 		return;
 	}
 
-	va = find_vmap_area(addr);
+	va = find_unlink_vmap_area(addr);
 	BUG_ON(!va);
 	debug_check_no_locks_freed((void *)va->va_start,
 				    (va->va_end - va->va_start));
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-avoid-calling-__find_vmap_area-twice-in-__vunmap.patch
mm-vmalloc-replace-bug_on-by-warn_on_once.patch

