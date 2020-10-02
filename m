Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA8AC4363D
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37DD420754
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601673471;
	bh=NQBwqOh7tsyY2DWnprTqUgwMbbGbxOao7u9jEFgTMzY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ytk/hkjuWLvFAHy2C2z6CZh1dGP+0L5GdfrRj/QHfmViBEtJ59YKihfPFihxiLTjt
	 v3wChz+e0JCgtdIjNR5rd4IMHt9h6DYW2Yj1Pna7J7oIJokbMnvifdM5oBGsfKGIFc
	 XdpsyLHV2CD/IGbBueEZTsE4nd5E/V7JJXeUc0zk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgJBVRu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:17:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBVRu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:17:50 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4539920796;
        Fri,  2 Oct 2020 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601673470;
        bh=NQBwqOh7tsyY2DWnprTqUgwMbbGbxOao7u9jEFgTMzY=;
        h=Date:From:To:Subject:From;
        b=1MD2hpQSIX2RDO+/33BrIG7y2moFTlN+G18FjCSBZlvIGKL2lEBaW805BDQDWRMZV
         9DKWbBxLvuKm8cXcjpxCpMde45Q57PUylJqrCswgLMIbgLo/ftwVjba936kmd28+fu
         gpIqIbdS2nsSLssVZZ3XqAl+z9xIbM8HnDOuLs3Y=
Date:   Fri, 02 Oct 2020 14:17:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ttayar@habana.ai, tfiga@chromium.org,
        sw0312.kim@samsung.com, ppiskorski@habana.ai, pawel@osciak.com,
        oshpigelman@habana.ai, oded.gabbay@gmail.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        krzk@kernel.org, kgene@kernel.org, jy0922.shim@samsung.com,
        jhubbard@nvidia.com, jglisse@redhat.com, jgg@ziepe.ca,
        jack@suse.cz, inki.dae@samsung.com, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, daniel.vetter@intel.com,
        daniel.vetter@ffwll.ch
Subject:  + mm-frame-vec-use-foll_longterm.patch added to -mm tree
Message-ID: <20201002211748.sPEnI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frame-vec: use FOLL_LONGTERM
has been added to the -mm tree.  Its filename is
     mm-frame-vec-use-foll_longterm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-frame-vec-use-foll_longter=
m.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-frame-vec-use-foll_longter=
m.patch

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

mm-frame-vec-drop-gup_flags-from-get_vaddr_frames.patch
mm-frame-vec-use-foll_longterm.patch

