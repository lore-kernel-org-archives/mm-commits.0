Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAA4C433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AC4C2220B
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976550;
	bh=ai6/wwi6ZB6vRfjnPSuyHr3k6uaFaU2w0hKOQtRxEvE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BTVaX+qrQYbxOyNedLe5ZfjNXSRQyaEqC6TXOHuhOAnLKPpYlXXMhHL/OYvYhZAoq
	 go8JBgkfGHA66cLEnj/Q871v/HSTFcjcOfxqt5mdiiKdeBTZTZ3jAOf9BmLLFmb60k
	 XlMwbGQDyAe0J5g4ei9GomdQGI2L2xtQzMEHOImc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439922AbgJQXPu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXPt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:15:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A4BE21655;
        Sat, 17 Oct 2020 23:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976547;
        bh=ai6/wwi6ZB6vRfjnPSuyHr3k6uaFaU2w0hKOQtRxEvE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BzvEL7k10+paYEqGTvkU6HpTXXkNKGQxiCiV2E9C44jHo1jcgLyoSzZaHngXDvABl
         Z4Pr8uyNr/mxU6jejpPRqpQ2vl3Bg8GBbRvSNJMLLqGPnS1xqQrJUHwo458jzFZuas
         uSL22Rr40RXJVB8lm3Gc7HaLfLEeyy/hSUtaxQ/E=
Date:   Sat, 17 Oct 2020 16:15:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        urezki@gmail.com
Subject:  [patch 39/40] mm: remove the filename in the top of file
 comment in vmalloc.c
Message-ID: <20201017231546.XUjfSDW_s%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove the filename in the top of file comment in vmalloc.c

No point in having the filename inside the file.

Link: https://lkml.kernel.org/r/20201002124035.1539300-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmalloc.c~mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc
+++ a/mm/vmalloc.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/mm/vmalloc.c
- *
  *  Copyright (C) 1993  Linus Torvalds
  *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
  *  SMP-safe vmalloc/vfree/ioremap, Tigran Aivazian <tigran@veritas.com>, May 2000
_
