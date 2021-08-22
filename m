Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F374C4338F
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 22:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B0946124B
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 22:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhHVWBO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Aug 2021 18:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231882AbhHVWBO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Aug 2021 18:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE4756120A;
        Sun, 22 Aug 2021 22:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629669632;
        bh=YU2EcaaIWAJLTjt3fNG+XDNrL6fRAOpEtgbM/a5w1OE=;
        h=Date:From:To:Subject:From;
        b=uBneiF6+dG38azOhac7BJMX+0O7ifLSOVl7Xs1WVj8vGBBIwmZ6rprioJiJRAEtuV
         c0Kxt/7cmKN7OpOpq7IrOIdta7r8E5HzOleKnjHOG5jNP8N9aDY7ftjvtbtDh3qu7O
         ZV8YApi53i3i5DtM1vOryPDkTFFQLji6tBOWqUV4=
Date:   Sun, 22 Aug 2021 15:00:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        mhocko@kernel.org, hannes@cmpxchg.org, hch@lst.de
Subject:  + mm-unexport-folio_memcg_unlock.patch added to -mm tree
Message-ID: <20210822220032.tEQdz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unexport folio_memcg_{,un}lock
has been added to the -mm tree.  Its filename is
     mm-unexport-folio_memcg_unlock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-unexport-folio_memcg_unlock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-unexport-folio_memcg_unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport folio_memcg_{,un}lock

Patch series "unexport memcg locking helpers".

Neither the old page-based nor the new folio-based memcg locking helpers
are used in modular code at all, so drop the exports.


This patch (of 2):

folio_memcg_{,un}lock are only used in built-in core mm code.

Link: https://lkml.kernel.org/r/20210820095815.445392-1-hch@lst.de
Link: https://lkml.kernel.org/r/20210820095815.445392-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~mm-unexport-folio_memcg_unlock
+++ a/mm/memcontrol.c
@@ -2014,7 +2014,6 @@ again:
 	memcg->move_lock_task = current;
 	memcg->move_lock_flags = flags;
 }
-EXPORT_SYMBOL(folio_memcg_lock);
 
 void lock_page_memcg(struct page *page)
 {
@@ -2048,7 +2047,6 @@ void folio_memcg_unlock(struct folio *fo
 {
 	__folio_memcg_unlock(folio_memcg(folio));
 }
-EXPORT_SYMBOL(folio_memcg_unlock);
 
 void unlock_page_memcg(struct page *page)
 {
_

Patches currently in -mm which might be from hch@lst.de are

mmc-jz4740-remove-the-flush_kernel_dcache_page-call-in-jz4740_mmc_read_data.patch
mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
mm-remove-flush_kernel_dcache_page.patch
proc-stop-using-seq_get_buf-in-proc_task_name.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

