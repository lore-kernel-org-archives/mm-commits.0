Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A756C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65EC661C71
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhF2Cl5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhF2Cl5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C45619AB;
        Tue, 29 Jun 2021 02:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934370;
        bh=lGBA3DASshup6k0BgiIFPc1u3mZH04T61JIhNVoKEws=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZCdrS3Gbv6Eru8LsXAVh7LjUxJz29Ls7K+SVYzalzGQBxZH69UaJ/XDLTmlrfco9o
         mFz/nvat6TLMD4eF82wMeuXID/O4Anld4inUYtAGoAlNE6mvj6R5Deo9URIZ0AcfXw
         rnVy7dgprNBfprwk+CqRvz6RvN3z89dQ65mdATOo=
Date:   Mon, 28 Jun 2021 19:39:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 118/192] media: videobuf2: use vma_lookup() in
 get_vaddr_frames()
Message-ID: <20210629023929.rNMRW_3J9%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: media: videobuf2: use vma_lookup() in get_vaddr_frames()

vma_lookup() finds the vma of a specific address with a cleaner interface
and is more readable.

Link: https://lkml.kernel.org/r/20210521174745.2219620-15-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/videobuf2/frame_vector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/common/videobuf2/frame_vector.c~media-videobuf2-use-vma_lookup-in-get_vaddr_frames
+++ a/drivers/media/common/videobuf2/frame_vector.c
@@ -64,7 +64,7 @@ int get_vaddr_frames(unsigned long start
 	do {
 		unsigned long *nums = frame_vector_pfns(vec);
 
-		vma = find_vma_intersection(mm, start, start + 1);
+		vma = vma_lookup(mm, start);
 		if (!vma)
 			break;
 
_
