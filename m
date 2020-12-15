Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B06C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90B2C224D2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgLODFj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbgLODFP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:05:15 -0500
Date:   Mon, 14 Dec 2020 19:04:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001499;
        bh=hkNzidvI43DwL2VfgLvW4lN7Ifo+zbkNmGv8R9XLk5w=;
        h=From:To:Subject:In-Reply-To:From;
        b=yMDrVUtd3/lPAK2ZMKt2jFTgsntzBcTxcYG5o3bz05ykMdPyGaPn57Rw9B8TngdZ5
         pk9lj54a10ACI7QzYvRRyUJbHBrT4tHALQc4gOxzn1ErtlGzzwUwcdV3Q1y19UCzEV
         aYgCO36uEJDpmLCCGCZ5UvqCP1I14plxZhf70fHs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        corbet@lwn.net, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 030/200] mm/truncate: add parameter explanation
 for invalidate_mapping_pagevec
Message-ID: <20201215030459.rZY-5NI3k%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/truncate: add parameter explanation for invalidate_mapping_pagevec

To fix a kernel-doc markups issue:
mm/truncate.c:646: warning: Function parameter or member 'mapping' not
described in 'invalidate_mapping_pagevec'
mm/truncate.c:646: warning: Function parameter or member 'start' not
described in 'invalidate_mapping_pagevec'
mm/truncate.c:646: warning: Function parameter or member 'end' not
described in 'invalidate_mapping_pagevec'
mm/truncate.c:646: warning: Function parameter or member 'nr_pagevec'
not described in 'invalidate_mapping_pagevec'

Link: https://lkml.kernel.org/r/1605605088-30668-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/truncate.c~mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec
+++ a/mm/truncate.c
@@ -637,9 +637,15 @@ unsigned long invalidate_mapping_pages(s
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
 /**
- * This helper is similar with the above one, except that it accounts for pages
- * that are likely on a pagevec and count them in @nr_pagevec, which will used by
- * the caller.
+ * invalidate_mapping_pagevec - Invalidate all the unlocked pages of one inode
+ * @mapping: the address_space which holds the pages to invalidate
+ * @start: the offset 'from' which to invalidate
+ * @end: the offset 'to' which to invalidate (inclusive)
+ * @nr_pagevec: invalidate failed page number for caller
+ *
+ * This helper is similar with invalidate_mapping_pages, except that it accounts
+ * for pages that failed to invalidate on a pagevec and count them in
+ * @nr_pagevec, which will used by the caller.
  */
 void invalidate_mapping_pagevec(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_pagevec)
_
