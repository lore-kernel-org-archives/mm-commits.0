Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CC5C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Dec 2022 21:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiLVVjH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Dec 2022 16:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiLVVjA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Dec 2022 16:39:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1617C23316
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 13:39:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B6BDCE1BE6
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 21:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4B3C433D2;
        Thu, 22 Dec 2022 21:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671745136;
        bh=fj+BGzAexL8YTrKKrPl16xcfolVrkAO5VZCSMt+TaHY=;
        h=Date:To:From:Subject:From;
        b=BKsNykH/65wGIQ6qnURVii81i7+C2ou+WiHBkgw0BhVsoOEnlT7l1776lwTJ6iZ+z
         CgoAAo3ySsJfZqb2LPAVTn23Cz/CkfZ8P39O5R/ZVhRxznKl06ncV6Z7HQTVGttVIh
         nu7pzbq3cwmu6H7kaDeuo4J0aUG/qj8LwjDCsuBY=
Date:   Thu, 22 Dec 2022 13:38:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        roman.gushchin@linux.dev, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, lstoakes@gmail.com, hch@lst.de,
        hch@infradead.org, bhe@redhat.com, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch added to mm-unstable branch
Message-Id: <20221222213856.8C4B3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: switch to find_unlink_vmap_area() in vm_unmap_ram()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch

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
mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch
mm-vmalloc-replace-bug_on-by-warn_on_once.patch

