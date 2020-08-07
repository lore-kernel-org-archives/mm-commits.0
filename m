Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04BBC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB90E22CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781460;
	bh=pxJOMmV1knzbv1HNpoF7dMDRu+moIxTpf4hy2oHL1Hs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Rq/kA+1iy0hzZALPpS7pFtWvC1yRyYA2VVDGIDhoDhGsPUWPV47cxhSdua+sg6bV+
	 Q7DPeGDZLDt0lCWfklElUGd1a8qCPpZgivo46/i0LSfCtuAgF3jA5ZnRqd4vbXyZtE
	 zWeEDYG2xSYZS2z2h/shE2l/DrW7DYu6kGs+dPp8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgHGGYU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgHGGYT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06BBF22C9F;
        Fri,  7 Aug 2020 06:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781459;
        bh=pxJOMmV1knzbv1HNpoF7dMDRu+moIxTpf4hy2oHL1Hs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=diCSfQ7NNGxr1WLS2u8Y/psEEvZacbWW1zaO/aIRujaYbv8/o7A8tjabr53xpHKFa
         icNyn8DU1r04qWpwkh86/UjpLQscsjGMcdicbZl/6vQw/mylChf9hrZXTLCrSUntPH
         jvgFo8efw8XLTwL4p9+uGmEYfXycmR7Hc9Bbtp3Q=
Date:   Thu, 06 Aug 2020 23:24:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        urezki@gmail.com
Subject:  [patch 125/163] mm/vmalloc: update the header about KVA
 rework
Message-ID: <20200807062418.lykuMsXo2%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: update the header about KVA rework

Reflect information about the author, date and year when the KVA rework
was done.

Link: http://lkml.kernel.org/r/20200622195821.4796-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-update-the-header-about-kva-rework
+++ a/mm/vmalloc.c
@@ -7,6 +7,7 @@
  *  SMP-safe vmalloc/vfree/ioremap, Tigran Aivazian <tigran@veritas.com>, May 2000
  *  Major rework to support vmap/vunmap, Christoph Hellwig, SGI, August 2002
  *  Numa awareness, Christoph Lameter, SGI, June 2005
+ *  Improving global KVA allocator, Uladzislau Rezki, Sony, May 2019
  */
 
 #include <linux/vmalloc.h>
_
