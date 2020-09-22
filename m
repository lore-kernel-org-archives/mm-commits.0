Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29969C2D0E2
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E43DD221E8
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600804348;
	bh=34y0ebKKViOcrPhCeT9dJdJMLjiiEdYkeyV5mFEqvdU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=j5Elof+Wb+80HSFpaP3sVIre+fHyfeSZhs9VgHsEbxfdYNZGWepx8uvN7H3IuDHJ+
	 2oKh+4yOEEX0B7REze6UuhpBSYsDncD0SVVMZOUdjSrxeSveGmEjEJCstnKp8xAFPv
	 6L5cWja+5OabxmrOhy35MbC7e2fe46PzmnFmm1cY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgIVTw2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 15:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIVTw2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 15:52:28 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF77920888;
        Tue, 22 Sep 2020 19:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600804348;
        bh=34y0ebKKViOcrPhCeT9dJdJMLjiiEdYkeyV5mFEqvdU=;
        h=Date:From:To:Subject:From;
        b=WRMljMdDX2n7becTlHzQLpkD/dK+7Xrnel+6KVKFRlDo5F6PaaKgsfha2i9f4WqLS
         gJa/SPdjJ9wPbY7jou+h7TmjbcQ75/+xbZIE8/KfBYbd24x9y3e3uQ8PfX2LSEwWAj
         0ySZnkn5RxcOnP3ojs6eBt/QcT/was0Bs7YMh8hs=
Date:   Tue, 22 Sep 2020 12:52:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, christophe.jaillet@wanadoo.fr
Subject:  + lib-scatterlist-avoid-a-double-memset.patch added to -mm
 tree
Message-ID: <20200922195227.QYUgH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist.c: avoid a double memset
has been added to the -mm tree.  Its filename is
     lib-scatterlist-avoid-a-double-memset.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlist-avoid-a-double-memset.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlist-avoid-a-double-memset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: lib/scatterlist.c: avoid a double memset

'sgl' is zeroed a few lines below in 'sg_init_table()'. There is no need to
clear it twice.

Remove the redundant initialization.

Link: https://lkml.kernel.org/r/20200920071544.368841-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/scatterlist.c~lib-scatterlist-avoid-a-double-memset
+++ a/lib/scatterlist.c
@@ -504,7 +504,7 @@ struct scatterlist *sgl_alloc_order(unsi
 		nalloc++;
 	}
 	sgl = kmalloc_array(nalloc, sizeof(struct scatterlist),
-			    (gfp & ~GFP_DMA) | __GFP_ZERO);
+			    gfp & ~GFP_DMA);
 	if (!sgl)
 		return NULL;
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

lib-scatterlist-avoid-a-double-memset.patch

