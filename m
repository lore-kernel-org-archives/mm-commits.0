Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC7AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E35F520897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816462;
	bh=VD3ex3mLjmAgY64nrtezcl3M1woBPllcE4OdgogcAn4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xvNZdJmiZ1O9A/F5huseJI3N8kt2jLUQ13zhhLLuPHC7a5b0cMWSkrb/FOlF+kaX9
	 HEhVgOLs6d5jdjlxUnDcxte/ddw7s3pkYeMaJvKEPmWhyfDCkoXyuSmRBLKBWPGIH/
	 e2VYzQn9ZrdpQSejLkoTAwOMtTRuxRnZsV4yvbks=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404350AbgJPCrl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731636AbgJPCrl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:47:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F63C2087D;
        Fri, 16 Oct 2020 02:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816461;
        bh=VD3ex3mLjmAgY64nrtezcl3M1woBPllcE4OdgogcAn4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Jtb1qM+a4aiqxgBEV3LH/6uSRk6AgWczuKanemR29slzpi7n6n2Q7SGW0NTQvs0NG
         AXAuKkv/DxbgMGIMyHpsPAtMy9KWPEvBv+bKXHjqyVh9lcl0Db4G/59sy7WRS/B8wr
         lpb99kbVOcNezJdVXNfdYhPmObJzJkzeHB2YyjRo=
Date:   Thu, 15 Oct 2020 19:47:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 103/156] lib: bitmap: delete duplicated words
Message-ID: <20201016024740.VOPV0Zier%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: bitmap: delete duplicated words

Drop the repeated word "an".

Link: https://lkml.kernel.org/r/20200823040424.25760-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bitmap.c~lib-bitmap-delete-duplicated-words
+++ a/lib/bitmap.c
@@ -23,7 +23,7 @@
 /**
  * DOC: bitmap introduction
  *
- * bitmaps provide an array of bits, implemented using an an
+ * bitmaps provide an array of bits, implemented using an
  * array of unsigned longs.  The number of valid bits in a
  * given bitmap does _not_ need to be an exact multiple of
  * BITS_PER_LONG.
_
