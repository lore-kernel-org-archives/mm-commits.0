Return-Path: <SRS0=PDaU=DO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D51EC4363C
	for <mm-commits@archiver.kernel.org>; Wed,  7 Oct 2020 21:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D31572083B
	for <mm-commits@archiver.kernel.org>; Wed,  7 Oct 2020 21:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602105222;
	bh=WbCrxFpassV8MCC65khRWnYCL2/o9aAmK6dpM7Hqz9M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MTxl7DS8cytom4B+6NjQcgzBuIV/FFMAT+iHfOXDks51DzVrsOdCCR4r9cFqeSLLH
	 DGYlaTixYtbTUVSLEwBuscsrpuN5+MpCv9FutBMYIOpCV8nbP4QeT/nc6Od2J0OUVj
	 w++XjN3T3aTc05dPzCEew9wFfpKjHvUIB4nK+XhU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgJGVNm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Oct 2020 17:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbgJGVNj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Oct 2020 17:13:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C99452083B;
        Wed,  7 Oct 2020 21:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602105218;
        bh=WbCrxFpassV8MCC65khRWnYCL2/o9aAmK6dpM7Hqz9M=;
        h=Date:From:To:Subject:From;
        b=FvIHZUf6kxh8FHSCV07C7sNK6lpmRn9pygDGkYSFE2s8KmlZKcQD7Pe5ujl2rhtXA
         tBMIRN44xz97tG+Ms08N3mjU7CAu9wtHIjrNsxFCW6FgsLP1eyTwShu7UUb6VfOhML
         OhVNMkylzFznc/hDzxiAa1aDgJ7hNvIba1PtWCJU=
Date:   Wed, 07 Oct 2020 14:13:37 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, daniel.vetter@ffwll.ch,
        daniel.vetter@intel.com, gregkh@linuxfoundation.org,
        inki.dae@samsung.com, jack@suse.cz, jgg@ziepe.ca,
        jglisse@redhat.com, jhubbard@nvidia.com, jy0922.shim@samsung.com,
        kgene@kernel.org, krzk@kernel.org, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, mm-commits@vger.kernel.org,
        oded.gabbay@gmail.com, oshpigelman@habana.ai, pawel@osciak.com,
        ppiskorski@habana.ai, sw0312.kim@samsung.com, tfiga@chromium.org,
        ttayar@habana.ai
Subject:  [to-be-updated] mm-frame-vec-use-foll_longterm.patch
 removed from -mm tree
Message-ID: <20201007211337.siI4JJF9k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frame-vec: use FOLL_LONGTERM
has been removed from the -mm tree.  Its filename was
     mm-frame-vec-use-foll_longterm.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
=46rom: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm/frame-vec: use FOLL_LONGTERM

For $reasons I've stumbled over this code and I'm not sure the change to
the new gup functions in 55a650c35fea ("mm/gup: frame_vector: convert
get_user_pages() --> pin_user_pages()") was entirely correct.

This here is used for long term buffers (not just quick I/O) like RDMA,
and John notes this in his patch.  But I thought the rule for these is
that they need to add FOLL_LONGTERM, which John's patch didn't do.

There is already a dax specific check (added in b7f0554a56f2 ("mm: fail
get_vaddr_frames() for filesystem-dax mappings")), so this seems like the
prudent thing to do.

Link: https://lkml.kernel.org/r/20201002175303.390363-2-daniel.vetter@ffwll=
.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Omer Shpigelman <oshpigelman@habana.ai>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Pawel Piskorski <ppiskorski@habana.ai>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Tomer Tayar <ttayar@habana.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frame_vector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/frame_vector.c~mm-frame-vec-use-foll_longterm
+++ a/mm/frame_vector.c
@@ -35,7 +35,7 @@ int get_vaddr_frames(unsigned long start
 {
 	struct mm_struct *mm =3D current->mm;
 	struct vm_area_struct *vma;
-	unsigned int gup_flags =3D FOLL_WRITE | FOLL_FORCE;
+	unsigned int gup_flags =3D FOLL_WRITE | FOLL_FORCE | FOLL_LONGTERM;
 	int ret =3D 0;
 	int err;
 	int locked;
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are


