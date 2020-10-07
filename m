Return-Path: <SRS0=PDaU=DO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D24C4363C
	for <mm-commits@archiver.kernel.org>; Wed,  7 Oct 2020 21:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72BA22087D
	for <mm-commits@archiver.kernel.org>; Wed,  7 Oct 2020 21:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602105216;
	bh=esWGjAnXcUAsub14xfdhxUG9hknEMrEj6ly6Z276DY0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FQmK8mwQYpJcCGjUQk33ofArcR9yO8ZxmKqQKICKGiOQlmV443Wd1QOs4qg6SSLYY
	 00qgeXgwN2O4Gdmo3Nd5pWc9JBWI80MUn9CALwkUe8LziiB1Fcr4NGP4Y7GngvUVls
	 TIMhWPxb+zWm2j328kjj+giVpJyXnRTWeEAhXaLE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgJGVNg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Oct 2020 17:13:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbgJGVNf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Oct 2020 17:13:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 151F82083B;
        Wed,  7 Oct 2020 21:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602105215;
        bh=esWGjAnXcUAsub14xfdhxUG9hknEMrEj6ly6Z276DY0=;
        h=Date:From:To:Subject:From;
        b=jaaXD0huOkEf1cAsClFALJnX1lUOMVa07WrNJgFiPTzBNUi/qfiEfhC9KwYJq/gdj
         jSiRr987beVZGcp1LuAQamhafhLQ7kUFPGEekJNqf/C4qVq9HhfRHuCsrcJRyFQjk0
         ujDb2XZifOkQqH7GKqEZIJXSAH6UGIRpMIS3gBZ8=
Date:   Wed, 07 Oct 2020 14:13:33 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        daniel.vetter@ffwll.ch, daniel.vetter@intel.com,
        gregkh@linuxfoundation.org, inki.dae@samsung.com, jack@suse.cz,
        jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com,
        jy0922.shim@samsung.com, kgene@kernel.org, krzk@kernel.org,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        mm-commits@vger.kernel.org, oded.gabbay@gmail.com,
        oshpigelman@habana.ai, pawel@osciak.com, ppiskorski@habana.ai,
        sw0312.kim@samsung.com, tfiga@chromium.org, ttayar@habana.ai
Subject:  [to-be-updated]
 mm-frame-vec-drop-gup_flags-from-get_vaddr_frames.patch removed from -mm
 tree
Message-ID: <20201007211333.7RdWAY2in%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frame-vec: drop gup_flags from get_vaddr_frames()
has been removed from the -mm tree.  Its filename was
     mm-frame-vec-drop-gup_flags-from-get_vaddr_frames.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
=46rom: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm/frame-vec: drop gup_flags from get_vaddr_frames()

FOLL_WRITE | FOLL_FORCE is really the only reasonable thing to do for
simple dma device that can't guarantee write protection.  Which is also
what all the callers are using.

So just simplify this.

Link: https://lkml.kernel.org/r/20201002175303.390363-1-daniel.vetter@ffwll=
.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Acked-by: Tomasz Figa <tfiga@chromium.org>	[drivers/media/common/videobuf2/]
Acked-by: Oded Gabbay <oded.gabbay@gmail.com>	[drivers/misc/habanalabs]
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Omer Shpigelman <oshpigelman@habana.ai>
Cc: Tomer Tayar <ttayar@habana.ai>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pawel Piskorski <ppiskorski@habana.ai>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/exynos/exynos_drm_g2d.c           |    3 +--
 drivers/media/common/videobuf2/videobuf2-memops.c |    3 +--
 drivers/misc/habanalabs/common/memory.c           |    3 +--
 include/linux/mm.h                                |    2 +-
 mm/frame_vector.c                                 |    4 ++--
 5 files changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c~mm-frame-vec-drop-gup_flags-f=
rom-get_vaddr_frames
+++ a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -480,8 +480,7 @@ static dma_addr_t *g2d_userptr_get_dma_a
 		goto err_free;
 	}
=20
-	ret =3D get_vaddr_frames(start, npages, FOLL_FORCE | FOLL_WRITE,
-		g2d_userptr->vec);
+	ret =3D get_vaddr_frames(start, npages, g2d_userptr->vec);
 	if (ret !=3D npages) {
 		DRM_DEV_ERROR(g2d->dev,
 			      "failed to get user pages from userptr.\n");
--- a/drivers/media/common/videobuf2/videobuf2-memops.c~mm-frame-vec-drop-g=
up_flags-from-get_vaddr_frames
+++ a/drivers/media/common/videobuf2/videobuf2-memops.c
@@ -40,7 +40,6 @@ struct frame_vector *vb2_create_framevec
 	unsigned long first, last;
 	unsigned long nr;
 	struct frame_vector *vec;
-	unsigned int flags =3D FOLL_FORCE | FOLL_WRITE;
=20
 	first =3D start >> PAGE_SHIFT;
 	last =3D (start + length - 1) >> PAGE_SHIFT;
@@ -48,7 +47,7 @@ struct frame_vector *vb2_create_framevec
 	vec =3D frame_vector_create(nr);
 	if (!vec)
 		return ERR_PTR(-ENOMEM);
-	ret =3D get_vaddr_frames(start & PAGE_MASK, nr, flags, vec);
+	ret =3D get_vaddr_frames(start & PAGE_MASK, nr, vec);
 	if (ret < 0)
 		goto out_destroy;
 	/* We accept only complete set of PFNs */
--- a/drivers/misc/habanalabs/common/memory.c~mm-frame-vec-drop-gup_flags-f=
rom-get_vaddr_frames
+++ a/drivers/misc/habanalabs/common/memory.c
@@ -1287,8 +1287,7 @@ static int get_user_memory(struct hl_dev
 		return -ENOMEM;
 	}
=20
-	rc =3D get_vaddr_frames(start, npages, FOLL_FORCE | FOLL_WRITE,
-				userptr->vec);
+	rc =3D get_vaddr_frames(start, npages, userptr->vec);
=20
 	if (rc !=3D npages) {
 		dev_err(hdev->dev,
--- a/include/linux/mm.h~mm-frame-vec-drop-gup_flags-from-get_vaddr_frames
+++ a/include/linux/mm.h
@@ -1757,7 +1757,7 @@ struct frame_vector {
 struct frame_vector *frame_vector_create(unsigned int nr_frames);
 void frame_vector_destroy(struct frame_vector *vec);
 int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
-		     unsigned int gup_flags, struct frame_vector *vec);
+		     struct frame_vector *vec);
 void put_vaddr_frames(struct frame_vector *vec);
 int frame_vector_to_pages(struct frame_vector *vec);
 void frame_vector_to_pfns(struct frame_vector *vec);
--- a/mm/frame_vector.c~mm-frame-vec-drop-gup_flags-from-get_vaddr_frames
+++ a/mm/frame_vector.c
@@ -12,7 +12,6 @@
  * get_vaddr_frames() - map virtual addresses to pfns
  * @start:	starting user address
  * @nr_frames:	number of pages / pfns from start to map
- * @gup_flags:	flags modifying lookup behaviour
  * @vec:	structure which receives pages / pfns of the addresses mapped.
  *		It should have space for at least nr_frames entries.
  *
@@ -32,10 +31,11 @@
  * This function takes care of grabbing mmap_lock as necessary.
  */
 int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
-		     unsigned int gup_flags, struct frame_vector *vec)
+		     struct frame_vector *vec)
 {
 	struct mm_struct *mm =3D current->mm;
 	struct vm_area_struct *vma;
+	unsigned int gup_flags =3D FOLL_WRITE | FOLL_FORCE;
 	int ret =3D 0;
 	int err;
 	int locked;
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are

mm-frame-vec-use-foll_longterm.patch

