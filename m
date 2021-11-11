Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB37C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF89C610C8
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhKKEf0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 23:35:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhKKEf0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 23:35:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82B0761052;
        Thu, 11 Nov 2021 04:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636605157;
        bh=Vrif5JLMGZiX2MKd33Aiziwu5UcgP4WpoXhwcOFV8GY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WiPm6Cy2goAU0Xop/CFsSe8devqgoMMnAaWaEJMsJfabOnwW9JFxQTAzYDxehBb0U
         bXjaktaA91e2ccrf/CYPOGd4Bv8kEUVvnmloJjx1bUWhh5BBOD5SfAyEMzUiX5Q6hZ
         q9pisE93APEHzoB7e3rSM1xQOEgFwb3Ks8cZ2VCY=
Date:   Wed, 10 Nov 2021 20:32:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 3/7] mm: migrate: simplify the file-backed pages
 validation when migrating its mapping
Message-ID: <20211111043237.NQd7m0u64%akpm@linux-foundation.org>
In-Reply-To: <20211110203204.37de96048c3279ab2da758a5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: simplify the file-backed pages validation when migrating its mapping

There is no need to validate the file-backed page's refcount before trying
to freeze the page's expected refcount, instead we can rely on the
folio_ref_freeze() to validate if the page has the expected refcount
before migrating its mapping.

Moreover we are always under the page lock when migrating the page
mapping, which means nowhere else can remove it from the page cache, so we
can remove the xas_load() validation under the i_pages lock.

Link: https://lkml.kernel.org/r/cover.1629447552.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/df4c129fd8e86a95dbc55f4663d77441cc0d3bd1.1629447552.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/migrate.c~mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping
+++ a/mm/migrate.c
@@ -404,12 +404,6 @@ int folio_migrate_mapping(struct address
 	newzone = folio_zone(newfolio);
 
 	xas_lock_irq(&xas);
-	if (folio_ref_count(folio) != expected_count ||
-	    xas_load(&xas) != folio) {
-		xas_unlock_irq(&xas);
-		return -EAGAIN;
-	}
-
 	if (!folio_ref_freeze(folio, expected_count)) {
 		xas_unlock_irq(&xas);
 		return -EAGAIN;
_
