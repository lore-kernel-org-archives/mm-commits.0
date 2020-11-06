Return-Path: <SRS0=pZAw=EM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21AFC2D0A3
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 23:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7279A20867
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 23:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604704645;
	bh=OIEe56Wd06bT9IsMygYMO9f5wrkcizA1o9glxTGhmmE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=AkpwRMeADYcKsRCG9Q6B85Bw0x1K0WD+4SiJgTXgPL2g/CRvbmUuHlJzoqaU8H5A3
	 wjw3r+kdtMbTl6wcZnR9lM4NuEW8hUXD3CAJJvqZxzNaDq6DSIcqfYIjiDuiccdo0z
	 Wd22sH27D+8SiswsG2QyDA5V2iCzGGf7g7EnZoAM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgKFXRY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Nov 2020 18:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbgKFXRY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Nov 2020 18:17:24 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5FD2206A5;
        Fri,  6 Nov 2020 23:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604704643;
        bh=OIEe56Wd06bT9IsMygYMO9f5wrkcizA1o9glxTGhmmE=;
        h=Date:From:To:Subject:From;
        b=GntLjRm9mhPtycBTzTaZBRA7RdxJzIMUzWj4QBGJu7vf+tG2CIfkefgeV+CMpoNQ+
         VJbEzrit4nb+eTQQ5nEjTu17qIQBr2jeU02PUiVIdSaVypS1WzuMkDgDkbAjMuXMwL
         prxDN4R6ZYSvvNIu0s3OZVW296r52kC7VUhEOfNs=
Date:   Fri, 06 Nov 2020 15:17:23 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org
Subject:  +
 mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch added
 to -mm tree
Message-ID: <20201106231723.Hxk-LVciS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: add static for function __add_to_page_cache_locked
has been added to the -mm tree.  Its filename is
     mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/filemap: add static for function __add_to_page_cache_locked

../mm/filemap.c:830:14: warning: no previous prototype for
`__add_to_page_cache_locked' [-Wmissing-prototypes]
 noinline int __add_to_page_cache_locked(struct page *page,

Link: https://lkml.kernel.org/r/1604661895-5495-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-add-static-for-function-__add_to_page_cache_locked
+++ a/mm/filemap.c
@@ -827,7 +827,7 @@ int replace_page_cache_page(struct page
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
-noinline int __add_to_page_cache_locked(struct page *page,
+static noinline int __add_to_page_cache_locked(struct page *page,
 					struct address_space *mapping,
 					pgoff_t offset, gfp_t gfp,
 					void **shadowp)
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

