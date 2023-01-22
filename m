Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098C7C27C76
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjAVBVU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjAVBVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CEF23660
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 414C060B7A
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E6FC433D2;
        Sun, 22 Jan 2023 01:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350477;
        bh=eOGYLhCc9XQ4eIMBq2NwZ2bFgisQ51sf3en2eY6s8o4=;
        h=Date:To:From:Subject:From;
        b=C7dnrev7MCKE+QfI5aoCWdSJPHCcWh+goK57/PAnekQIs4c8XaSkpCFRLiSkC6sqk
         xImWE07iuT743HMd1dlUfKD6WiBoYyBGTH7XkLQ51HdWLKfNg0oULHDYImI8OTD/QX
         LIELgCoOvWEHaeZp2dIzfYnT3HM3Jqe79RLCfmZw=
Date:   Sat, 21 Jan 2023 17:21:17 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-__vfree.patch added to mm-unstable branch
Message-Id: <20230122012117.92E6FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove __vfree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-__vfree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-__vfree.patch

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
Subject: mm: remove __vfree
Date: Sat, 21 Jan 2023 08:10:43 +0100

__vfree is a subset of vfree that just skips a few checks, and which is
only used by vfree and an error cleanup path.  Fold __vfree into vfree and
switch the only other caller to call vfree() instead.

Link: https://lkml.kernel.org/r/20230121071051.1143058-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-remove-__vfree
+++ a/mm/vmalloc.c
@@ -2801,14 +2801,6 @@ void vfree_atomic(const void *addr)
 	__vfree_deferred(addr);
 }
 
-static void __vfree(const void *addr)
-{
-	if (unlikely(in_interrupt()))
-		__vfree_deferred(addr);
-	else
-		__vunmap(addr, 1);
-}
-
 /**
  * vfree - Release memory allocated by vmalloc()
  * @addr:  Memory base address
@@ -2836,8 +2828,10 @@ void vfree(const void *addr)
 
 	if (!addr)
 		return;
-
-	__vfree(addr);
+	if (unlikely(in_interrupt()))
+		__vfree_deferred(addr);
+	else
+		__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
 
@@ -3104,7 +3098,7 @@ static void *__vmalloc_area_node(struct
 
 	/*
 	 * If not enough pages were obtained to accomplish an
-	 * allocation request, free them via __vfree() if any.
+	 * allocation request, free them via vfree() if any.
 	 */
 	if (area->nr_pages != nr_small_pages) {
 		warn_alloc(gfp_mask, NULL,
@@ -3144,7 +3138,7 @@ static void *__vmalloc_area_node(struct
 	return area->addr;
 
 fail:
-	__vfree(area->addr);
+	vfree(area->addr);
 	return NULL;
 }
 
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

