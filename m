Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350F0C38142
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjAVBVZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjAVBVY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AFC24497
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80A9060B7F
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52B3C433EF;
        Sun, 22 Jan 2023 01:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350482;
        bh=Dm8hu2EH7vZIotT1qEYklQbx1t3BylNxTP9fNp8JdeQ=;
        h=Date:To:From:Subject:From;
        b=suNVtagQl64EC7QCrVV/CXUGM4Hsb9gPIeRU8pgrd2xMyPt9nNfIOfWUHgOFBQaci
         T8xMBZ6Vj6oyMQqIp7G423kXNqYClRNIqAqJhCxmdxLht7kQrkj6bSYvMD6WPXq3hx
         Roe/Qqw3V5yge2zXfGwQfNKsOy4JmLKeRTB+xGDw=
Date:   Sat, 21 Jan 2023 17:21:22 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch added to mm-unstable branch
Message-Id: <20230122012122.D52B3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: call vfree instead of __vunmap from delayed_vfree_work
has been added to the -mm mm-unstable branch.  Its filename is
     mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm: call vfree instead of __vunmap from delayed_vfree_work
Date: Sat, 21 Jan 2023 08:10:46 +0100

This adds an extra, never taken, in_interrupt() branch, but will allow to
cut down the maze of vfree helpers.

Link: https://lkml.kernel.org/r/20230121071051.1143058-6-hch@lst.de
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work
+++ a/mm/vmalloc.c
@@ -2722,7 +2722,7 @@ static void delayed_vfree_work(struct wo
 	struct llist_node *t, *llnode;
 
 	llist_for_each_safe(llnode, t, llist_del_all(&p->list))
-		__vunmap((void *)llnode, 1);
+		vfree(llnode);
 }
 
 /**
_

Patches currently in -mm which might be from hch@lst.de are

revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use.patch
mm-reject-vmap-with-vm_flush_reset_perms.patch
mm-remove-__vfree.patch
mm-remove-__vfree_deferred.patch
mm-move-vmalloc_init-and-free_work-down-in-vmallocc.patch
mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch
mm-move-__remove_vm_area-out-of-va_remove_mappings.patch
mm-use-remove_vm_area-in-__vunmap.patch
mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch
mm-split-__vunmap.patch
mm-refactor-va_remove_mappings.patch

