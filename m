Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7301C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B16A361424
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhD3FyO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3FyO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0731961452;
        Fri, 30 Apr 2021 05:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762005;
        bh=nxrgvCNfAhfrtHgMoCCb5Z6TjcT+pq9I5zc2LqIerCE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MLI57/2zP37xlWzChzJJSDF9/SxqAfcL72ETNZ+ZgSVQ5nPNrE/3b6Il8xLQqVOXl
         3C16Ze7En5mJV4eksmepaJhNA+hhLbvJsk8nlteM93Od4Gdtv6lD9nEmG4wd2X0JG5
         kxPbSBMkIDoiJPxOQe07fwIshT6VBDYgT+kGGpJM=
Date:   Thu, 29 Apr 2021 22:53:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, unixbhaskar@gmail.com
Subject:  [patch 003/178] arch/ia64/include/asm/pgtable.h: minor
 typo fixes
Message-ID: <20210430055324.SyEIzGhJj%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: arch/ia64/include/asm/pgtable.h: minor typo fixes

s/migraton/migration/

Link: https://lkml.kernel.org/r/20210313045519.9310-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/include/asm/pgtable.h~ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh
+++ a/arch/ia64/include/asm/pgtable.h
@@ -328,7 +328,7 @@ extern void __ia64_sync_icache_dcache(pt
 static inline void set_pte(pte_t *ptep, pte_t pteval)
 {
 	/* page is present && page is user  && page is executable
-	 * && (page swapin or new page or page migraton
+	 * && (page swapin or new page or page migration
 	 *	|| copy_on_write with page copying.)
 	 */
 	if (pte_present_exec_user(pteval) &&
_
