Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACB9C4741F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1886322268
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604279272;
	bh=/MxUlEfcElWPe3LT9+qZBcymP0VX+et0nSCQjv3lk4I=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MGJqJfXlXWSqdhDEfbbQ7pim+yuBt/uPQoG2jjRD3exZ5OtSWzjPUFALUThrWj9cz
	 mnYeM/d7LVlOl29YVEIunjssI7Sl+6xeUK+K9oYIX8ljO1IR7G5nB5FzNuxRzEbCfm
	 cRyZFF9AwX2pXJE9b1HM7KcW11jHbs9ewrYdg2js=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgKBBHv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:07:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBHv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:07:51 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2073E22277;
        Mon,  2 Nov 2020 01:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279271;
        bh=/MxUlEfcElWPe3LT9+qZBcymP0VX+et0nSCQjv3lk4I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y7xaiI+d0/aPnq5IsiulhHy76ZhfOjpn7339XzTDQrgTXXnr6VrGfLfZV2z+tz4Ij
         ygOm4s8qTahCzsFKfjptDAiMYJZwTUb2JlffHrYY2y2AUR8+kW38P7E5pTMYN7DCih
         K7oHMLvLQbpQdSeOrKVRJ3FKMI9QnDSLpAXcblQw=
Date:   Sun, 01 Nov 2020 17:07:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, laoar.shao@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yanaijie@huawei.com
Subject:  [patch 09/15] mm/truncate.c: make
 __invalidate_mapping_pages() static
Message-ID: <20201102010750.-q3HdsXwP%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Subject: mm/truncate.c: make __invalidate_mapping_pages() static

Fix the following sparse warning:

mm/truncate.c:531:15: warning: symbol '__invalidate_mapping_pages' was
not declared. Should it be static?

Link: https://lkml.kernel.org/r/20201015054808.2445904-1-yanaijie@huawei.com
Fixes: eb1d7a65f08a ("mm, fadvise: improve the expensive remote LRU cache draining after FADV_DONTNEED")
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/truncate.c~mm-make-__invalidate_mapping_pages-static
+++ a/mm/truncate.c
@@ -528,7 +528,7 @@ void truncate_inode_pages_final(struct a
 }
 EXPORT_SYMBOL(truncate_inode_pages_final);
 
-unsigned long __invalidate_mapping_pages(struct address_space *mapping,
+static unsigned long __invalidate_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_pagevec)
 {
 	pgoff_t indices[PAGEVEC_SIZE];
_
