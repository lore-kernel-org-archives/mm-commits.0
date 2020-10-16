Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAFBC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 064872087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817887;
	bh=hxnvNzakpN/E/onMQPPqsQ9RGmpoqbeXqOH8F/7juAI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ilGKDHsqNX497pPJb37lBAQRR5RvTIj/yUupDv4v81ZJXp6MHnSwXegnvfev3Ru43
	 fKsrPmM0aUi77L8mu7ME8yjYZAISUs5PKPDXBb+oSoX26quOK8XlkZEiBVhF8cYYDI
	 6aa2O5qEQcBX6zNmHACBUvpx7sy167r2eur7EAVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388422AbgJPDL0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDL0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:11:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC4520789;
        Fri, 16 Oct 2020 03:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817886;
        bh=hxnvNzakpN/E/onMQPPqsQ9RGmpoqbeXqOH8F/7juAI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h/1dFdjae8XYQOZ45+NaAln25KX3YL6RUCR2EZUqOjnyqAORq7Od1y/VxSbOYgCQT
         3Dr7x0gD5CIvCZfuxVG9hBX2tRjezCdqnmAw9YOsiDJrvFjtXafSiimcPTKHX26DcY
         rVxhc9OJGwtAO+cOzbmlpO0K64t3BZWakBgf9vII=
Date:   Thu, 15 Oct 2020 20:11:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christophe.jaillet@wanadoo.fr,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 114/156] lib/scatterlist.c: avoid a double memset
Message-ID: <20201016031125.k1V7RmAWM%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
