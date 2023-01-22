Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B196C27C76
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjAVBVS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjAVBVR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0404C24484
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90CF560B42
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA60AC433EF;
        Sun, 22 Jan 2023 01:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350476;
        bh=BeCrb6jgBhnJk0oFQJugdzSyLO/L1q4sqDP0Nyfosg0=;
        h=Date:To:From:Subject:From;
        b=DOOWZCb733CKQpjnlJUPgzjCxXXNjvtuhICzj3DzPFVxR0XHDw6vrCjAChYvSZcaS
         nV1ZhuVNmmaS5BkI9ixf0w1yBvGt5VqJ7FEC7vHCB74JBpXbO4SBRwhqY1eGihsW6E
         P8K3qTQTymZYT680qbtgUNWuTj9TsV83eXLff/L8=
Date:   Sat, 21 Jan 2023 17:21:15 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reject-vmap-with-vm_flush_reset_perms.patch added to mm-unstable branch
Message-Id: <20230122012115.EA60AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reject vmap with VM_FLUSH_RESET_PERMS
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reject-vmap-with-vm_flush_reset_perms.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reject-vmap-with-vm_flush_reset_perms.patch

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
Subject: mm: reject vmap with VM_FLUSH_RESET_PERMS
Date: Sat, 21 Jan 2023 08:10:42 +0100

Patch series "cleanup vfree and vunmap".

This little series untangles the vfree and vunmap code path a bit.


This patch (of 10):

VM_FLUSH_RESET_PERMS is just for use with vmalloc as it is tied to freeing
the underlying pages.

Link: https://lkml.kernel.org/r/20230121071051.1143058-1-hch@lst.de
Link: https://lkml.kernel.org/r/20230121071051.1143058-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-reject-vmap-with-vm_flush_reset_perms
+++ a/mm/vmalloc.c
@@ -2883,6 +2883,9 @@ void *vmap(struct page **pages, unsigned
 
 	might_sleep();
 
+	if (WARN_ON_ONCE(flags & VM_FLUSH_RESET_PERMS))
+		return NULL;
+
 	/*
 	 * Your top guard is someone else's bottom guard. Not having a top
 	 * guard compromises someone else's mappings too.
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

