Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1416C001DB
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbjIBWRx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbjIBWRx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:17:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B06CE0
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7BD20CE0159
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AC1C433C7;
        Sat,  2 Sep 2023 22:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693693066;
        bh=CkAAmEdAw8yy8XbnWYJb9hzIcCZyF+0f0QQNhYH7DmQ=;
        h=Date:To:From:Subject:From;
        b=X2FRGEU4qTKsnKHM8XsYaEcz7BS/iMTbrzFZLP5ghD+6PK9AOi6z+8Y+SyQWLuYDN
         M/w/3C1ww+oYslfEfUsIzgHlayN7+ezVaqOSMNld9DRpB94Pk0tYYpgv8M9nvUcvfC
         zA7eUGw9qi4z3lAotatWRsFtYnmP2rkMI8R1w+C4=
Date:   Sat, 02 Sep 2023 15:17:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-add-pageoffline-check.patch removed from -mm tree
Message-Id: <20230902221746.C5AC1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: add PageOffline() check
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-add-pageoffline-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: add PageOffline() check
Date: Thu, 27 Jul 2023 19:56:43 +0800

Memory failure is not interested in logically offlined pages.  Skip this
type of page.

Link: https://lkml.kernel.org/r/20230727115643.639741-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-add-pageoffline-check
+++ a/mm/memory-failure.c
@@ -1562,7 +1562,7 @@ static bool hwpoison_user_mappings(struc
 	 * Here we are interested only in user-mapped pages, so skip any
 	 * other types of pages.
 	 */
-	if (PageReserved(p) || PageSlab(p) || PageTable(p))
+	if (PageReserved(p) || PageSlab(p) || PageTable(p) || PageOffline(p))
 		return true;
 	if (!(PageLRU(hpage) || PageHuge(p)))
 		return true;
@@ -2533,7 +2533,8 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (folio_test_slab(folio) || PageTable(&folio->page) || folio_test_reserved(folio))
+	if (folio_test_slab(folio) || PageTable(&folio->page) ||
+	    folio_test_reserved(folio) || PageOffline(&folio->page))
 		goto unlock_mutex;
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


