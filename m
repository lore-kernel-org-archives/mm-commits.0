Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1710EE49AA
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjHUUoX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjHUUni (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B58ACF0
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48A3364B18
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98222C433C8;
        Mon, 21 Aug 2023 20:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650531;
        bh=1s7k0Ph+IlZc3o1Hhv/BpDO5VbixeQKHBXRwg1oNQbQ=;
        h=Date:To:From:Subject:From;
        b=k5drId69pvLEYZuoXfRn4ViWp4AYliA/rBDHkiV/UM4VWQYNqhosVvDW0GV0um616
         TZ/Tu1wG75YVeze7vNRdx3A2OB2hhG4DvzkAwfEFNk+hLmUJvEefSYgCdHmIitv1Mx
         cnDDY+jCWjHTfNX4gf9YwRuZRGmzJ0lLi45RAgU4=
Date:   Mon, 21 Aug 2023 13:42:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] pagemap-remove-wait_on_page_locked_killable.patch removed from -mm tree
Message-Id: <20230821204211.98222C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: pagemap: remove wait_on_page_locked_killable()
has been removed from the -mm tree.  Its filename was
     pagemap-remove-wait_on_page_locked_killable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: pagemap: remove wait_on_page_locked_killable()
Date: Tue, 15 Aug 2023 11:06:09 +0800

There is no users of wait_on_page_locked_killable(), remove it.

Link: https://lkml.kernel.org/r/20230815030609.39313-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/pagemap.h~pagemap-remove-wait_on_page_locked_killable
+++ a/include/linux/pagemap.h
@@ -1060,11 +1060,6 @@ static inline void wait_on_page_locked(s
 	folio_wait_locked(page_folio(page));
 }
 
-static inline int wait_on_page_locked_killable(struct page *page)
-{
-	return folio_wait_locked_killable(page_folio(page));
-}
-
 void wait_on_page_writeback(struct page *page);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


