Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C84C2D0A8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 402F82100A
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601339466;
	bh=LwUUmB0fRdjn/AcVqclE6I3ZWKofLcvm/FmQjGn4rDo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JCE1dQJ1stUl+69tEd8niRaFijhyqN822aYeW9W/o5E2Pwjz3Y5x8GOziKB1M8SRO
	 8JMRMlrovk5OiIs3lh4sB+ANUAXUN550CU750/ggV6u6e+qd30K5Du+GI/9sdVt+RR
	 +8+5r1A+a47F72Ekuc7KCEjDm9YCMeD7tDv6hYAo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgI2AbF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 20:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgI2AbD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 20:31:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B37B121531;
        Tue, 29 Sep 2020 00:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601339462;
        bh=LwUUmB0fRdjn/AcVqclE6I3ZWKofLcvm/FmQjGn4rDo=;
        h=Date:From:To:Subject:From;
        b=PArgLYjboDVnOXwOibhTcizwwIRkx8tllGQljtObfKQrBULV0FGNzA5v0iAmSin/Y
         A7eoVYEYOOfHi9YXobnX8f8OUBfuMItwiqHzVt6Wx2bhSUwhquUy+h9vTXCed0cNwy
         eL7Jg4wYwSpxLkhLfs6OFOxEe4gZ3T3Pn/Wl0KaY=
Date:   Mon, 28 Sep 2020 17:31:02 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rpenyaev@suse.de, sh_def@163.com
Subject:  +
 mm-vmallocc-update-the-comment-in-__vmalloc_area_node.patch added to -mm
 tree
Message-ID: <20200929003102.DROfIN7G1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: update the comment in __vmalloc_area_node()
has been added to the -mm tree.  Its filename is
     mm-vmallocc-update-the-comment-in-__vmalloc_area_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-update-the-comment-in-__vmalloc_area_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-update-the-comment-in-__vmalloc_area_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mmkmemleak-testc-move-kmemleak-testc-to-samples-dir.patch
mm-vmallocc-update-the-comment-in-__vmalloc_area_node.patch
mm-vmscan-fix-comments-for-isolate_lru_page.patch
mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch

