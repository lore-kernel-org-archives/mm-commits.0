Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC41C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiJCVPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiJCVNq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FED53D1F
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB223B81122
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D589C433D6;
        Mon,  3 Oct 2022 21:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831319;
        bh=WyI2J83F3sDzAvFLeEazI1PICsM9lnYdKuJ8k07WD+o=;
        h=Date:To:From:Subject:From;
        b=yk0B6EZCt332NJoWf0dw/+J/W2SHQ43h2eoxsAmLOEeaTEj+KSj+pNUk41BXQE0bu
         UHHaqq8o0NhJ36Y+j2qgYctG9KsgKaugITyYoAePlBrP6EV/FfkJEkejXJWXzm2Flx
         E/fHaEdbtzznkhZJQcTdQBTtElc3KAVqC2p8WazY=
Date:   Mon, 03 Oct 2022 14:08:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, vegard.nossum@oracle.com, vbabka@suse.cz,
        tglx@linutronix.de, sfr@canb.auug.org.au, rostedt@goodmis.org,
        rientjes@google.com, pmladek@suse.com, peterz@infradead.org,
        penberg@kernel.org, mst@redhat.com, mingo@redhat.com,
        mark.rutland@arm.com, luto@kernel.org, keescook@chromium.org,
        iii@linux.ibm.com, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, gor@linux.ibm.com, elver@google.com,
        edumazet@google.com, ebiggers@kernel.org, ebiggers@google.com,
        dvyukov@google.com, cl@linux.com, bp@alien8.de, axboe@kernel.dk,
        ast@kernel.org, arnd@arndb.de, andreyknvl@google.com,
        andreyknvl@gmail.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] virtio-kmsan-check-unpoison-scatterlist-in-vring_map_one_sg.patch removed from -mm tree
Message-Id: <20221003210839.7D589C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: virtio: kmsan: check/unpoison scatterlist in vring_map_one_sg()
has been removed from the -mm tree.  Its filename was
     virtio-kmsan-check-unpoison-scatterlist-in-vring_map_one_sg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: virtio: kmsan: check/unpoison scatterlist in vring_map_one_sg()
Date: Thu, 15 Sep 2022 17:03:56 +0200

If vring doesn't use the DMA API, KMSAN is unable to tell whether the
memory is initialized by hardware.  Explicitly call kmsan_handle_dma()
from vring_map_one_sg() in this case to prevent false positives.

Link: https://lkml.kernel.org/r/20220915150417.722975-23-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_ring.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/virtio/virtio_ring.c~virtio-kmsan-check-unpoison-scatterlist-in-vring_map_one_sg
+++ a/drivers/virtio/virtio_ring.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/hrtimer.h>
 #include <linux/dma-mapping.h>
+#include <linux/kmsan.h>
 #include <linux/spinlock.h>
 #include <xen/xen.h>
 
@@ -352,8 +353,15 @@ static dma_addr_t vring_map_one_sg(const
 				   struct scatterlist *sg,
 				   enum dma_data_direction direction)
 {
-	if (!vq->use_dma_api)
+	if (!vq->use_dma_api) {
+		/*
+		 * If DMA is not used, KMSAN doesn't know that the scatterlist
+		 * is initialized by the hardware. Explicitly check/unpoison it
+		 * depending on the direction.
+		 */
+		kmsan_handle_dma(sg_page(sg), sg->offset, sg->length, direction);
 		return (dma_addr_t)sg_phys(sg);
+	}
 
 	/*
 	 * We can't use dma_map_sg, because we don't use scatterlists in
_

Patches currently in -mm which might be from glider@google.com are


