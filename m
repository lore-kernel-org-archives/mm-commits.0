Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EA6C10F1B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbiLUVXq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbiLUVXp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:23:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D310F23167
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:23:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F01D6194E
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31E5C433EF;
        Wed, 21 Dec 2022 21:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657822;
        bh=h3LCvl+kwW1HvJmVgelTXPGDE+1rvtP0L0UD/cqoQ8s=;
        h=Date:To:From:Subject:From;
        b=Cyb19Mpg63s//UEyXA4RqP262ySGd4IINFYc30EVQDdkcKgppAdI17TopxCr6bhJs
         yK8OQLqEIumYY3oAmsss22sOYWn7GzjSHKzPZ9VkPucmPvObf8J3EfdilxHBriCjC5
         B34CyU4ov52ZkEkICrgRUdL+DS8i4dimdhgJql+Q=
Date:   Wed, 21 Dec 2022 13:23:42 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        roman.gushchin@linux.dev, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, lstoakes@gmail.com, hch@infradead.org,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-replace-bug_on-by-warn_on_once.patch added to mm-unstable branch
Message-Id: <20221221212342.C31E5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: replace BUG_ON() by WARN_ON_ONCE()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-replace-bug_on-by-warn_on_once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-replace-bug_on-by-warn_on_once.patch

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
Subject: mm: vmalloc: replace BUG_ON() by WARN_ON_ONCE()
Date: Wed, 21 Dec 2022 18:44:54 +0100

Currently a vm_unmap_ram() functions triggers a BUG() if an area
is not found. Replace it by the WARN_ON_ONCE() error message and
keep machine alive instead of stopping it.

The worst case is a memory leaking.

Link: https://lkml.kernel.org/r/20221221174454.1085130-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-replace-bug_on-by-warn_on_once
+++ a/mm/vmalloc.c
@@ -2252,7 +2252,9 @@ void vm_unmap_ram(const void *mem, unsig
 	}
 
 	va = find_unlink_vmap_area(addr);
-	BUG_ON(!va);
+	if (WARN_ON_ONCE(!va))
+		return;
+
 	debug_check_no_locks_freed((void *)va->va_start,
 				    (va->va_end - va->va_start));
 	free_unmap_vmap_area(va);
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-avoid-of-calling-__find_vmap_area-twise-in-__vunmap.patch
mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch
mm-vmalloc-replace-bug_on-by-warn_on_once.patch

