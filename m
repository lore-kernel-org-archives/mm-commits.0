Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB5CC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FBD5221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709320;
	bh=6UpZWAonICaEdhG0WuycnOAJL5Lu8+eeGHMftgsqIjg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RXhLhgNHMPmNkYAbfQUY03c5RXifVgasfzdpjdTepvGeP6VkHM4g0AccIeqUEHMyg
	 jnXJkJiNGknyF4jYGwSH0L1SYmemlkfQ+xnOB6OdTGaWerp0ZpWpDgU/cEn+5/JiB9
	 dc+fX5H+27efNLQzyr96MF2wohZFFGgwwOLvjfsM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbgJNVB7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbgJNVB7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 896372224D;
        Wed, 14 Oct 2020 21:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709317;
        bh=6UpZWAonICaEdhG0WuycnOAJL5Lu8+eeGHMftgsqIjg=;
        h=Date:From:To:Subject:From;
        b=McTQOKLlMJDVt6BBu1amZhybDYfzRlZNotdEJQ8LVRzyKyN2W0hCgYM7+wQsdHy2w
         9Ip553/eC9UGXXkvhjieo4OsMqjon/ZGLlATo+hiGuwC4NEdJ5mNRkKRmpZiTKZZ5J
         X39dXcEtWdYgsw533JMZxnSIEF9ASt81TWh5Fi7A=
Date:   Wed, 14 Oct 2020 14:01:57 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rpenyaev@suse.de, sh_def@163.com
Subject:  [merged]
 mm-vmallocc-update-the-comment-in-__vmalloc_area_node.patch removed from
 -mm tree
Message-ID: <20201014210157.gyi42ivMM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: update the comment in __vmalloc_area_node()
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-update-the-comment-in-__vmalloc_area_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sh_def@163.com are


