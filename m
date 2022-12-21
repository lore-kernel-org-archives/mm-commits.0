Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB300C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbiLUVXr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbiLUVXp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:23:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCA922B35
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:23:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FA35B81C58
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64D8C433EF;
        Wed, 21 Dec 2022 21:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657820;
        bh=s++tViZGOIVjn+sQLQz9prIr5YVxYpJoV3VN8ewOf/Y=;
        h=Date:To:From:Subject:From;
        b=JE1d3mq/t5CTJDOAwKjLDVCadIyPFGr6cb3BsWnGL0n2xJXUVWfeYGmtAtyKZ6QAM
         5LyHajpHmAEShBh4f37DDAnOyzxgM60lx4b9ZdFcGFggFxiR0pO47pYXTzkZRU06Uf
         5yR5Oy8V0XikD/d5OaSRIq3DRcO5zEhowZ9h/iWc=
Date:   Wed, 21 Dec 2022 13:23:40 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        roman.gushchin@linux.dev, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, lstoakes@gmail.com, hch@infradead.org,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch added to mm-unstable branch
Message-Id: <20221221212340.C64D8C433EF@smtp.kernel.org>
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
Date: Wed, 21 Dec 2022 18:44:53 +0100

Switch from find_vmap_area() to find_unlink_vmap_area() to prevent
a double access to the vmap_area_lock: one for finding area, second
time is for unlinking from a tree.

Link: https://lkml.kernel.org/r/20221221174454.1085130-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram
+++ a/mm/vmalloc.c
@@ -2251,7 +2251,7 @@ void vm_unmap_ram(const void *mem, unsig
 		return;
 	}
 
-	va = find_vmap_area(addr);
+	va = find_unlink_vmap_area(addr);
 	BUG_ON(!va);
 	debug_check_no_locks_freed((void *)va->va_start,
 				    (va->va_end - va->va_start));
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-avoid-of-calling-__find_vmap_area-twise-in-__vunmap.patch
mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch
mm-vmalloc-replace-bug_on-by-warn_on_once.patch

