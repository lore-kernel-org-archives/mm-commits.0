Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F19C388F7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D70B223EA
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604449670;
	bh=iEULMU/iGwUO/b2n/mNXCOyQtmqYrUY+I1wdDCFgA1w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=kTpjryITXs1fG+0VdqqJabrI0sw+ciezFrDoqet79xvH4K3vGWcPyUduaNb0u53IS
	 J/lb9irkc8OC14oVlSNLrWRt48U3F28RiV68a+jlYJxSd+EH+S1/aIvdt8oqA4pWz2
	 sX5WITxh2veb5z8c1AJHKfTOJ+7/6YcTJbGCPeQ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgKDA1u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:27:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbgKDA1t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 19:27:49 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6F0223EA;
        Wed,  4 Nov 2020 00:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604449669;
        bh=iEULMU/iGwUO/b2n/mNXCOyQtmqYrUY+I1wdDCFgA1w=;
        h=Date:From:To:Subject:From;
        b=XMF6dOA1JjrX/0lNSQXwrwz4Fj5iLYTWv0klooHhCShGLkdMWTWK+xjNk8pzuRsR1
         r89ZQw6X8xj0PRYA7QL8jA7UEMuuEXOZ15IHsq/e07IIGOzLFqDO7CUreBulCQEhIL
         7LSrAH60Ril51Aq7GT4oOrRahWz3VvXEjXeT6CDc=
Date:   Tue, 03 Nov 2020 16:27:48 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hsinhuiwu@gmail.com,
        akpm@linux-foundation.org
Subject:  +
 mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch added to -mm tree
Message-ID: <20201104002748.zXqvg%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     From: Andrew Morton <akpm@linux-foundation.org>
has been added to the -mm tree.  Its filename is
     mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmalloc.c:__vmalloc_area_node(): avoid 32-bit overflow

With a machine with 3 TB (more than 2 TB memory).  If you use vmalloc to
allocate > 2 TB memory, the array_size below will be overflowed.

The array_size is an unsigned int and can only be used to allocate less
than 2 TB memory.  If you pass 2*1028*1028*1024*1024 = 2 * 2^40 in the
argument of vmalloc.  The array_size will become 2*2^31 = 2^32.  The 2^32
cannot be store with a 32 bit integer.

The fix is to change the type of array_size to unsigned long.

[akpm@linux-foundation.org: rework for current mainline]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=210023
Reported-by: <hsinhuiwu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow
+++ a/mm/vmalloc.c
@@ -2461,9 +2461,11 @@ static void *__vmalloc_area_node(struct
 {
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
 	unsigned int nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
-	unsigned int array_size = nr_pages * sizeof(struct page *), i;
+	unsigned long array_size
+	unsigned int i;
 	struct page **pages;
 
+	array_size = (unsigned long)nr_pages * sizeof(struct page *);
 	gfp_mask |= __GFP_NOWARN;
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
 		gfp_mask |= __GFP_HIGHMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

