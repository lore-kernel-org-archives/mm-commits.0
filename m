Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2935C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A56FA22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709187;
	bh=1oZMiciXdMykpjosUnsj7+AVKmaZ4/cx0zUsF2gk7eM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cy0ggJF5BCLrbteyRrQAzOXyC659Py2qq9d3k5XbFTRbQuAtPn9cKyhSTRJvd9qcZ
	 85KdzrlFwSnzuFWT08Hv10p8khocTpLGbcT6vmt8CCZfbmfJFPlybKHCEGANDGZsrr
	 OCIhXBCohfNBL/DQ81W6cZhj1TZMXh1CJ7lceEO8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389539AbgJNU7r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389383AbgJNU7r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 920FF2068E;
        Wed, 14 Oct 2020 20:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709186;
        bh=1oZMiciXdMykpjosUnsj7+AVKmaZ4/cx0zUsF2gk7eM=;
        h=Date:From:To:Subject:From;
        b=cbtRywwEXtOckwvXFJwKdmGJL8GTpTnHEYsLB5CL7I7XwAUBppfh3EXk27Zn/NHHs
         tk8g5ciY2hz/h0+wHcbykoV3+bxtHcZ61CLGV/EiTL3wk/hwEoRrWh8CEqQqUjtbPO
         dOp30Fu7oEn9DXcoKLUVOqTe1sFph4iJ3+Quj5/s=
Date:   Wed, 14 Oct 2020 13:59:46 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-remove-useless-out-label-in-__swap_writepage.patch removed from -mm tree
Message-ID: <20201014205946.LMGh271u6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io.c: remove useless out label in __swap_writepage()
has been removed from the -mm tree.  Its filename was
     mm-remove-useless-out-label-in-__swap_writepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_io.c: remove useless out label in __swap_writepage()

The out label is only used in one place and return ret directly without
something like resource cleanup or lock release and so on.  So we should
remove this jump label and do some cleanup.

Link: https://lkml.kernel.org/r/20200927124032.22521-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-remove-useless-out-label-in-__swap_writepage
+++ a/mm/page_io.c
@@ -359,13 +359,11 @@ int __swap_writepage(struct page *page,
 		return 0;
 	}
 
-	ret = 0;
 	bio = get_swap_bio(GFP_NOIO, page, end_write_func);
 	if (bio == NULL) {
 		set_page_dirty(page);
 		unlock_page(page);
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 	bio->bi_opf = REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc);
 	bio_associate_blkg_from_page(bio, page);
@@ -373,8 +371,8 @@ int __swap_writepage(struct page *page,
 	set_page_writeback(page);
 	unlock_page(page);
 	submit_bio(bio);
-out:
-	return ret;
+
+	return 0;
 }
 
 int swap_readpage(struct page *page, bool synchronous)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

