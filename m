Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D58FC433E3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEEF522C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781349;
	bh=ZKPDNveFMOs5PNNaKoZIbOLuceh7796kjd4EhLCYqY4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=aY3KqmmZqmUcV58ac1KG6qRwNayMtdKasosWylhkvEGsp+2Yq5PZM7gWvICuV5Jem
	 H/BGHJc1G6b9FE7IpF5gf2R0J0Af2aknHuK0kTwdXSni+9jxD8xpW4zTrwFPu1kzRE
	 qxEqesKHxfOPntKFIGi4o59DOewrPruxvK4ZfgQo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgHGGW2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgHGGWZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:22:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6495F2177B;
        Fri,  7 Aug 2020 06:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781345;
        bh=ZKPDNveFMOs5PNNaKoZIbOLuceh7796kjd4EhLCYqY4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2euGcCb0N92qpHG0GSBFy6FzLbMUkXKI9sWd+nA/c4FF1nTOJsZ2aNyTrPbuLw/Qn
         GbxF7j0b03v8NlrJUbOhxtyyvWx4DiEGTUMxvbD2m3rgAVL5LHe6uEFaFRGwCTpRSt
         xFHkOk0MopAxtJTOEdw8vsSMKhlHYDs1yR4SGlxA=
Date:   Thu, 06 Aug 2020 23:22:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zhangalex@google.com
Subject:  [patch 095/163] mm/memory.c: make remap_pfn_range()
 reject unaligned addr
Message-ID: <20200807062224.b7xjNHWMw%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Zhang <zhangalex@google.com>
Subject: mm/memory.c: make remap_pfn_range() reject unaligned addr

This function implicitly assumes that the addr passed in is page aligned. 
A non page aligned addr could ultimately cause a kernel bug in
remap_pte_range as the exit condition in the logic loop may never be
satisfied.  This patch documents the need for the requirement, as well as
explicitly adds a check for it.

Link: http://lkml.kernel.org/r/20200617233512.177519-1-zhangalex@google.com
Signed-off-by: Alex Zhang <zhangalex@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-make-remap_pfn_range-reject-unaligned-addr
+++ a/mm/memory.c
@@ -2082,7 +2082,7 @@ static inline int remap_p4d_range(struct
 /**
  * remap_pfn_range - remap kernel memory to userspace
  * @vma: user vma to map to
- * @addr: target user address to start at
+ * @addr: target page aligned user address to start at
  * @pfn: page frame number of kernel physical memory address
  * @size: size of mapping area
  * @prot: page protection flags for this mapping
@@ -2101,6 +2101,9 @@ int remap_pfn_range(struct vm_area_struc
 	unsigned long remap_pfn = pfn;
 	int err;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
+		return -EINVAL;
+
 	/*
 	 * Physically remapped pages are special. Tell the
 	 * rest of the world about it:
_
