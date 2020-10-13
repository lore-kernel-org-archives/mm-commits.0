Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF223C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63174208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633290;
	bh=EidSw18sm6TAJ8LoTWosO6B55f4v+xpMpnm5Vp6d6Vk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fpuqEMTq3lF1byZm8gONzU1WXzkp0rOZloDdJBdf9YES2sJ+xyPnoj+ZfoSe+PqOm
	 n3GwzpOs6kpFFAtUB3ot1aeMybZaDT2/E0p6EjMUNlJoewtkNoLICZA9V3zmlTF0rU
	 jZELXLjxv7DUDysliDwLE5oeJf4SGB7QG9J2x3a4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388163AbgJMXyu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXyt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B18D206D5;
        Tue, 13 Oct 2020 23:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633289;
        bh=EidSw18sm6TAJ8LoTWosO6B55f4v+xpMpnm5Vp6d6Vk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gTaquRLymRGf61YZqILfkxq9098PouY6qrT4hoLhWIwiyy62UWLTsmA680wg68Z7T
         Wz1J1YdBoHrkFpVdaibRne+iwFX75qDUR000yhQWrCkcEq4yn7oDoqxHAYmffQE1ez
         hp+opHjXiMnsaI/7i1hl6eyZyums7R3c9TyYVAAI=
Date:   Tue, 13 Oct 2020 16:54:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rpenyaev@suse.de, sh_def@163.com,
        torvalds@linux-foundation.org
Subject:  [patch 117/181] mm/vmalloc.c: update the comment in
 __vmalloc_area_node()
Message-ID: <20201013235448._bk1kYjle%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm/vmalloc.c: update the comment in __vmalloc_area_node()

Since c67dc624757 ("mm/vmalloc: do not call kmemleak_free() on not yet
accounted memory"), the __vunmap() have been changed to __vfree(), so
update the confusing comment().

Link: https://lkml.kernel.org/r/20200927155409.GA3315@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Penyaev <rpenyaev@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmallocc-update-the-comment-in-__vmalloc_area_node
+++ a/mm/vmalloc.c
@@ -2447,7 +2447,7 @@ static void *__vmalloc_area_node(struct
 			page = alloc_pages_node(node, alloc_mask|highmem_mask, 0);
 
 		if (unlikely(!page)) {
-			/* Successfully allocated i pages, free them in __vunmap() */
+			/* Successfully allocated i pages, free them in __vfree() */
 			area->nr_pages = i;
 			atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 			goto fail;
_
