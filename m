Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B87C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiLAAHx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiLAAFw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:05:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB699950C6
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1320D61E6C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D12FC433D6;
        Thu,  1 Dec 2022 00:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852940;
        bh=o8Uz7vnf4j3+IJ9yOcvk4sm2xbmR18jLlHkVSkKUUWs=;
        h=Date:To:From:Subject:From;
        b=hKaP3KrVgyvxDseviY9ZktIevcUahQZWNFoenLdMN11aWqX2eIWvuXbdMwS8ske8m
         nl59adlGvRogLXpEx9YWbh/LgZttqxktxfb3l1adJYxXgydyqYYuE/AoaFIeFhx8Iw
         5QQO5yXvcup9C45F0iyaK+zzT4Y/g/Gc8dyHz720=
Date:   Wed, 30 Nov 2022 16:02:19 -0800
To:     mm-commits@vger.kernel.org, mchehab@kernel.org,
        hverkuil-cisco@xs4all.nl, awalls@md.metrocast.net,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] media-pci-ivtv-remove-foll_force-usage.patch removed from -mm tree
Message-Id: <20221201000220.2D12FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: media: pci/ivtv: remove FOLL_FORCE usage
has been removed from the -mm tree.  Its filename was
     media-pci-ivtv-remove-foll_force-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: media: pci/ivtv: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:54 +0100

FOLL_FORCE is really only for ptrace access. R/O pinning a page is
supposed to fail if the VMA misses proper access permissions (no VM_READ).

Let's just remove FOLL_FORCE usage here; there would have to be a pretty
good reason to allow arbitrary drivers to R/O pin pages in a PROT_NONE
VMA. Most probably, FOLL_FORCE usage is just some legacy leftover.

Link: https://lkml.kernel.org/r/20221116102659.70287-16-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/ivtv/ivtv-udma.c |    2 +-
 drivers/media/pci/ivtv/ivtv-yuv.c  |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/media/pci/ivtv/ivtv-udma.c~media-pci-ivtv-remove-foll_force-usage
+++ a/drivers/media/pci/ivtv/ivtv-udma.c
@@ -115,7 +115,7 @@ int ivtv_udma_setup(struct ivtv *itv, un
 
 	/* Pin user pages for DMA Xfer */
 	err = pin_user_pages_unlocked(user_dma.uaddr, user_dma.page_count,
-			dma->map, FOLL_FORCE);
+			dma->map, 0);
 
 	if (user_dma.page_count != err) {
 		IVTV_DEBUG_WARN("failed to map user pages, returned %d instead of %d\n",
--- a/drivers/media/pci/ivtv/ivtv-yuv.c~media-pci-ivtv-remove-foll_force-usage
+++ a/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -63,12 +63,11 @@ static int ivtv_yuv_prep_user_dma(struct
 
 	/* Pin user pages for DMA Xfer */
 	y_pages = pin_user_pages_unlocked(y_dma.uaddr,
-			y_dma.page_count, &dma->map[0], FOLL_FORCE);
+			y_dma.page_count, &dma->map[0], 0);
 	uv_pages = 0; /* silence gcc. value is set and consumed only if: */
 	if (y_pages == y_dma.page_count) {
 		uv_pages = pin_user_pages_unlocked(uv_dma.uaddr,
-				uv_dma.page_count, &dma->map[y_pages],
-				FOLL_FORCE);
+				uv_dma.page_count, &dma->map[y_pages], 0);
 	}
 
 	if (y_pages != y_dma.page_count || uv_pages != uv_dma.page_count) {
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

