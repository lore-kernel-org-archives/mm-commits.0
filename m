Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135A2C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiLAAHp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiLAAFr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:05:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24119454F
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0D9F61E88
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2FDC433D7;
        Thu,  1 Dec 2022 00:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852937;
        bh=7ZkkHbxo7RNpDM7yPdZSulYJrI14I6m0Ze0eYYcbx+Q=;
        h=Date:To:From:Subject:From;
        b=zOgLWX3RtrV9SY9D+8rZ4oXmctHk6DAsrG9tXhL6rKPMlsX/DxdLDSD5Iaz1Yvexc
         ceRl2U3diLBM7mPP0f4+fxLSuiKC14GdU5rv/tD4F70b6E0dHKeQarFvPrDa8wIiBg
         0svusR2L8hGfWIbKyqsKH5QSe7SFATiMHBy8kk6Y=
Date:   Wed, 30 Nov 2022 16:02:17 -0800
To:     mm-commits@vger.kernel.org, mchehab@kernel.org,
        hverkuil-cisco@xs4all.nl, daniel.vetter@ffwll.ch, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] media-videobuf-dma-sg-remove-foll_force-usage.patch removed from -mm tree
Message-Id: <20221201000217.CB2FDC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: media: videobuf-dma-sg: remove FOLL_FORCE usage
has been removed from the -mm tree.  Its filename was
     media-videobuf-dma-sg-remove-foll_force-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: media: videobuf-dma-sg: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:52 +0100

GUP now supports reliable R/O long-term pinning in COW mappings, such
that we break COW early. MAP_SHARED VMAs only use the shared zeropage so
far in one corner case (DAXFS file with holes), which can be ignored
because GUP does not support long-term pinning in fsdax (see
check_vma_flags()).

Consequently, FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM is no longer required
for reliable R/O long-term pinning: FOLL_LONGTERM is sufficient. So stop
using FOLL_FORCE, which is really only for ptrace access.

Link: https://lkml.kernel.org/r/20221116102659.70287-14-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/v4l2-core/videobuf-dma-sg.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~media-videobuf-dma-sg-remove-foll_force-usage
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -151,17 +151,16 @@ static void videobuf_dma_init(struct vid
 static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 			int direction, unsigned long data, unsigned long size)
 {
+	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long first, last;
-	int err, rw = 0;
-	unsigned int flags = FOLL_FORCE;
+	int err;
 
 	dma->direction = direction;
 	switch (dma->direction) {
 	case DMA_FROM_DEVICE:
-		rw = READ;
+		gup_flags |= FOLL_WRITE;
 		break;
 	case DMA_TO_DEVICE:
-		rw = WRITE;
 		break;
 	default:
 		BUG();
@@ -177,14 +176,11 @@ static int videobuf_dma_init_user_locked
 	if (NULL == dma->pages)
 		return -ENOMEM;
 
-	if (rw == READ)
-		flags |= FOLL_WRITE;
-
 	dprintk(1, "init user [0x%lx+0x%lx => %lu pages]\n",
 		data, size, dma->nr_pages);
 
-	err = pin_user_pages(data & PAGE_MASK, dma->nr_pages,
-			     flags | FOLL_LONGTERM, dma->pages, NULL);
+	err = pin_user_pages(data & PAGE_MASK, dma->nr_pages, gup_flags,
+			     dma->pages, NULL);
 
 	if (err != dma->nr_pages) {
 		dma->nr_pages = (err >= 0) ? err : 0;
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

