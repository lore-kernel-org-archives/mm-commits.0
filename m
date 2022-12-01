Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7538C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiLAAID (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiLAAGC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D953F95810
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D2CAB81D81
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A34FC433D6;
        Thu,  1 Dec 2022 00:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852941;
        bh=7S6zgQjR9gslV/HG43TgdAWJggS31lTugL8GlrhZow8=;
        h=Date:To:From:Subject:From;
        b=Pq/u5x8rXvl4CvyGShtKueG3NcjLS3wQP1z18HQEkCUXKD9etjGnUMnzRmrjJ4xEz
         ST3zbzGMkU9/8/YK+td2P1buprVQpyNQfJLG8buhawaPiGZddFeG7on7v4h+LPXKa2
         k4biu1RDIwM3TJLUi0RnhXrCMhDX6/CkBs9c8U4Y=
Date:   Wed, 30 Nov 2022 16:02:20 -0800
To:     mm-commits@vger.kernel.org, tfiga@chromium.org,
        m.szyprowski@samsung.com, mchehab@kernel.org,
        hverkuil-cisco@xs4all.nl, daniel.vetter@ffwll.ch, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-frame-vector-remove-foll_force-usage.patch removed from -mm tree
Message-Id: <20221201000221.5A34FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/frame-vector: remove FOLL_FORCE usage
has been removed from the -mm tree.  Its filename was
     mm-frame-vector-remove-foll_force-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/frame-vector: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:55 +0100

FOLL_FORCE is really only for ptrace access. According to commit
707947247e95 ("media: videobuf2-vmalloc: get_userptr: buffers are always
writable"), get_vaddr_frames() currently pins all pages writable as a
workaround for issues with read-only buffers.

FOLL_FORCE, however, seems to be a legacy leftover as it predates
commit 707947247e95 ("media: videobuf2-vmalloc: get_userptr: buffers are
always writable"). Let's just remove it.

Once the read-only buffer issue has been resolved, FOLL_WRITE could
again be set depending on the DMA direction.

Link: https://lkml.kernel.org/r/20221116102659.70287-17-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Tomasz Figa <tfiga@chromium.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/videobuf2/frame_vector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/common/videobuf2/frame_vector.c~mm-frame-vector-remove-foll_force-usage
+++ a/drivers/media/common/videobuf2/frame_vector.c
@@ -50,7 +50,7 @@ int get_vaddr_frames(unsigned long start
 	start = untagged_addr(start);
 
 	ret = pin_user_pages_fast(start, nr_frames,
-				  FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
+				  FOLL_WRITE | FOLL_LONGTERM,
 				  (struct page **)(vec->ptrs));
 	if (ret > 0) {
 		vec->got_ref = true;
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

