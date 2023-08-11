Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786B2C04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbjHKXNG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237042AbjHKXNC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C59A3A9E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B81DC666E3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A84C433C7;
        Fri, 11 Aug 2023 23:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794951;
        bh=lDM7fqyaimhIVI/pA/bTSsIJ4aQekwxUUIqeaK+uQj4=;
        h=Date:To:From:Subject:From;
        b=EzBJWN/7Ot3y1+gx8R0m0/xxzpiNdZXnKrA2fazoZF50AvlFZ7f+eKqgeJhcYi1t1
         I45hisfltG79boOkBmRp30IuV7r3qYp8AHkEg59D5fS4+eNfSNVCTZXKx4CTBpCzE3
         3I4uxJr2R4vLdCsrzgGE5qeENUzfr4uB7C6iMe60=
Date:   Fri, 11 Aug 2023 16:02:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, hch@infradead.org,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-use-a-folio-in-sio_read_complete.patch removed from -mm tree
Message-Id: <20230811230231.19A84C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_io: use a folio in sio_read_complete()
has been removed from the -mm tree.  Its filename was
     mm-page_io-use-a-folio-in-sio_read_complete.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/page_io: use a folio in sio_read_complete()
Date: Fri, 21 Jul 2023 11:44:47 +0800

Saves one implicit call to compound_head().

Link: https://lkml.kernel.org/r/20230721034451.16412-7-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-page_io-use-a-folio-in-sio_read_complete
+++ a/mm/page_io.c
@@ -403,17 +403,17 @@ static void sio_read_complete(struct kio
 
 	if (ret == sio->len) {
 		for (p = 0; p < sio->pages; p++) {
-			struct page *page = sio->bvec[p].bv_page;
+			struct folio *folio = page_folio(sio->bvec[p].bv_page);
 
-			SetPageUptodate(page);
-			unlock_page(page);
+			folio_mark_uptodate(folio);
+			folio_unlock(folio);
 		}
 		count_vm_events(PSWPIN, sio->pages);
 	} else {
 		for (p = 0; p < sio->pages; p++) {
-			struct page *page = sio->bvec[p].bv_page;
+			struct folio *folio = page_folio(sio->bvec[p].bv_page);
 
-			unlock_page(page);
+			folio_unlock(folio);
 		}
 		pr_alert_ratelimited("Read-error on swap-device\n");
 	}
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

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
mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch

