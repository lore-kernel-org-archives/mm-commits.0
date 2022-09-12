Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E143FECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiILDeH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiILDca (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C4628733
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94537B80C76
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C07EC433C1;
        Mon, 12 Sep 2022 03:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953415;
        bh=FR+0zA4RbZSbqdq4M++FolT2Kkz9Ro0A0tII0Z5Lt/k=;
        h=Date:To:From:Subject:From;
        b=OlWABLez+ck3J0ZAYQbCb5HjbIJh+yxbLQfmGI5X9hNRvKXfCW/1Mx5N/vwmw5UIL
         uZn5K3S1wTx1zd7Hw0u1ry75OLZQwl39PEW9xQjEUp8u2esb1zjeLgcncuHRaf8q60
         qKK+oT7+N/WvgC0vHKgXtpowf+ju5L/cf44or1ZE=
Date:   Sun, 11 Sep 2022 20:30:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-remove-redundant-config_transparent_hugepage.patch removed from -mm tree
Message-Id: <20220912033015.3C07EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/thp: remove redundant CONFIG_TRANSPARENT_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     mm-thp-remove-redundant-config_transparent_hugepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/thp: remove redundant CONFIG_TRANSPARENT_HUGEPAGE
Date: Mon, 29 Aug 2022 17:51:25 +0800

Simplify code by removing redundant CONFIG_TRANSPARENT_HUGEPAGE judgment.

No functional change.

Link: https://lkml.kernel.org/r/20220829095125.3284567-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/pgtable.h~mm-thp-remove-redundant-config_transparent_hugepage
+++ a/include/linux/pgtable.h
@@ -1276,8 +1276,7 @@ static inline int pgd_devmap(pgd_t pgd)
 #endif
 
 #if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
-	(defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
-	 !defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
+	!defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 static inline int pud_trans_huge(pud_t pud)
 {
 	return 0;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-shuffle-convert-module_param_call-to-module_param_cb.patch
mm-kfence-convert-to-define_seq_attribute.patch
mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch

