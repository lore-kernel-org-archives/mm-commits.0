Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4B8C6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjBCGnz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbjBCGmV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0804E234CF
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D90CD61D99
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C916C4339B;
        Fri,  3 Feb 2023 06:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406311;
        bh=v0kGa/6uNVd6gW8nS3xUet7E0qFeOVyAMaHrxgg/l6k=;
        h=Date:To:From:Subject:From;
        b=SJzp9rwrTRtqgzmGj49Go2Q8hwEJEN4q9rLfZ+sYtczo+AHVxBc5wgKQbG2BdY7st
         5HP5sIZEVUMpTKZWa24LSWKfEUDl2QjYjGcJilaHoUjStOVwl2oQIZlHYpx1qlrKkC
         ScLZ+Do/FtWzogSERRGi1qPLqdr67gGg0Sva5zYA=
Date:   Thu, 02 Feb 2023 22:38:30 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, david@redhat.com, andreyknvl@gmail.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-__vfree.patch removed from -mm tree
Message-Id: <20230203063831.3C916C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove __vfree
has been removed from the -mm tree.  Its filename was
     mm-remove-__vfree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-remove-__vfree
+++ a/mm/vmalloc.c
@@ -2786,14 +2786,6 @@ void vfree_atomic(const void *addr)
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
@@ -2821,8 +2813,10 @@ void vfree(const void *addr)
 
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
 
@@ -3089,7 +3083,7 @@ static void *__vmalloc_area_node(struct
 
 	/*
 	 * If not enough pages were obtained to accomplish an
-	 * allocation request, free them via __vfree() if any.
+	 * allocation request, free them via vfree() if any.
 	 */
 	if (area->nr_pages != nr_small_pages) {
 		warn_alloc(gfp_mask, NULL,
@@ -3129,7 +3123,7 @@ static void *__vmalloc_area_node(struct
 	return area->addr;
 
 fail:
-	__vfree(area->addr);
+	vfree(area->addr);
 	return NULL;
 }
 
_

Patches currently in -mm which might be from hch@lst.de are


