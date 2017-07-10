From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch removed from -mm tree
Date: Mon, 10 Jul 2017 15:31:01 -0700
Message-ID: <59640025.IRxpWl+HThPAPzI+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41212 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754233AbdGJWbC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:31:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch

This patch was dropped because it was folded into mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix

fix unused var warnings

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix
+++ a/mm/memory-failure.c
@@ -611,7 +611,6 @@ static int me_unknown(struct page *p, un
  */
 static int me_pagecache_clean(struct page *p, unsigned long pfn)
 {
-	int err;
 	struct address_space *mapping;
 
 	delete_from_lru_cache(p);
@@ -758,8 +757,6 @@ static int me_huge_page(struct page *p,
 	if (mapping) {
 		res = truncate_error_page(hpage, pfn, mapping);
 	} else {
-		int dissolve_ret;
