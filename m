Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61EFC3DA6E
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiLPXLG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiLPXJ5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:09:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C30D7260F
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:09:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 511C6B81E3C
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03742C433F1;
        Fri, 16 Dec 2022 23:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671232188;
        bh=JMJqVE8MEgorlQV9NJGDJ941bXb5TrvNndpQyi5kKOM=;
        h=Date:To:From:Subject:From;
        b=tehWwkY1GZDc+4zyZ8ezDla+wylv7wxyj5JOl5Kr0lf0ctmUwdF6e6b6QsRrEbio4
         JeikkViEI6Eoi4HUeJ+GmUrMn+gMKCk+2dlmxT5N3qQs8vpUmDvStQIeBe+n+lMJLe
         5UJuc6M0vGWqeLs/cpEdjh/wQ5zYnIhFiXlkCNSg=
Date:   Fri, 16 Dec 2022 15:09:47 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-move-folio_set_compound_order-to-mm-internalh-update.patch removed from -mm tree
Message-Id: <20221216230948.03742C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-move-folio_set_compound_order-to-mm-internalh-update
has been removed from the -mm tree.  Its filename was
     mm-move-folio_set_compound_order-to-mm-internalh-update.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm-move-folio_set_compound_order-to-mm-internalh-update
Date: Tue, 13 Dec 2022 13:20:53 -0800

alter the folio_set_order() warning

Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/internal.h~mm-move-folio_set_compound_order-to-mm-internalh-update
+++ a/mm/internal.h
@@ -384,8 +384,10 @@ int split_free_page(struct page *free_pa
  */
 static inline void folio_set_order(struct folio *folio, unsigned int order)
 {
-	if (WARN_ON_ONCE(!folio_test_large(folio)))
+	if (!folio_test_large(folio)) {
+		WARN_ON_ONCE(order);
 		return;
+	}
 
 	folio->_folio_order = order;
 #ifdef CONFIG_64BIT
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-move-folio_set_compound_order-to-mm-internalh.patch

