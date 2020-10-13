Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE32C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D33E421D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633245;
	bh=ZUiRUd+TI4gD8W1PQh0i+fR97qz+OJPr/OObS+O6Mug=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=bT+wdiUhZSS8CPvLIiI3XAU6rIb34FLFJdXBDx8XfV/RuzlLBUTaunpEosZZW/q4D
	 6JjeeW0uy/lBY+NhXpTsyvaOC/egea/OkGgxLaY7ryqYC4y3tNnQCQKDPeaWhdTWey
	 xOlRESJA8CFZQr1Eng9Cx+HlUJ9JhjfTWcvakm2M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgJMXyF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbgJMXyF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE6A6221FF;
        Tue, 13 Oct 2020 23:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633245;
        bh=ZUiRUd+TI4gD8W1PQh0i+fR97qz+OJPr/OObS+O6Mug=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=08vl6rbFpJi7cdLbmDvYGAQLGjsRnbkH8jpOyx82pUxaGgpngI6AURP46WtKlRjtt
         3LZWQVc/uGxn9WtxFoMiu4xwRlbecM5lDBcPsPa2QTv8rc241PF17BFfbMf0joehf2
         zjD5ONeQoXN2ONGXs4tzm/K5veEKKLkxJeMJki08=
Date:   Tue, 13 Oct 2020 16:54:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 104/181] mm/mmap: not necessary to check mapping
 separately
Message-ID: <20201013235404.3mjS9F61G%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mmap: not necessary to check mapping separately

*root* with type of struct rb_root_cached is an element of *mapping*
with type of struct address_space. This implies when we have a valid
*root* it must be a part of valid *mapping*.

So we can merge these two checks together to make the code more easy to
read and to save some cpu cycles.

Link: https://lkml.kernel.org/r/20200913133631.37781-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-not-necessary-to-check-mapping-separately
+++ a/mm/mmap.c
@@ -895,10 +895,9 @@ again:
 			anon_vma_interval_tree_post_update_vma(next);
 		anon_vma_unlock_write(anon_vma);
 	}
-	if (mapping)
-		i_mmap_unlock_write(mapping);
 
 	if (root) {
+		i_mmap_unlock_write(mapping);
 		uprobe_mmap(vma);
 
 		if (adjust_next)
_
