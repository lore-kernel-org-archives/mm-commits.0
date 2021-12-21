Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3022C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 21:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbhLUVeb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 16:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbhLUVeb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 16:34:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E89C061574
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 13:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C022B81A1D
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 21:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28295C36AE8;
        Tue, 21 Dec 2021 21:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640122467;
        bh=AHY71OjXtGHkZSTLlm1VSFRQDKRpg7ZCK1cFtJxeij0=;
        h=Date:From:To:Subject:From;
        b=gu+/OYO7XruE45iPp0FiWv6Xuboe39ojBiFrZypQWKbM1z5JS/7B0cIsOkhT4e4SV
         A8GVgAOI7eFfHKV3jaq8hgwBbB3D63YjXMeVlWgkAWXgfQFFCqAW+uANtoEONEUxYJ
         LYcADYqpCNxi+JHcBiJdB9oIzXtGd05OR7vmjQRw=
Date:   Tue, 21 Dec 2021 13:34:26 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com
Subject:  +
 mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch added to -mm
 tree
Message-ID: <20211221213426.2EVrQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove redundant variables used in a for-loop
has been added to the -mm tree.  Its filename is
     mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: mm/migrate: remove redundant variables used in a for-loop

The variable addr is being set and incremented in a for-loop but not
actually being used.  It is redundant and so addr and also variable start
can be removed.

Link: https://lkml.kernel.org/r/20211221185729.609630-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-redundant-variables-used-in-a-for-loop
+++ a/mm/migrate.c
@@ -2451,8 +2451,7 @@ static bool migrate_vma_check_page(struc
 static void migrate_vma_unmap(struct migrate_vma *migrate)
 {
 	const unsigned long npages = migrate->npages;
-	const unsigned long start = migrate->start;
-	unsigned long addr, i, restore = 0;
+	unsigned long i, restore = 0;
 	bool allow_drain = true;
 
 	lru_add_drain();
@@ -2498,7 +2497,7 @@ static void migrate_vma_unmap(struct mig
 		}
 	}
 
-	for (addr = start, i = 0; i < npages && restore; addr += PAGE_SIZE, i++) {
+	for (i = 0; i < npages && restore; i++) {
 		struct page *page = migrate_pfn_to_page(migrate->src[i]);
 
 		if (!page || (migrate->src[i] & MIGRATE_PFN_MIGRATE))
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch

