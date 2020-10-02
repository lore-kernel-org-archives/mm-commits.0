Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DA5C35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FF98207EA
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601673469;
	bh=yRGwmaw1uZd40IuDNPeONRMyGFHnfDb4JViLJmNGztw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=kZ1VLrliCPQETm71L6hw5rZqLaY2L/tUmEAJfaSn7XQpIhrpUXaOrFpsIoB3oWBil
	 3zordsSbKOTZTR1uyg72zCPk++LPOPHCCuq6ggFwt7LP2BTaHLos9LE65i6pSU9zsL
	 2ZxD/5wgS8YhCPw2Toyr305eWGDBVPokRlMJUFTo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJBVRs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBVRs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:17:48 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF5B206DD;
        Fri,  2 Oct 2020 21:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601673467;
        bh=yRGwmaw1uZd40IuDNPeONRMyGFHnfDb4JViLJmNGztw=;
        h=Date:From:To:Subject:From;
        b=KEZKtMQMGIu42nhzuFBpKf9fWbxbhDK/9nxhkL+2om9qh42UUnNUKsCxoTu9U65qN
         WeSXRb83jZdxgGN9IoO9A+w9zZlJvp6TX2VjwzjfP1usMYvo41RN/aIZdhzv1lQ2UM
         W3JLa+v1oM0vX5WIei+qeOrd4V16R9yIX1fWjsDQ=
Date:   Fri, 02 Oct 2020 14:17:45 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ttayar@habana.ai, tfiga@chromium.org,
        sw0312.kim@samsung.com, ppiskorski@habana.ai, pawel@osciak.com,
        oshpigelman@habana.ai, oded.gabbay@gmail.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        krzk@kernel.org, kgene@kernel.org, jy0922.shim@samsung.com,
        jhubbard@nvidia.com, jglisse@redhat.com, jgg@ziepe.ca,
        jack@suse.cz, inki.dae@samsung.com, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, daniel.vetter@intel.com,
        akpm@linux-foundation.org, daniel.vetter@ffwll.ch
Subject:  + mm-frame-vec-drop-gup_flags-from-get_vaddr_frames.patch
 added to -mm tree
Message-ID: <20201002211745.o8K6c%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frame-vec: drop gup_flags from get_vaddr_frames()
has been added to the -mm tree.  Its filename is
     mm-frame-vec-drop-gup_flags-from-get_vaddr_frames.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-frame-vec-drop-gup_flags-f=
rom-get_vaddr_frames.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-frame-vec-drop-gup_flags-f=
rom-get_vaddr_frames.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
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

mm-frame-vec-drop-gup_flags-from-get_vaddr_frames.patch
mm-frame-vec-use-foll_longterm.patch

