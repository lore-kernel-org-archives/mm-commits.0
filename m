Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208FEC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED8D2145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881604;
	bh=qJ47oxUfBqSTQ5V/zPjftcMFfDwbqmzJa+0CEbdF6zc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pRmEoitWBmmXG/bAIVHSK7iHb3UZat+CAseu52ZhmyhD01xdqNuqZJXywk616zlKq
	 J711I2xasLYqySCyUacFHKQlbWUrsMEJl1odinoQMY1LH3foq8gVOA4w2m779YqDdN
	 DTxbZQw3VYISsNKgakR7FSSH7oC95feQEh11We98=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409128AbgJPUxY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409125AbgJPUxY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 907CE205CB;
        Fri, 16 Oct 2020 20:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881603;
        bh=qJ47oxUfBqSTQ5V/zPjftcMFfDwbqmzJa+0CEbdF6zc=;
        h=Date:From:To:Subject:From;
        b=SnmCu+2B2TpICnqr2dbrfzv3qtLa48xBaqXvasz993n23neb+2JTn5KoLuxm305ue
         wUuAJ5SQP+TtJIT7BzWknL+vdmqlMHWkej5sxTC5c7XdrQ8AwAFNwxjqwg8lHm/4+m
         Qd9V4dJYO8oshxrFW7roYmgCb7lxpfiarPEgqWH4=
Date:   Fri, 16 Oct 2020 13:53:23 -0700
From:   akpm@linux-foundation.org
To:     christophe.jaillet@wanadoo.fr, mm-commits@vger.kernel.org
Subject:  [merged] lib-scatterlist-avoid-a-double-memset.patch
 removed from -mm tree
Message-ID: <20201016205323.XBOwBPL99%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist.c: avoid a double memset
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-avoid-a-double-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


