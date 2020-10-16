Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9351FC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48257208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817789;
	bh=Z6Hi46+lEPeVQixuUHzIPW4fj6Pk/0u/FRrRqtIm+A8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=cE4tiCstjhPVMC/v9ra1HOg+TV9RUNhitgnTCxuvjFknhdQDbwyLAzJkgml4YyhOT
	 mt7QOGDVGGRzPVoLMLcfwLqYzyZ5YAgwRSYUuVqpZj/5ll1yHQOt547xCYCScZhR1j
	 qjBqS3CitDnyjRJfaEKv2M27tXhb7x9+CoyTbGlA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732985AbgJPDJt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgJPDJs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:09:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFA0320789;
        Fri, 16 Oct 2020 03:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817787;
        bh=Z6Hi46+lEPeVQixuUHzIPW4fj6Pk/0u/FRrRqtIm+A8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U1oDf8Fler5Igy5s9jjsckYGde+pYziXJQJx1aT2cNPgm95xMYTnaHdXFSpfmARue
         S9LdBhAcIfYj/UE6kDEXw31L5+2oc4gUjbKg9Mb3G++KuR5AtaAarqe2vyyegyF+/D
         iwWPEyJz2QVDHNfRxzgx42ZkFBBI7GmUhlVgRMEI=
Date:   Thu, 15 Oct 2020 20:09:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, torvalds@linux-foundation.org,
        yuehaibing@huawei.com
Subject:  [patch 085/156] mm/slab.h: remove duplicate include
Message-ID: <20201016030946.7k2qnBXlh%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/slab.h: remove duplicate include

Remove duplicate header which is included twice.

Link: http://lkml.kernel.org/r/20200818114323.58156-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/slab.h~mm-slab-remove-duplicate-include
+++ a/mm/slab.h
@@ -46,7 +46,6 @@ struct kmem_cache {
 #include <linux/kmemleak.h>
 #include <linux/random.h>
 #include <linux/sched/mm.h>
-#include <linux/kmemleak.h>
 
 /*
  * State of the slab allocator.
_
