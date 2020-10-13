Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03039C41604
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C026122202
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633206;
	bh=RkuaPyQYUJLk6blwM1DPnf1Jmrv39+1/zWva+x633ak=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=urDXTvYFaBMxILfClJOex4NWcXBzRXKaHZHQOaatn2KvuQa6fgffAxB7TLBKi6CC0
	 bLP5d3HDw57uUniGEIUGmOXc43KrDByqgbuYS3l+1fIE90jwNdyud6Hw6Ipyv5n3zD
	 iSgjSFA4q7mM/AmewKnDbGMfIKzehXXjZ+tUhQh0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbgJMXxZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728770AbgJMXwV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7276222200;
        Tue, 13 Oct 2020 23:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633141;
        bh=RkuaPyQYUJLk6blwM1DPnf1Jmrv39+1/zWva+x633ak=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cgRMPrmgzfxqZIVeo0F+uD9UqI88FIVnPUZYzlkdKCs4Ih3yktRMAnXCWnTkTfqUi
         lZ8O0LSF1GYdLGDIhOWAzcgBSVpc4idRAgdlb00JRlCifAmUAgaFzH9osp6r7Dq0E9
         8+vop9dzI9xt/SzRJfNTKd30pkBbn2T40a3Zq8X0=
Date:   Tue, 13 Oct 2020 16:52:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 073/181] mm/page_io.c: remove useless out label in
 __swap_writepage()
Message-ID: <20201013235221.ic7jFtxvw%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
