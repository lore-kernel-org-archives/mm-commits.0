Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0776FC001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjHDSMr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjHDSMZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:12:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1264C31
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD8E7620EE
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA72C433C7;
        Fri,  4 Aug 2023 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691172735;
        bh=8637oOan+u90jqyP9roBCWuSvG64Yq/W133DNoX7tEA=;
        h=Date:To:From:Subject:From;
        b=pBh97yf7uKJdA1Nb5CSSp3OV/dd5Rfunl0wkRiqxNby/P4zn9Rhz0eYC6C7CEa+JS
         42wdFmqFfrE0EzlsMJQrvK+esPstrKpzFx5kppSWM64TaG6rGvNaTHa3xFNivXm3lo
         i9+N5MBfok+I1T8lDeal7PgyRCkhahx4ufrEs4g0=
Date:   Fri, 04 Aug 2023 11:12:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmemc-use-helper-macro-k.patch added to mm-unstable branch
Message-Id: <20230804181215.3FA72C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: use helper macro K()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmemc-use-helper-macro-k.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmemc-use-helper-macro-k.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/shmem.c: use helper macro K()
Date: Fri, 4 Aug 2023 09:25:56 +0800

Use helper macro K() to improve code readability.  No functional
modification involved.

Link: https://lkml.kernel.org/r/20230804012559.2617515-5-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmemc-use-helper-macro-k
+++ a/mm/shmem.c
@@ -3881,8 +3881,7 @@ static int shmem_show_options(struct seq
 	struct mempolicy *mpol;
 
 	if (sbinfo->max_blocks != shmem_default_max_blocks())
-		seq_printf(seq, ",size=%luk",
-			sbinfo->max_blocks << (PAGE_SHIFT - 10));
+		seq_printf(seq, ",size=%luk", K(sbinfo->max_blocks));
 	if (sbinfo->max_inodes != shmem_default_max_inodes())
 		seq_printf(seq, ",nr_inodes=%lu", sbinfo->max_inodes);
 	if (sbinfo->mode != (0777 | S_ISVTX))
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-use-a-folio-in-fault_dirty_shared_page.patch
mm-remove-page_rmapping.patch
mm-page_io-remove-unneeded-clearpageuptodate.patch
mm-page_io-remove-unneeded-setpageerror.patch
mm-page_io-introduce-bio_first_folio_all.patch
mm-page_io-use-a-folio-in-__end_swap_bio_write.patch
mm-page_io-use-a-folio-in-__end_swap_bio_read.patch
mm-page_io-use-a-folio-in-sio_read_complete.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_async.patch
mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio.patch
mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch
mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch

